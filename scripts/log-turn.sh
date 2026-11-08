#!/usr/bin/env bash
# log-turn.sh - append one conversation turn (from the clipboard) to today's session log.
#
# Set CT_USER_LABEL to change the speaker label for your messages (default USER).
# Usage: scripts/log-turn.sh <user|claude> [--stdin] [--turn N] [--session NAME] [--no-commit]
#   user    wraps the clipboard text in a speaker heading (USER by default) + blockquote
#   claude  appends the clipboard text as-is (Claude replies already carry their own rules/heading)
#   --stdin read from stdin instead of the clipboard (for testing or piping)
#   --turn  force the turn number; --session adds a name: log/YYYY-MM-DD-NAME.md
set -euo pipefail

# Inside a Flatpak sandbox (e.g. VSCodium from Flathub) host tools like xclip, git and your
# SSH keys are invisible. Re-run this script on the host via flatpak-spawn instead.
if [[ ( -e /.flatpak-info || -n "${CT_FORCE_FLATPAK:-}" ) && -z "${CT_ON_HOST:-}" ]]; then
  exec flatpak-spawn --host --env=CT_ON_HOST=1 --env=DISPLAY="${DISPLAY:-:0}" \
       "$(readlink -f "${BASH_SOURCE[0]}")" "$@"
fi

role="${1:-}"; shift || true
use_stdin=0; turn_override=""; session=""; commit=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --stdin) use_stdin=1 ;;
    --turn) turn_override="${2:?--turn needs a number}"; shift ;;
    --session) session="${2:?--session needs a name}"; shift ;;
    --no-commit) commit=0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done
[[ "$role" =~ ^(user|claude)$ ]] || { echo "Usage: $0 <user|claude> [--stdin] [--turn N] [--session NAME] [--no-commit]" >&2; exit 1; }

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
today="$(date +%F)"
label_user="${CT_USER_LABEL:-USER}"
file="$root/log/$today${session:+-$session}.md"
mkdir -p "$root/log"

read_clipboard() {
  if   command -v xclip   >/dev/null; then xclip -selection clipboard -o
  elif command -v xsel    >/dev/null; then xsel --clipboard --output
  elif command -v wl-paste >/dev/null; then wl-paste
  elif command -v pbpaste >/dev/null; then pbpaste     # macOS (untested)
  else echo "No clipboard tool found. Install one: sudo apt install xclip" >&2; return 1; fi
}

if (( use_stdin )); then body="$(cat)"; else body="$(read_clipboard)"; fi
[[ -n "${body//[[:space:]]/}" ]] || { echo "Nothing to log (empty input)." >&2; exit 1; }

# Turn numbering: continue from this session file; if it has no USER turns yet,
# continue from the most recent earlier log (log/*.md, then log.md). Use --turn 1 to start fresh.
maxturn() { grep -hoE '^## 🧑 [^·]+ · Turn [0-9]+' "$1" 2>/dev/null | grep -oE '[0-9]+$' | sort -n | tail -1 || true; }
last_turn="$(maxturn "$file")"
if [[ -z "$last_turn" ]]; then
  for f in $(ls -1r "$root"/log/[0-9]*.md 2>/dev/null || true) "$root/log/log.md" "$root/log.md"; do
    [[ "$f" == "$file" || ! -f "$f" ]] && continue
    last_turn="$(maxturn "$f")"
    [[ -n "$last_turn" ]] && break
  done
fi
last_turn="${last_turn:-0}"

[[ -f "$file" ]] || printf '# Session log: %s\n\n' "$today${session:+ ($session)}" > "$file"

# Last non-empty line and number of non-empty lines, used to avoid doubled rules.
last_line="$(grep -v '^[[:space:]]*$' "$file" | tail -1 || true)"
nonempty="$(grep -vc '^[[:space:]]*$' "$file" || true)"

if [[ "$role" == "user" ]]; then
  turn="${turn_override:-$((last_turn + 1))}"
  quoted="$(printf '%s\n' "$body" | sed 's/^/> /')"
  { [[ "$last_line" != "---" && "$nonempty" -gt 1 ]] && printf -- '---\n\n'
    printf '## 🧑 %s · Turn %s · %s\n\n%s\n\n' "$label_user" "$turn" "$today" "$quoted"; } >> "$file"
else
  turn="${turn_override:-$(( last_turn > 0 ? last_turn : 1 ))}"
  first="$(printf '%s\n' "$body" | grep -m1 -v '^[[:space:]]*$' || true)"
  if [[ "$first" == "---" ]]; then
    printf '%s\n\n' "$body" >> "$file"
  else
    printf -- '---\n\n## 🤖 CLAUDE · Turn %s · %s\n\n%s\n\n---\n\n' "$turn" "$today" "$body" >> "$file"
  fi
fi

msg="Logged ${role} turn ${turn} -> ${file#"$root"/}"
echo "$msg"
command -v notify-send >/dev/null && notify-send "CopperToolchain" "$msg" || true

if (( commit )) && git -C "$root" rev-parse --git-dir >/dev/null 2>&1; then
  git -C "$root" add "$file"
  git -C "$root" commit --quiet -m "log: $today turn $turn ($role)" || true
fi
