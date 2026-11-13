#!/usr/bin/env bash
# sync.sh - commit outstanding project files, rebase on GitHub's copy, and push, for the ACTIVE project.
#
# Usage: scripts/sync.sh [short_name]
#   With no argument it syncs the project named on line 1 of the registry (see log-turn.sh).
#   With an argument it syncs that registered project. The notification names the project.
#
# SYNC_PATHS is the one list of what gets staged (never git add -A, so stray scratch files are not swept in).
# A new top-level folder syncs only after you add it here. Missing paths are skipped.
set -euo pipefail

# Inside a Flatpak sandbox (e.g. VSCodium from Flathub) host tools like git and your
# SSH keys are invisible. Re-run this script on the host via flatpak-spawn instead.
if [[ ( -e /.flatpak-info || -n "${CT_FORCE_FLATPAK:-}" ) && -z "${CT_ON_HOST:-}" ]]; then
  exec flatpak-spawn --host --env=CT_ON_HOST=1 --env=DISPLAY="${DISPLAY:-:0}" \
       "$(readlink -f "${BASH_SOURCE[0]}")" "$@"
fi

SYNC_PATHS=(log docs assets scripts surveys templates prompts tools STATE.md project.conf README.md LICENSE .gitignore .vscode)

REGISTRY="${COPPER_REGISTRY:-$HOME/.config/copper/projects}"
HOLD="${COPPER_HOLD:-$(dirname "$REGISTRY")/hold}"

# ------------------------------------------------------------------ helpers (duplicated from log-turn.sh)
notify() {  # notify TITLE MESSAGE [critical]
  command -v notify-send >/dev/null || return 0
  local urgency=normal
  [[ "${3:-}" == critical ]] && urgency=critical
  notify-send -u "$urgency" "$1" "$2" || true
}
die() { echo "sync: $1" >&2; notify "sync FAILED" "$1" critical; exit "${2:-1}"; }

reg_active() { [[ -f "$REGISTRY" ]] || return 0; head -1 "$REGISTRY" | awk '$1=="active"{print $2}'; }
reg_path()   { [[ -f "$REGISTRY" ]] || return 0; awk -F'\t' -v n="$1" 'NR>1 && NF>=2 && $1==n {print $2; exit}' "$REGISTRY"; }
reg_names()  { [[ -f "$REGISTRY" ]] || return 0; awk -F'\t' 'NR>1 && NF>=2 {print $1}' "$REGISTRY"; }
conf_get() {  # conf_get FILE KEY
  local v
  v="$(sed -n "s/^$2[[:space:]]*=[[:space:]]*//p" "$1" 2>/dev/null | head -1)"
  v="${v%$'\r'}"; v="${v#\"}"; v="${v%\"}"
  printf '%s' "$v"
}

P_SHORT=""; P_LONG=""; P_ROOT=""
load_project() {
  local name="$1" p
  [[ "$name" =~ ^[A-Za-z0-9_-]+$ ]] || die "'$name' is not a valid project name (letters, digits, _ and - only)"
  p="$(reg_path "$name")"
  [[ -n "$p" ]] || die "project '$name' is not registered. Registered: $(reg_names | tr '\n' ' ')"
  p="${p/#\~/$HOME}"
  if [[ ! -d "$p" ]] || ! git -C "$p" rev-parse --git-dir >/dev/null 2>&1; then
    die "the registered path for '$name' is not a git repository"
  fi
  [[ -f "$p/project.conf" ]] || die "the '$name' repository has no project.conf"
  [[ "$(conf_get "$p/project.conf" short_name)" == "$name" ]] \
    || die "project.conf in the '$name' repository does not say short_name=$name; refusing to sync the wrong repository"
  P_SHORT="$name"
  P_ROOT="$(cd "$p" && pwd)"
  P_LONG="$(conf_get "$p/project.conf" long_name)"
  [[ -n "$P_LONG" ]] || P_LONG="$name"
}

# ------------------------------------------------------------------ sync
name="${1:-$(reg_active)}"
[[ -n "$name" ]] || die "no active project. Register one, then start with: SOS <short_name>"
if [[ -f "$HOLD" ]]; then
  die "logging hold is set ($(head -1 "$HOLD")). Log a correct 'SOS <short_name>' first. Nothing synced."
fi
load_project "$name"
cd "$P_ROOT"

step="starting"
trap 'notify "$P_LONG" "sync FAILED in $P_SHORT at step: $step" critical' ERR

step="staging files"
for p in "${SYNC_PATHS[@]}"; do
  if [[ -e "$p" ]]; then git add -- "$p"; fi
done

step="committing"
git diff --cached --quiet || git commit -q -m "sync: $(date '+%F %H:%M')"

step="pulling (rebase)"
git pull --rebase --quiet

step="pushing"
git push --quiet

msg="Synced $P_SHORT ($(basename "$P_ROOT")) with GitHub"
echo "$msg"
notify "$P_LONG" "$msg"
