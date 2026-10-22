#!/bin/zsh
set -uo pipefail
source "${0:A:h}/lib.sh"

require_macos
quit_chrome

keys=($(policy_keys))
for k in $keys; do defaults delete $CHROME_DOMAIN $k; done
ok "Removed ${#keys} policies"

L="$CHROME_DATA/Local State"
if [[ -f "$L.bak-flags" ]] && ls "$CHROME_DATA" >/dev/null 2>&1; then
  cp "$L.bak-flags" "$L" && rm "$L.bak-flags"
  ok "Flags restored"
else
  warn "No flag backup found. Reset flags at chrome://flags → Reset all."
fi

open_chrome
