# Step 2 — Passive Recon (observation only, no attacks)

Passive recon = looking at what the server already sends your browser. It's the
first real deliverable and it's low-risk. Still do it under the authorization
from Step 1. Everything below is "read, note, screenshot" — no tampering yet.

## A. Fingerprint the tech stack (this is what "inspect")
Open the site, DevTools (Cmd+Opt+I):
- [ ] **Network tab → reload.** Note the main document, JS/CSS bundles, XHR/fetch
      calls. Which files load? From the site itself or a CDN?
- [ ] **Framework detection.** Long hashed JS bundles + a single small HTML shell
      usually = a SPA (React/Vue/Angular). Careers SaaS apps are usually framework-based. Note it.
- [ ] **Response headers** (click the main request → Headers). Record:
      `Server`, `X-Powered-By`, `Set-Cookie` flags (HttpOnly? Secure? SameSite?),
      `Content-Security-Policy`, `Strict-Transport-Security`, `X-Frame-Options`.
      Missing security headers are legitimate low/info findings.
- [ ] **Cookies** (Application tab → Cookies). HttpOnly + Secure set? If a session
      cookie lacks HttpOnly, note it (XSS could steal it).

Quick header pull from terminal (equivalent to visiting the page):
```bash
curl -sSI https://TARGET/ | tee ~/security-practice/appsec-toolkit/evidence/headers.txt
```

## B. Map the application surface
- [ ] List every page/route you can reach (job listing, view, apply, login).
- [ ] **Network tab → filter Fetch/XHR.** Record every API endpoint the frontend
      calls (path, method, params). This is your API map for later testing.
- [ ] Note any `/api/...` base path, versioning (`/v1/`), and query/body params.
- [ ] Look for auth: is there a token in localStorage / a JWT / a session cookie?

## C. Inspect client-side code & storage (base64 skill applies here)
- [ ] **Sources tab:** open the main JS bundle. Cmd+F for: `key`, `token`,
      `secret`, `password`, `apikey`, `admin`, `config`, `http`.
- [ ] **Application tab → Local/Session Storage:** decode any base64/JWT values
      (`atob('...')` in Console). Sensitive data readable client-side = finding.
- [ ] **HTML comments & hidden inputs** (Elements tab): secrets/internal notes?
- [ ] `robots.txt`, `sitemap.xml`, `/.well-known/security.txt` — check if present.

## D. Record everything as you go
Put screenshots + notes in `evidence/`. Each candidate becomes a row in your
findings tracker. Don't decide severity yet — just collect.

## What passive recon does NOT include (that's Step 3, needs explicit OK)
- Submitting tampered values, fuzzing params, uploading files, brute forcing,
  automated active scans, hitting APIs with modified tokens. All active =
  requires the "allowed test types" boxes checked in Step 1.
