# Contributing

Thanks for helping make Chrome Lean better.

## Reporting a problem

Open an [issue](https://github.com/sabbirba/chrome-lean/issues/new/choose) and include:

- your macOS version and Chrome version (`chrome://version`)
- the output of `zsh scripts/verify.sh`
- what you expected and what happened instead

## Adding or changing a policy

1. Find the policy in the [Chrome Enterprise policy list](https://chromeenterprise.google/policies/) and confirm it supports **Mac**.
2. Add it to the matching section of `scripts/apply.sh`.
3. Run `zsh scripts/apply.sh`, then `zsh scripts/verify.sh`. The policy must show **OK**, not Error, Deprecated or Ignored.
4. Add a row to `docs/POLICIES.md`.

## Adding or changing a flag

1. Add the name to `ENABLE` or `DISABLE` in `scripts/flags.py`.
2. Quit Chrome, run the script, then open Chrome and check `chrome://flags`. Chrome silently drops names it doesn't recognise.
3. Add a row to `docs/FLAGS.md`.

## Style

- zsh for shell scripts, sharing helpers from `scripts/lib.sh`
- No comments in code. Keep names clear instead.
- `zsh -n` and `shellcheck`-style hygiene: quote paths, use `set -euo pipefail`
- One topic per pull request, with a plain commit message

## Pull requests

Fill in the pull request template. CI checks syntax on every push.
