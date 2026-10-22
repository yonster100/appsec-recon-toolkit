# Step 3 — Web App Test Plan (job-board / careers SaaS app)

Run these only against in-scope assets with the test types your mentor approved
in Step 1, using provided test accounts (never real applicant data). Mapped to
OWASP Top 10 and tailored to a careers/job-board app. Each item: what to test,
how, and what "insecure vs secure" looks like.

Legend: [P]=passive/safe  [A]=active (needs explicit authorization)

## 1. Authentication & session (OWASP A07)
- [A] Weak/absent rate limiting on login → try a few wrong passwords, watch for lockout.
- [P] JWT/session token: decode payload (base64). Are sensitive claims exposed?
- [A] Does the token get invalidated on logout? Reuse it after logout.
- [P] Cookie flags: HttpOnly, Secure, SameSite present?
  Secure = server enforces; Insecure = you can reuse tokens / read them via JS.

## 2. Access control / IDOR (OWASP A01) — the big one for job boards
- [A] With test account A, view your application: note the ID in the URL/API
      (e.g. `/api/applications/1043`). Change it to another ID.
      - Secure: 403/404 or only your own data.
      - Insecure: you read/modify someone else's application = IDOR (High/Critical).
- [A] Can a non-recruiter account hit recruiter/admin endpoints? (privilege escalation)
- [A] Can you edit/delete a job posting you shouldn't? (the listing-tamper test)
- [P] Look for `internal:true`-style flags or hidden admin routes in the JS.

## 3. Input handling: XSS / injection (OWASP A03)
- [A] Reflected/stored XSS in application form fields (name, cover letter, etc.):
      submit a benign marker like `"><b>test123</b>` and see if it renders unescaped
      where a recruiter would view it. (Use a harmless marker, not real payloads.)
- [A] SQL/NoSQL injection in search/filter params: test with tool-assisted, careful
      payloads only if authorized; otherwise flag for Burp active scan.

## 4. File upload (OWASP A04/A08) — a common demo
The resume/CV upload is the classic target. Test SAFELY:
- [A] Upload a benign file with a wrong/dangerous extension (e.g. `test.php`,
      `test.svg`, `test.html`) containing a harmless marker string.
      - Does the server accept it? Rename it? Store it web-accessible?
      - Can you browse to it and does it EXECUTE vs download as text?
      Secure: type-checked, renamed, stored outside web root, served as attachment.
      Insecure: executes / runs = remote code execution (Critical). Prove with a
      harmless proof (echo a fixed string), never real malware.
- [A] Oversized file / content-type mismatch handling.

## 5. API testing with Postman (OWASP A01/A05) — a common demo
- [P] Build a Postman collection from the endpoints you mapped in recon.
- [A] Auth boundary: call an endpoint with (a) no token, (b) an expired token,
      (c) another user's context. What leaks?
- [A] Mass assignment: add extra fields to a JSON body (e.g. `"role":"admin"`,
      `"isRecruiter":true`) and see if the server trusts them.
- [A] Missing rate limiting on sensitive endpoints.

## 6. Security misconfiguration (OWASP A05)
- [P] Missing security headers (CSP, HSTS, X-Frame-Options, etc.).
- [P] Verbose errors / stack traces exposing framework, paths, versions.
- [P] Exposed files: `.git/`, `/api-docs`, swagger, `.env`, backup files.
- [P] Directory listing enabled on upload dirs.

## 7. Sensitive data exposure (OWASP A02)
- [P] PII (applicant emails, resumes) returned in API responses beyond need.
- [P] Secrets/keys in frontend JS (decode base64 candidates).
- [P] HTTPS enforced everywhere? Mixed content?

## Prioritize for a job board
Highest business risk = (1) IDOR on applications/PII, (2) file upload RCE,
(3) auth/access-control on recruiter functions, (4) XSS hitting recruiters.
Lead your report with these.
