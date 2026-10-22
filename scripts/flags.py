import json
import os
import shutil
import sys

ENABLE = [
    "enable-parallel-downloading",
    "enable-gpu-rasterization",
    "enable-zero-copy",
    "enable-quic",
    "heavy-ad-privacy-mitigations",
    "enable-webrtc-hide-local-ips-with-mdns",
]

DISABLE = [
    "glic",
    "glic-actor",
    "prompt-api-for-gemini-nano",
    "summarizer-api-for-gemini-nano",
    "writer-api-for-gemini-nano",
    "rewriter-api-for-gemini-nano",
    "history-embeddings",
    "contextual-tasks",
    "contextual-cueing",
    "ntp-composebox",
    "ntp-realbox-next",
]


def main():
    default = os.path.expanduser("~/Library/Application Support/Google/Chrome/Local State")
    path = sys.argv[1] if len(sys.argv) > 1 else default
    if not os.path.isfile(path):
        sys.exit(f"Local State not found: {path}")

    backup = path + ".bak-flags"
    if not os.path.exists(backup):
        shutil.copy2(path, backup)

    with open(path) as f:
        state = json.load(f)

    state.setdefault("browser", {})["enabled_labs_experiments"] = (
        [f"{name}@1" for name in ENABLE] + [f"{name}@2" for name in DISABLE]
    )

    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(state, f)
    os.replace(tmp, path)
    print(f"Set {len(ENABLE) + len(DISABLE)} flags. Backup: {backup}")


if __name__ == "__main__":
    main()
