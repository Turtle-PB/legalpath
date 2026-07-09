// LegalPath Service Worker v2 — network-first for HTML, cache-first for assets
// © 2025 Paul Adcock — Patent Pending
//
// CRITICAL: Navigation requests (HTML pages) use NETWORK-FIRST so that
// the Netlify Edge Function auth gate always runs before any cached
// content is served. A 401 response passes through to the browser's
// auth prompt — it is NOT treated as a network failure.
// Static assets remain cache-first for performance and offline support.

const CACHE_NAME = 'legalpath-v2';
const ASSETS = [
  './',
  './index.html',
  './manifest.json'
];

// Install — cache core assets, force activation
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(ASSETS)).catch(() => {})
  );
  self.skipWaiting();
});

// Activate — purge ALL old caches (kills v1 which had insecure cache-first strategy)
// Then force all open clients to reload so the edge auth gate runs.
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))
    )).then(() => {
      return self.clients.matchAll({ type: 'window' });
    }).then(clients => {
      clients.forEach(client => client.navigate(client.url));
    })
  );
  self.clients.claim();
});

// Fetch — strategy depends on request type
self.addEventListener('fetch', event => {
  if (event.request.method !== 'GET') return;

  const isNavigation = event.request.mode === 'navigate';

  if (isNavigation) {
    // NETWORK-FIRST for HTML pages — ensures edge auth always runs.
    // Only fall back to cache if the network is completely down (offline).
    // A 401 response is a valid response, NOT a network failure.
    event.respondWith(
      fetch(event.request)
        .then(response => {
          if (response.ok) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone)).catch(() => {});
          }
          return response; // 401 passes through to browser auth prompt
        })
        .catch(() => {
          // Network failed entirely (offline) — serve cached page as last resort
          return caches.match(event.request).then(cached => {
            return cached || caches.match('./index.html');
          });
        })
    );
  } else {
    // CACHE-FIRST for static assets (JS, CSS, images, fonts, CDN resources)
    event.respondWith(
      caches.match(event.request).then(cached => {
        if (cached) return cached;
        return fetch(event.request).then(response => {
          if (response.ok && event.request.url.startsWith(self.location.origin)) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then(cache => cache.put(event.request, clone)).catch(() => {});
          }
          return response;
        }).catch(() => {});
      })
    );
  }
});
