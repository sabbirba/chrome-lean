# Flag reference

[`scripts/flags.py`](../scripts/flags.py) writes these to `Local State` → `browser.enabled_labs_experiments`. `@1` means enabled, `@2` means disabled.

## Turned on

| Flag | Effect |
|---|---|
| `enable-parallel-downloading` | Downloads big files over several connections at once |
| `enable-gpu-rasterization` | Draws pages on the GPU |
| `enable-zero-copy` | Fewer memory copies while drawing pages |
| `enable-quic` | QUIC protocol |
| `heavy-ad-privacy-mitigations` | Stricter limits on heavy ads |
| `enable-webrtc-hide-local-ips-with-mdns` | Hides your local IP in WebRTC |

## Turned off

| Flag | Effect |
|---|---|
| `glic`, `glic-actor` | Gemini in Chrome and Gemini acting on pages |
| `prompt-api-for-gemini-nano` | Prompt API |
| `summarizer-api-for-gemini-nano` | Summarizer API |
| `writer-api-for-gemini-nano`, `rewriter-api-for-gemini-nano` | Writer and Rewriter APIs |
| `history-embeddings` | AI history search |
| `contextual-tasks`, `contextual-cueing` | AI side panel tasks and suggestions |
| `ntp-composebox`, `ntp-realbox-next` | AI search boxes on the New Tab page |

## Notes

- Chrome renames flags often and silently drops names it doesn't recognise. After a Chrome update, check `chrome://flags` → **Enabled** / **Disabled**.
- If pages flicker or go blank, the GPU flags are the likely cause. Click **Reset all** in `chrome://flags`.
- `flags.py` saves a backup to `Local State.bak-flags`, which `scripts/revert.sh` uses to restore.
