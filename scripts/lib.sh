CHROME_APP="/Applications/Google Chrome.app"
CHROME_BIN="$CHROME_APP/Contents/MacOS/Google Chrome"
CHROME_DATA="$HOME/Library/Application Support/Google/Chrome"
CHROME_DOMAIN=com.google.Chrome

info() { print -P "%F{cyan}==>%f $*" }
ok() { print -P "%F{green}✓%f $*" }
warn() { print -P "%F{yellow}!%f $*" >&2 }
die() { print -P "%F{red}✗%f $*" >&2; exit 1 }

require_macos() {
  [[ $(uname) == Darwin ]] || die "Chrome Lean only runs on macOS."
}

require_chrome() {
  [[ -x $CHROME_BIN ]] || die "Google Chrome not found in /Applications."
}

require_disk_access() {
  ls "$CHROME_DATA" >/dev/null 2>&1 || die "No access to Chrome's data folder. Give Terminal Full Disk Access in System Settings → Privacy & Security, then reopen Terminal."
}

chrome_version() {
  defaults read "$CHROME_APP/Contents/Info" CFBundleShortVersionString 2>/dev/null
}

quit_chrome() {
  pgrep -x "Google Chrome" >/dev/null || return 0
  osascript -e 'quit app "Google Chrome"' 2>/dev/null
  for n in {1..40}; do
    pgrep -x "Google Chrome" >/dev/null || return 0
    sleep 0.5
  done
  die "Chrome did not quit. Close it and run again."
}

policy_keys() {
  defaults read $CHROME_DOMAIN 2>/dev/null | grep -oE '^    "?[A-Z][A-Za-z0-9]+' | tr -d ' "' | grep -vE '^(NS|LastRun)'
}

open_chrome() {
  open -a "Google Chrome" "$@"
}
