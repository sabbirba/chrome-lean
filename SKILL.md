---
name: chrome-lean
description: Debloat, speed up and lock down Google Chrome on macOS. Turns off all AI features, telemetry, promos and optional extras, blocks site permissions, adds privacy hardening, sets performance flags, and clears caches and logs. Use when someone asks to make Chrome lightweight, private, faster, AI-free or bloat-free on a Mac.
---

# Chrome Lean (macOS)

Applies 123 Chrome policies, 17 flags and a cache cleanup. Built and verified on Chrome 155.

## How it works

- **Policies** are written with `defaults write com.google.Chrome <Key>` to `~/Library/Preferences/com.google.Chrome.plist`. Chrome reads these at the *Recommended* level. Chrome shows "Your browser is managed by your organization" whenever any policy is set, so tell the user to expect it. It's local only and goes away with `revert.sh`.
- **Flags** live in `~/Library/Application Support/Google/Chrome/Local State` → `browser.enabled_labs_experiments` (`name@1` = enabled, `name@2` = disabled). Chrome drops unknown names on startup.
- **Verification** renders `chrome://policy` in a throwaway headless Chrome and reads every row's Status. Never trust a policy until its Status is OK.

## Before you start

1. Check for an existing configuration profile: run `profiles list` and `ls "/Library/Managed Preferences"`. A machine-level `com.google.Chrome.plist` there is Mandatory and overrides these policies. The user removes it in System Settings → General → Device Management.
2. Folders under `~/Library/Application Support/Google/Chrome` need **Full Disk Access**. Run `flags.py`, `clean.sh` and `revert.sh` from Terminal.app with Full Disk Access turned on, not from an agent's sandboxed shell.

## Steps

`zsh setup.sh` runs everything below. To run each step on its own:

```bash
zsh scripts/apply.sh                 # policies, then restarts Chrome
zsh scripts/verify.sh                # every policy should report OK
osascript -e 'quit app "Google Chrome"'
python3 -I scripts/flags.py ~/Library/Application\ Support/Google/Chrome/"Local State"
zsh scripts/clean.sh                 # caches, AI models, crash reports, logs
```

Then tell the user to turn off usage reporting by hand at `chrome://settings/syncSetup` → "Help improve Chrome's features and performance". `MetricsReportingEnabled` is ignored at the Recommended level.

## What it changes

| Area | Changes |
|---|---|
| AI | Gemini, AI Mode, Help me write, tab compare, history search, theme creation, DevTools AI, on-device model, built-in AI APIs, Lens and search sharing, third-party AI chat |
| Bloat | Promos, shopping, surveys, feedback, NTP cards, side search, cast, Live Caption and Live Translate, Translate, spell check, search suggestions, address and card autofill, QR generator, Guest mode, adding profiles, component updates |
| Speed | Memory Saver on aggressive, tab freezing, memory cap at 1/8 of RAM, 50 MB cache, no preloading, QUIC, TLS 1.3 early data, Happy Eyeballs v3, compression dictionaries, built-in DNS |
| Privacy | Third-party cookies blocked, forced HTTPS, DNS over HTTPS through Cloudflare, Encrypted Client Hello, reduced language header, WebRTC limited to public IP, no URL-keyed metrics, domain reliability, network time or WPAD checks, Safe Browsing on Standard with local checks only, history off |
| Permissions | Blocked by default: notifications, location, sensors, idle detection, local fonts, window management, Bluetooth, USB, serial, HID, sockets, pop-ups, automatic downloads, clipboard, file system, insecure content, controlled frames, camera and mic |
| Flags | Turned on: parallel downloading, GPU rasterization, zero-copy, QUIC, heavy-ad mitigations, WebRTC mDNS. Turned off: glic, glic-actor, the Gemini Nano APIs, history embeddings, contextual tasks and cueing, NTP composebox |

Kept on deliberately: Safe Browsing, Chrome updates (GoogleUpdater), the password manager, sync and extensions.

## Gotchas

- Every value is checked against `chrome://policy`. Policies that showed errors and were left out: `GenAiDefaultSettings` (cloud only), `MetricsReportingEnabled` and `NTPFooterManagementNoticeEnabled` (blocked at this level), `ProfilePickerOnStartupAvailability` and `NTPShortcuts` (level not supported), the `PrivacySandbox*` and `Lens*` policies (deprecated or overridden), and `BackgroundModeEnabled` (Windows and Linux only).
- Wiping data on exit (`ClearBrowsingDataOnExitList`, `BrowsingDataLifetime`) only works with `SyncDisabled=true`.
- Settings policies don't all use the same values: GenAI-style settings use `2` = disabled, while Gemini settings use `1` = disabled. Check each new one.
- Flags get renamed often. After writing them, relaunch Chrome and re-read `Local State` to see which flags Chrome kept.
- Chrome can't spoof fingerprints. For that, point the user to Brave or Mullvad Browser.

## Undo

```bash
zsh scripts/revert.sh
```

To turn one policy back on: `defaults delete com.google.Chrome <Key>`, then restart Chrome. To unblock one site, click the icon left of the address → Site settings.
