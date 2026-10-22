# AppSec Recon Toolkit

A practical, authorization-first workflow for web application security
assessments, aimed at careers/job-board style apps and mapped to the OWASP Top
10. It is the checklist and methodology I built while learning application
security, written so the safe, passive work is clearly separated from anything
active that needs explicit sign-off.

The toolkit is vendor-neutral. Any real target names from the original
engagement have been replaced with placeholders, so this reads as a reusable
process rather than a dossier on anyone's live system.

## The order of operations

| File | Step |
|------|------|
| `00-SCOPE-AND-AUTHORIZATION.md` | Get written authorization and rules of engagement before touching anything. The step that separates "doing the job" from "unauthorized access." |
| `01-RECON-CHECKLIST.md` | Passive recon: fingerprint the stack, map the app surface, and inspect client-side code and storage. Observation only. |
| `02-WEBAPP-TEST-PLAN.md` | Active test plan mapped to OWASP: auth and session, access control and IDOR, input handling, file upload, API testing, misconfiguration, and data exposure. Each item tagged passive or active. |
| `03-TOOLS-SETUP.md` | Setting up Burp Suite, OWASP ZAP, and Postman, and when to use each. |
| `04-finding-report-template.md` | A clean per-finding report: severity, reproduction, evidence, impact, likelihood, and remediation. |
| `run-passive-recon.sh` | A passive recon helper that only fetches what a normal browser visit fetches: headers, standard public files, the page shell, and referenced JS/CSS bundles. |

## Principles

- Nothing active runs without written authorization and an in-scope target.
- Prove impact with the minimum non-destructive action, then stop and document.
- Test accounts and benign markers only. Never real user data, never real payloads.

## Passive recon helper

```bash
./run-passive-recon.sh https://careers.example.com
```

Everything it does is read-only. It is still meant to be run under the
authorization captured in step 00.

## License

MIT. See `LICENSE`.
