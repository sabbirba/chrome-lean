# Security

Chrome Lean only changes your local Chrome settings. It sends nothing anywhere and has no telemetry.

## What it touches

- `~/Library/Preferences/com.google.Chrome.plist` (policies)
- `~/Library/Application Support/Google/Chrome/Local State` (flags, backed up first)
- Chrome cache, log and crash-report folders (deleted by `clean.sh`)

It never reads or changes passwords, cookies, bookmarks or browsing data you keep.

## Reporting a vulnerability

Don't open a public issue. Use [GitHub private vulnerability reporting](https://github.com/sabbirba/chrome-lean/security/advisories/new) instead. You'll get a reply within 7 days.
