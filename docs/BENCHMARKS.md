# Benchmarks

Chrome 155 on macOS. Before and after Chrome Lean, median of 3 runs.

| | Metric | Before | After | Better |
|:-:|---|---:|---:|---:|
| 🤖 | AI model downloads | 20 | **0** | **Eliminated** |
| 📡 | Background calls to Google while idle | 63 | **35** | **1.8×** |
| 💾 | Profile size after browsing | 140 MB | **84 MB** | **1.7×** |
| 🧠 | Memory with 6 sites | 4,740 MB | **3,770 MB** | **1.26×** |
| 🚀 | Startup | 289 ms | **257 ms** | **1.12×** |

## Background calls eliminated

| Host | Before | After |
|---|---:|---:|
| `optimizationguide-pa.googleapis.com` | 20 | **0** |
| `www.gstatic.com` | 2 | **0** |
| `edgedl.me.gvt1.com` | 2 | **0** |
| `www.google.com` | 4 | **2** |
| `update.googleapis.com` | 6 | **4** |
| `clients2.google.com` | 4 | **2** |

## Run it yourself

```bash
node scripts/bench.mjs
```

Run it once before `setup.sh` and once after.
