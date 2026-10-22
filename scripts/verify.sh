#!/bin/zsh
set -uo pipefail
source "${0:A:h}/lib.sh"

require_macos
require_chrome
command -v node >/dev/null || die "Node.js 22+ is required. Install it from https://nodejs.org or check chrome://policy by hand."

TMP=$(mktemp -d)
PORT=$(( 20000 + RANDOM % 20000 ))
"$CHROME_BIN" --headless=new --user-data-dir="$TMP" --no-first-run --remote-debugging-port=$PORT about:blank >/dev/null 2>&1 &
PID=$!
trap 'kill $PID 2>/dev/null; wait $PID 2>/dev/null; rm -rf "$TMP"' EXIT

for n in {1..20}; do
  curl -s "127.0.0.1:$PORT/json/version" >/dev/null && break
  sleep 0.5
done

rows=$(node "${0:A:h}/verify.mjs" $PORT | grep ' Platform ')
total=$(print -r -- "$rows" | grep -c .)
good=$(print -r -- "$rows" | grep -c 'Status OK')
bad=$(print -r -- "$rows" | grep -v 'Status OK')

ok "$good of $total policies OK"
[[ -n $bad ]] && print -r -- "$bad" | awk '{s=$0; sub(/.*Status /,"",s); sub(/ Error.*/,"",s); printf "  %-50s %s\n", $1, s}'
exit 0
