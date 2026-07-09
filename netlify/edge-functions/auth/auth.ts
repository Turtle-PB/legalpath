// LegalPath — Edge Function: HTTP Basic Auth
// Enforces username/password at the edge before any static file is served.
// Free-plan compatible (Netlify Edge Functions, Deno runtime).

const USERNAME = "impact";
const PASSWORD = "owl";
const REALM = "LegalPath";

function unauthorized(): Response {
  return new Response("Unauthorized", {
    status: 401,
    headers: {
      "WWW-Authenticate": `Basic realm="${REALM}", charset="UTF-8"`,
    },
  });
}

function constantTimeEquals(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return result === 0;
}

export default async (request: Request, context: any): Promise<Response> => {
  const auth = request.headers.get("Authorization");

  if (!auth || !auth.startsWith("Basic ")) {
    return unauthorized();
  }

  try {
    const decoded = atob(auth.slice(6));
    const colonIdx = decoded.indexOf(":");
    if (colonIdx === -1) return unauthorized();
    const user = decoded.slice(0, colonIdx);
    const pass = decoded.slice(colonIdx + 1);

    if (constantTimeEquals(user, USERNAME) && constantTimeEquals(pass, PASSWORD)) {
      return await context.next();
    }
  } catch {
    // fall through to unauthorized
  }

  return unauthorized();
};
