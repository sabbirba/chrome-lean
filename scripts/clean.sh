#!/bin/zsh
set -uo pipefail
setopt nullglob
source "${0:A:h}/lib.sh"

require_macos
require_disk_access
quit_chrome

C=$CHROME_DATA
before=$(du -sk "$C" ~/Library/Caches/Google/Chrome 2>/dev/null | awk '{s+=$1} END {print s}')

targets=(
  ~/Library/Caches/Google/Chrome/*
  ~/Library/Logs/Google/*
  "$C/OptGuideOnDeviceModel" "$C/optimization_guide_model_store" "$C/screen_ai" "$C/Snapshots"
  "$C/GrShaderCache" "$C/GraphiteDawnCache" "$C/ShaderCache"
  "$C/component_crx_cache" "$C/extensions_crx_cache"
  "$C/Crashpad/completed" "$C/Crashpad/pending" "$C/Crashpad/new"
  "$C"/BrowserMetrics* "$C/Crowd Deny"
  "$C"/*/GPUCache "$C"/*/"Code Cache" "$C"/*/DawnGraphiteCache "$C"/*/DawnWebGPUCache
  "$C"/*/"Network Action Predictor"* "$C"/*/"Reporting and NEL"* "$C"/*/"Network Persistent State"
  "$C"/*/"Feature Engagement Tracker"
)

info "Removing ${#targets} cache and log items"
rm -rf -- $targets

after=$(du -sk "$C" ~/Library/Caches/Google/Chrome 2>/dev/null | awk '{s+=$1} END {print s}')
ok "Freed $(( (before - after) / 1024 )) MB"
