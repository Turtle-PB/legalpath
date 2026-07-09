
  // ================================================================
  // SW SECURITY BUSTER — runs before anything else on the page.
  // If an old service worker (v1 cache-first) is active, we purge
  // ALL caches and unregister it, then force a hard reload from
  // the network so the Netlify Edge Function auth gate runs.
  // ================================================================
  (function() {
    if (!('serviceWorker' in navigator)) return;
    navigator.serviceWorker.getRegistrations().then(function(regs) {
      if (regs.length === 0) return; // no SW, nothing to bust
      // We have a SW — check if it's the secure v2 by looking at cache names.
      // If any cache other than 'legalpath-v2' exists, nuke everything.
      caches.keys().then(function(keys) {
        var hasOld = keys.some(function(k) { return k !== 'legalpath-v2'; });
        if (hasOld) {
          // Purge all caches
          Promise.all(keys.map(function(k) { return caches.delete(k); })).then(function() {
            // Unregister all SWs
            return Promise.all(regs.map(function(r) { return r.unregister(); }));
          }).then(function() {
            // Hard reload from network — edge auth will run
            window.location.reload();
          });
        }
      });
    });
  })();

  // Service Worker registration — deferred until AFTER edge auth succeeds.
  // The service worker is only registered once we know the page loaded
  // through Netlify's Edge Function auth gate, so it can never serve
  // cached content without authentication.
  if ('serviceWorker' in navigator) {
    // Listen for kill-switch reload from the self-destructing SW
    navigator.serviceWorker.addEventListener('message', function(event) {
      if (event.data && event.data.type === 'KILLSWITCH_RELOAD') {
        navigator.serviceWorker.getRegistrations().then(function(regs) {
          Promise.all(regs.map(function(r) { return r.unregister(); })).then(function() {
            window.location.reload(true);
          });
        });
      }
    });

    // Only register the SW after the page is fully interactive (post-auth)
    window.addEventListener('load', function() {
      navigator.serviceWorker.register('sw.js').catch(function(e) {
        console.warn('Service Worker registration failed:', e);
      });
    });
  }
