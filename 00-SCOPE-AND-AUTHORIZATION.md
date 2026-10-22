# Step 1 — Scope & Authorization (do this BEFORE touching the target)

This is not bureaucracy — it is the thing that legally separates "AppSec intern
doing their job" from "unauthorized access." Fill
this out and get it confirmed in writing (email is fine) before active testing.

## Why it matters extra here
The target job board is **hosted by the vendor**, not owned by the company.
A company using such a platform does NOT automatically authorize you to test
the vendor's infrastructure. Clarify this explicitly with the authorizing owner:
- Is the whole `*.vendor.example.com` app in scope, or only the company's tenant/data?
- Does the vendor have a pentest clause / SaaS agreement covering customer testing?
- Is there a the vendor's security contact / responsible-disclosure program?

## Authorization checklist (get answers before starting)
- [ ] Who is authorizing this test? (name + role, e.g. Head of Info Sec)
- [ ] Written approval obtained? (email/ticket link: __________)
- [ ] Exact in-scope assets (list every host/URL/API):
      - https://careers.example.com/ ... (confirm subpaths/APIs)
- [ ] Explicitly OUT of scope (e.g. the vendor's core infra, other tenants, prod DB):
- [ ] Allowed test types: [ ] passive recon  [ ] authenticated manual testing
      [ ] automated scanning (Burp/ZAP active scan)  [ ] file upload  [ ] API/auth
- [ ] Forbidden test types (almost always): DoS / availability / load,
      social engineering, testing real customer accounts, data exfiltration.
- [ ] Test accounts provided? (never test with real applicant data)
- [ ] Test window (dates/hours) + whether prod or a staging copy: __________
- [ ] Point of contact if something breaks, + escalation path: __________
- [ ] Data handling rule: findings/evidence stored where, for how long?

## Rules of engagement (fill in with mentor)
- Environment: [ ] production  [ ] staging/UAT (prefer staging if it exists)
- Rate limits / "go slow" requirements:
- Stop conditions (when you must halt immediately):
- Reporting cadence: (e.g. report criticals within 24h)

## The one rule that keeps you safe
Prove impact with the **minimum, non-destructive** action, then STOP and
document. You never need to actually steal data or break the service to prove
a vulnerability exists — demonstrating you *could* is the finding.
