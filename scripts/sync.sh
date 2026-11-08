#!/usr/bin/env bash
# sync.sh - commit anything outstanding, rebase on GitHub's copy, and push.
set -euo pipefail

# Inside a Flatpak sandbox (e.g. VSCodium from Flathub) host tools like xclip, git and your
# SSH keys are invisible. Re-run this script on the host via flatpak-spawn instead.
if [[ ( -e /.flatpak-info || -n "${CT_FORCE_FLATPAK:-}" ) && -z "${CT_ON_HOST:-}" ]]; then
  exec flatpak-spawn --host --env=CT_ON_HOST=1 --env=DISPLAY="${DISPLAY:-:0}" \
       "$(readlink -f "${BASH_SOURCE[0]}")" "$@"
fi
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
# Stage only known project paths (never git add -A), so stray scratch files are not swept in.
# A new top-level folder syncs only after you add it to this list.
for p in log docs assets scripts surveys templates prompts README.md LICENSE .gitignore .vscode; do
  [[ -e "$p" ]] && git add -- "$p"
done
git diff --cached --quiet || git commit -q -m "sync: $(date '+%F %H:%M')"
git pull --rebase --quiet
git push --quiet
msg="Synced $(basename "$root") with GitHub"
echo "$msg"
command -v notify-send >/dev/null && notify-send "CopperToolchain" "$msg" || true
