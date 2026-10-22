<div align="center">

# Chrome Lean

**Make Google Chrome on macOS lighter, faster and more private in one command.**

No AI. No bloat. Less telemetry. Fully reversible.

![macOS](https://img.shields.io/badge/macOS-000000?style=flat-square&logo=apple&logoColor=white)
![Chrome 155](https://img.shields.io/badge/Chrome-155-4285F4?style=flat-square&logo=googlechrome&logoColor=white)
![Policies](https://img.shields.io/badge/policies-123-success?style=flat-square)
![Shell](https://img.shields.io/badge/shell-zsh-89e051?style=flat-square&logo=gnubash&logoColor=white)
[![CI](https://img.shields.io/github/actions/workflow/status/sabbirba/chrome-lean/ci.yml?style=flat-square&label=CI)](https://github.com/sabbirba/chrome-lean/actions)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

</div>

---

## Contents

- [Quick start](#quick-start)
- [What it does](#what-it-does)
- [Benchmarks](#benchmarks)
- [Benefits](#benefits)
- [Allow one site](#allow-one-site)
- [Commands](#commands)
- [Undo](#undo)
- [How it works](#how-it-works)
- [Project layout](#project-layout)
- [Docs](#docs)

## Quick start

**1. Give Terminal Full Disk Access**

System Settings → Privacy & Security → Full Disk Access → turn on **Terminal**, then reopen Terminal.

**2. Download and run**

```bash
git clone https://github.com/sabbirba/chrome-lean.git && cd chrome-lean && zsh setup.sh
```

**3. One manual step**

Open `chrome://settings/syncSetup` and turn off **"Help improve Chrome's features and performance"**.

Chrome restarts on `chrome://policy`, where you can see every setting applied.

> [!NOTE]
> Chrome will show **"Your browser is managed by your organization"**. That's expected. Chrome shows this message whenever any policy is set, including the ones Chrome Lean writes locally. Nobody is managing your browser remotely, and nothing is reported anywhere. Run `zsh scripts/revert.sh` and the message goes away.

## What it does

| | Area | Changes |
|:-:|---|---|
| 🤖 | **AI off** | Gemini, AI Mode, Help me write, tab compare, AI history search, AI themes, DevTools AI, the on-device AI model and the AI APIs for websites |
| 🧹 | **Bloat off** | Promos, shopping, surveys, New Tab cards, side search, Cast, Live Caption, Translate, spell check, search suggestions, address and card autofill, QR codes, Guest mode, extra profiles |
| ⚡ | **Faster** | Aggressive Memory Saver, background tab freezing, memory capped at ⅛ of your RAM, 50 MB cache, no wasteful preloading, QUIC, faster TLS and DNS, GPU flags |
| 🔒 | **Private** | Third-party cookies blocked, HTTPS forced, encrypted DNS, Encrypted Client Hello, WebRTC IP leak protection, history off, no calls home to Google |
| 🚫 | **Permissions blocked** | Notifications, location, camera and mic, clipboard, files, pop-ups, auto-downloads, Bluetooth, USB, serial, HID, sensors, local fonts, window info |
| 🗑️ | **Cleaned** | Caches, AI models, graphics caches, crash reports, logs, tracking databases |

**Kept on deliberately:** Safe Browsing, Chrome updates, the password manager, sync and extensions.

Full details: [docs/POLICIES.md](docs/POLICIES.md) · [docs/FLAGS.md](docs/FLAGS.md)

## Benchmarks

| | Metric | Before | After | Better |
|:-:|---|---:|---:|---:|
| 🤖 | AI model downloads | 20 | **0** | **Eliminated** |
| 📡 | Background calls to Google | 63 | **35** | **1.8×** |
| 💾 | Profile size | 140 MB | **84 MB** | **1.7×** |
| 🧠 | Memory | 4,740 MB | **3,770 MB** | **1.26×** |
| 🚀 | Startup | 289 ms | **257 ms** | **1.12×** |

Details: [docs/BENCHMARKS.md](docs/BENCHMARKS.md)

## Benefits

- 🔒 **1.8× fewer calls home:** half of Chrome's background traffic to Google is gone
- 🤖 **No AI:** nothing downloaded, nothing running, nothing in the interface
- 💾 **1.7× smaller profile:** no AI models, a 50 MB cache and no history
- 🧠 **1.26× less memory:** no preloading, aggressive Memory Saver, tab freezing and a memory cap
- 🛡️ **Harder to track:** third-party cookies blocked, fingerprinting surfaces reduced, encrypted DNS and ECH
- 🧘 **Quieter browsing:** no autoplay, pop-ups, notification prompts, promos or surveys
- ↩️ **Fully reversible:** one command undoes everything

## Allow one site

Everything is blocked by default, but you can still allow a site.

Click the icon to the left of the address → **Site settings** → set the permission to **Allow**.

For example, allow **Camera** and **Microphone** on `meet.google.com` for video calls.

## Commands

| Command | What it does |
|---|---|
| `zsh setup.sh` | Runs everything below in order |
| `zsh scripts/apply.sh` | Applies the policies |
| `python3 -I scripts/flags.py ~/Library/Application\ Support/Google/Chrome/"Local State"` | Sets the flags (quit Chrome first) |
| `zsh scripts/clean.sh` | Clears caches and logs |
| `zsh scripts/verify.sh` | Lists any policy Chrome rejects (needs [Node 22+](https://nodejs.org)) |
| `node scripts/bench.mjs` | Benchmark: run before and after setup, then compare |
| `zsh scripts/revert.sh` | Undoes everything |

## Undo

```bash
zsh scripts/revert.sh
```

To bring back one feature:

```bash
defaults delete com.google.Chrome PolicyName
```

Then restart Chrome.

## How it works

- **Policies** are written with `defaults write com.google.Chrome …` into your user preferences. Chrome applies them as *Recommended* policies and shows the "managed by your organization" notice while they're in place.
- **Flags** are written to Chrome's `Local State` file while Chrome is closed. Chrome drops any name it doesn't recognise.
- **Verification** opens `chrome://policy` in a hidden Chrome window and reads every policy's status.

## Project layout

```
chrome-lean/
├── setup.sh              One command that runs everything
├── SKILL.md              Instructions for AI coding agents
├── scripts/
│   ├── lib.sh            Shared helpers and safety checks
│   ├── apply.sh          Policies
│   ├── flags.py          Flags (backs up Local State first)
│   ├── clean.sh          Caches, AI models, logs
│   ├── verify.sh         Policy status check
│   ├── verify.mjs        Reads chrome://policy over DevTools
│   ├── bench.mjs         Before/after benchmark
│   └── revert.sh         Undo
└── docs/
    ├── POLICIES.md       Every policy, value and effect
    ├── FLAGS.md          Every flag and effect
    ├── BENCHMARKS.md     Before/after measurements
    └── TROUBLESHOOTING.md
```

## Docs

| | |
|---|---|
| 📋 [Policy reference](docs/POLICIES.md) | Every policy, its value and its effect |
| 🚩 [Flag reference](docs/FLAGS.md) | Every flag and its effect |
| 📊 [Benchmarks](docs/BENCHMARKS.md) | Before/after measurements |
| 🛠️ [Troubleshooting](docs/TROUBLESHOOTING.md) | The "managed" banner, broken sites, video calls, undo |
| 🤖 [Agent skill](SKILL.md) | Ready-made instructions for AI coding agents |
| 🤝 [Contributing](CONTRIBUTING.md) | How to add a policy or flag |
| 🔐 [Security](SECURITY.md) | What the scripts touch, and how to report issues |
| 📝 [Changelog](CHANGELOG.md) | Release history |

> **Can it fake my fingerprint?** No, Chrome doesn't support that. Use Brave or Mullvad Browser if you need it.

---

<div align="center">

Made by **[Sabbir Bin Abbas](https://github.com/sabbirba)** · [MIT License](LICENSE)

If Chrome Lean helped you, give it a ⭐

</div>
