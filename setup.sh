#!/bin/zsh
set -euo pipefail
DIR=${0:A:h}/scripts
source "$DIR/lib.sh"

require_macos
require_chrome
require_disk_access

info "Chrome Lean for Chrome $(chrome_version)"

info "1/4 Policies"
zsh "$DIR/apply.sh"

info "2/4 Flags"
quit_chrome
python3 -I "$DIR/flags.py" "$CHROME_DATA/Local State"

info "3/4 Cleanup"
zsh "$DIR/clean.sh"

info "4/4 Verify"
if command -v node >/dev/null; then
  zsh "$DIR/verify.sh"
else
  warn "Node.js not found, skipping. Check chrome://policy instead."
fi

open_chrome "chrome://policy"
ok "Done"
warn "Last step: chrome://settings/syncSetup → turn off \"Help improve Chrome's features and performance\""
