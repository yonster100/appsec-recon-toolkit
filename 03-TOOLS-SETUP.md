# Step 4 — Tools setup (Burp / ZAP / Postman)

These are the tools are commonly used. Set them up once; reuse every engagement.

## Burp Suite (proxy + scanner) — the core AppSec tool
- Download Burp Suite Community (free): https://portswigger.net/burp/communitydownload
- It proxies your browser traffic so you can see and modify every request.
- Setup:
  1. Install, launch, "Temporary project" → default settings.
  2. Use the built-in browser (Proxy tab → "Open browser") — no cert hassle.
  3. Browse the target through it; every request lands in Proxy → HTTP history.
  4. Key tools: **Repeater** (replay/modify a single request — perfect for IDOR),
     **Intruder** (limited in Community), **Decoder** (base64/URL encode-decode).
- This replaces manually decoding base64 by hand — Decoder does it instantly.

## OWASP ZAP (free alternative/complement to Burp)
- Download: https://www.zaproxy.org/download/
- Good for an authorized **automated passive scan** first, active scan only if
  approved. Passive scan just analyzes traffic you generate — safe.

## Postman (API testing) — a common demo
- Download: https://www.postman.com/downloads/
- Build a collection from the endpoints you found in recon.
- Auth tab: set Bearer token / API key to test auth boundaries.
- Great for mass-assignment and "call endpoint without/with wrong token" tests.

## Recommendation for an engagement
1. Do passive recon in the browser DevTools (free, immediate).
2. Route the browser through **Burp** to capture the full request/response map.
3. Use **Burp Repeater** for manual IDOR/access-control tests (change one ID, resend).
4. Use **Postman** for structured API auth tests.
5. Only run ZAP/Burp **active scan** if that test type is authorized — it sends
   lots of probing traffic and can be noisy/impactful on prod.
