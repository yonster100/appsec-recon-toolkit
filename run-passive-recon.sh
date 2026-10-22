#!/usr/bin/env bash
# Passive recon helper. Run this YOURSELF only after your mentor confirms scope
# in writing (see 00-SCOPE-AND-AUTHORIZATION.md). Everything here is passive:
# it only fetches what a normal browser visit fetches. No tampering, no fuzzing.
#
# Usage:
#   ./run-passive-recon.sh https://careers.example.com
set -euo pipefail

TARGET="${1:?Usage: ./run-passive-recon.sh https://TARGET}"
OUT="$(dirname "$0")/evidence"
mkdir -p "$OUT"

echo "[*] Target: $TARGET"
echo "[*] Saving evidence to: $OUT"

echo "[*] 1/4 Response headers ..."
curl -sSIL --max-time 20 "$TARGET/" | tee "$OUT/headers.txt" >/dev/null

echo "[*] 2/4 Standard public files ..."
{
  for p in robots.txt sitemap.xml .well-known/security.txt humans.txt; do
    printf '===== /%s =====\n' "$p"
    curl -sS -o /dev/null -w "HTTP %{http_code} | %{size_download} bytes | %{content_type}\n" \
      --max-time 15 "$TARGET/$p" || true
  done
} | tee "$OUT/public-files.txt"

echo "[*] 3/4 Landing page HTML (the SPA shell) ..."
curl -sS --max-time 20 "$TARGET/" -o "$OUT/mainpage.html" || true
echo "    saved $(wc -c < "$OUT/mainpage.html" 2>/dev/null || echo 0) bytes"

echo "[*] 4/4 JS bundles referenced by the shell (for Sources-tab review) ..."
grep -Eo '(src|href)="[^"]+\.(js|css)[^"]*"' "$OUT/mainpage.html" 2>/dev/null \
  | sed -E 's/^(src|href)="//; s/"$//' | sort -u | tee "$OUT/assets.txt" || true

echo
echo "[✓] Done. Next: open each JS bundle in DevTools > Sources and search for"
echo "    key/token/secret/admin/config, and decode any base64/JWT with atob()."
echo "    Then map the API endpoints from DevTools > Network (Fetch/XHR filter)."
