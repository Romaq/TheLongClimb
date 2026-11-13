#!/usr/bin/env bash
# log-turn.sh - append one conversation turn (from the clipboard) to the ACTIVE project's dated session log.
#
# Usage:
#   scripts/log-turn.sh <user|claude> [--stdin] [--turn N] [--session NAME] [--no-commit]
#   scripts/log-turn.sh close --previous [--yes]    append a "closed late" note to unclosed earlier logs
#   scripts/log-turn.sh register <short_name> <path-to-repo>
#   scripts/log-turn.sh status                      show which project the shortcut will write to
#
# Which project? The registry file (default ~/.config/copper/projects, override with COPPER_REGISTRY):
#     active CT
#     CT<TAB>/home/USER/Projects/CopperToolchain
#     TLC<TAB>/home/USER/Projects/TheLongClimb
# Line 1 names the active project. Every other line is short_name, a TAB, and the repo path.
# A user message whose FIRST line is "SOS <short_name>" switches the active project, then is logged
# there. A message whose first line is "COS <short_name>" closes the session: log Claude's reply after it.
# Each repo has a project.conf (short_name=, long_name=, directory_name=) that must match its registry name.
#
# Headings: "## 🧑 <short_name> USER · Turn N · date" and "## 🤖 <short_name> CLAUDE · Turn N · date".
# The turn-number pattern (maxturn) accepts any label. Exit status: 0 ok, 1 refused or error, 3 commit failed.
#
# AI replies ("claude" or "ai"): the pasted text must carry its own heading
#     ## 🤖 <short_name> <AI> · Turn N · YYYY-MM-DD
# The project must match the active project and <AI> must be listed in project.conf
# (participants=CLAUDE CHATGPT; default CLAUDE). Anything else is refused, never filed under a default name.
#
# HOLD: a wrong or unregistered SOS, a COS naming another project, or an AI heading naming another
# project sets a hold file (default: "hold" next to the registry). While it is set, log-turn.sh and
# sync.sh refuse to act. A correct "SOS <short_name>" (or "COS <active>") clears it.
set -euo pipefail

# Inside a Flatpak sandbox (e.g. VSCodium from Flathub) host tools like xclip, git and your
# SSH keys are invisible. Re-run this script on the host via flatpak-spawn instead.
if [[ ( -e /.flatpak-info || -n "${CT_FORCE_FLATPAK:-}" ) && -z "${CT_ON_HOST:-}" ]]; then
  exec flatpak-spawn --host --env=CT_ON_HOST=1 --env=DISPLAY="${DISPLAY:-:0}" \
       "$(readlink -f "${BASH_SOURCE[0]}")" "$@"
fi

REGISTRY="${COPPER_REGISTRY:-$HOME/.config/copper/projects}"
HOLD="${COPPER_HOLD:-$(dirname "$REGISTRY")/hold}"
today="$(date +%F)"

# ------------------------------------------------------------------ helpers (duplicated in sync.sh)
notify() {  # notify TITLE MESSAGE [critical]
  command -v notify-send >/dev/null || return 0
  local urgency=normal
  [[ "${3:-}" == critical ]] && urgency=critical
  notify-send -u "$urgency" "$1" "$2" || true
}
die() { echo "log-turn: $1" >&2; notify "log-turn FAILED" "$1" critical; exit "${2:-1}"; }
hold_die() {  # hold_die REASON : set the hold, then refuse
  mkdir -p "$(dirname "$HOLD")"; printf '%s\n' "$1" > "$HOLD"
  die "$1 HOLD SET: nothing is logged or synced until a correct 'SOS <short_name>' (or 'COS' for the active project) is logged."
}
fail() { if [[ -n "${HOLD_ON_FAIL:-}" ]]; then hold_die "$1"; else die "$1"; fi; }

reg_active() { [[ -f "$REGISTRY" ]] || return 0; head -1 "$REGISTRY" | awk '$1=="active"{print $2}'; }
reg_path()   { [[ -f "$REGISTRY" ]] || return 0; awk -F'\t' -v n="$1" 'NR>1 && NF>=2 && $1==n {print $2; exit}' "$REGISTRY"; }
reg_names()  { [[ -f "$REGISTRY" ]] || return 0; awk -F'\t' 'NR>1 && NF>=2 {print $1}' "$REGISTRY"; }
conf_get() {  # conf_get FILE KEY
  local v
  v="$(sed -n "s/^$2[[:space:]]*=[[:space:]]*//p" "$1" 2>/dev/null | head -1)"
  v="${v%$'\r'}"; v="${v#\"}"; v="${v%\"}"
  printf '%s' "$v"
}

P_SHORT=""; P_LONG=""; P_ROOT=""; P_PART=""
load_project() {  # sets P_SHORT, P_LONG, P_ROOT; refuses anything that does not check out
  local name="$1" p
  [[ "$name" =~ ^[A-Za-z0-9_-]+$ ]] || fail "'$name' is not a valid project name (letters, digits, _ and - only)"
  p="$(reg_path "$name")"
  [[ -n "$p" ]] || fail "project '$name' is not registered. Registered: $(reg_names | tr '\n' ' ')"
  p="${p/#\~/$HOME}"
  if [[ ! -d "$p" ]] || ! git -C "$p" rev-parse --git-dir >/dev/null 2>&1; then
    fail "the registered path for '$name' is not a git repository"
  fi
  [[ -f "$p/project.conf" ]] || fail "the '$name' repository has no project.conf"
  [[ "$(conf_get "$p/project.conf" short_name)" == "$name" ]] \
    || fail "project.conf in the '$name' repository does not say short_name=$name; refusing to log into the wrong repository"
  P_SHORT="$name"
  P_ROOT="$(cd "$p" && pwd)"
  P_LONG="$(conf_get "$p/project.conf" long_name)"
  [[ -n "$P_LONG" ]] || P_LONG="$name"
  P_PART="$(conf_get "$p/project.conf" participants)"
  [[ -n "$P_PART" ]] || P_PART="CLAUDE"
}

reg_set_active() {  # rewrite line 1 atomically
  local tmp; tmp="$(mktemp "$REGISTRY.XXXXXX")"
  { printf 'active %s\n' "$1"; tail -n +2 "$REGISTRY"; } > "$tmp" && mv "$tmp" "$REGISTRY"
}

# ------------------------------------------------------------------ log inspection
latest_log() {  # latest_log ROOT [SKIP_TODAY]  -> newest dated log path, or nothing
  local root="$1" skip="${2:-0}" f best=""
  while IFS= read -r f; do
    if (( skip )) && [[ "$(basename "$f")" == "$today"* ]]; then continue; fi
    best="$f"
  done < <(ls -1 "$root"/log/[0-9]*.md 2>/dev/null | sed 's/\.md$//' | LC_ALL=C sort || true)
  if [[ -n "$best" ]]; then printf '%s.md' "$best"; fi
  return 0
}

# log_state FILE SHORT_NAME: exit 0 = closed, 1 = unclosed, 2 = no turns yet.
# Closed = the last user turn starts with "COS <short_name>" and a Claude turn follows,
# or a "closed late" marker follows the last turn. Headings inside code fences are ignored.
log_state() {
  local rc=0
  awk -v name="$2" '
    /^```/ { fence = !fence; next }
    fence  { next }
    /^## 🧑 /            { have = 1; inuser = 1; first = ""; later = 0; late = 0; next }
    /^## 🤖 /            { inuser = 0; if (have) later = 1; next }
    /^<!-- closed-late -->/ { if (have) late = 1; next }
    inuser && first == "" && /^> / { first = substr($0, 3) }
    END {
      if (!have) exit 2
      if (late) exit 0
      if (later && first ~ ("^COS[ \t]+" name "([ \t]|$)")) exit 0
      exit 1
    }' "$1" || rc=$?
  return "$rc"
}

# Highest user turn number in a file; any label is accepted, and headings inside code fences are ignored.
maxturn() {
  awk '
    /^```/ { fence = !fence; next }
    fence  { next }
    /^## 🧑 / && match($0, /· Turn [0-9]+/) { n = substr($0, RSTART + 7, RLENGTH - 7) + 0; if (n > m) m = n }
    END { if (m) print m }' "$1" 2>/dev/null || true
}

commit_file() {  # commit_file ROOT FILE MESSAGE : loud on any failure
  local root="$1" file="$2" msg="$3"
  git -C "$root" add -- "$file" || die "git add failed in $P_SHORT; the log was written but is NOT committed" 3
  git -C "$root" diff --cached --quiet -- "$file" && return 0
  git -C "$root" commit --quiet -m "$msg" -- "$file" \
    || die "git commit FAILED in $P_SHORT (signing or a hook?); the log was written but is NOT committed" 3
}

read_clipboard() {
  if   command -v xclip    >/dev/null; then xclip -selection clipboard -o
  elif command -v xsel     >/dev/null; then xsel --clipboard --output
  elif command -v wl-paste >/dev/null; then wl-paste
  elif command -v pbpaste  >/dev/null; then pbpaste     # macOS (untested)
  else echo "No clipboard tool found. Install one: sudo apt install xclip" >&2; return 1; fi
}

# ------------------------------------------------------------------ arguments
cmd="${1:-}"; shift || true
use_stdin=0; turn_override=""; session=""; commit=1; previous=0; yes=0; args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --stdin) use_stdin=1 ;;
    --turn) turn_override="${2:?--turn needs a number}"; shift ;;
    --session) session="${2:?--session needs a name}"; shift ;;
    --no-commit) commit=0 ;;
    --previous) previous=1 ;;
    --yes) yes=1 ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) args+=("$1") ;;
  esac
  shift
done

usage() {
  echo "Usage: $0 <user|claude> [--stdin] [--turn N] [--session NAME] [--no-commit]" >&2
  echo "       $0 close --previous [--yes] | register <short_name> <path> | status" >&2
  exit 1
}

# ------------------------------------------------------------------ register / status / close
cmd_register() {
  local name="${args[0]:-}" path="${args[1]:-}" top tmp
  [[ -n "$name" && -n "$path" ]] || usage
  [[ "$name" =~ ^[A-Za-z0-9_-]+$ ]] || die "'$name' is not a valid project name (letters, digits, _ and - only)"
  [[ -d "$path" ]] || die "no such directory"
  top="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)" || die "that directory is not inside a git repository"
  [[ "$(conf_get "$top/project.conf" short_name)" == "$name" ]] \
    || die "create project.conf in that repository first, containing the line: short_name=$name"
  mkdir -p "$(dirname "$REGISTRY")"
  tmp="$(mktemp "$REGISTRY.XXXXXX")"
  {
    if [[ -f "$REGISTRY" ]]; then head -1 "$REGISTRY"; else printf 'active %s\n' "$name"; fi
    if [[ -f "$REGISTRY" ]]; then tail -n +2 "$REGISTRY" | awk -F'\t' -v n="$name" '$1!=n'; fi
    printf '%s\t%s\n' "$name" "$top"
  } > "$tmp"
  mv "$tmp" "$REGISTRY"
  echo "Registered $name ($(basename "$top")). Active project: $(reg_active)"
}

cmd_status() {
  local active f rc
  active="$(reg_active)"
  [[ -n "$active" ]] || die "no active project. Register one, then log a message starting: SOS <short_name>"
  load_project "$active"
  echo "Active project : $P_SHORT ($P_LONG)"
  echo "Repository     : $(basename "$P_ROOT")"
  echo "Registered     : $(reg_names | tr '\n' ' ')"
  f="$(latest_log "$P_ROOT" 0)"
  if [[ -z "$f" ]]; then echo "Latest log     : none yet (the next user turn will be Turn 1)"
  else
    rc=0; log_state "$f" "$P_SHORT" || rc=$?
    echo "Latest log     : log/$(basename "$f") ($(case $rc in 0) echo closed;; 1) echo NOT closed;; *) echo no turns;; esac))"
  fi
  if [[ -f "$HOLD" ]]; then echo "HOLD SET       : $(head -1 "$HOLD")"; fi
  echo "Participants   : $P_PART"
  echo "Chat name      : $P_SHORT · $today · <topic>"
  notify "$P_LONG" "Active project: $P_SHORT · chat name: $P_SHORT · $today · <topic>"
}

cmd_close() {
  (( previous )) || die "close needs --previous (the only form implemented)"
  local active name f rc skip i
  local c_name=() c_file=() c_root=()
  active="$(reg_active)"
  while IFS= read -r name; do
    load_project "$name"
    skip=0; [[ "$name" == "$active" ]] && skip=1      # the active project's log for today is in progress
    f="$(latest_log "$P_ROOT" "$skip")"
    [[ -n "$f" ]] || continue
    rc=0; log_state "$f" "$name" || rc=$?
    if (( rc == 1 )); then c_name+=("$name"); c_file+=("$f"); c_root+=("$P_ROOT"); fi
  done < <(reg_names)
  if (( ${#c_name[@]} == 0 )); then echo "No unclosed previous logs found."; return 0; fi
  echo "Unclosed logs that would get a 'closed late, reason unknown' note:"
  for i in "${!c_name[@]}"; do echo "  ${c_name[$i]}: log/$(basename "${c_file[$i]}")"; done
  if (( ! yes )); then
    [[ -t 0 ]] || die "not a terminal: re-run with --yes to confirm"
    read -r -p "Append the note and commit? [y/N] " ans
    [[ "$ans" =~ ^[Yy]$ ]] || { echo "Nothing changed."; return 0; }
  fi
  for i in "${!c_name[@]}"; do
    load_project "${c_name[$i]}"
    printf '\n<!-- closed-late -->\n> **Closed late** (%s): no `COS %s` was logged for this session; reason unknown.\n\n---\n\n' \
      "$today" "${c_name[$i]}" >> "${c_file[$i]}"
    if (( commit )); then commit_file "${c_root[$i]}" "${c_file[$i]}" "log: closed late (${c_name[$i]})"; fi
    echo "Closed late: ${c_name[$i]} log/$(basename "${c_file[$i]}")"
    notify "$P_LONG" "Closed late → ${c_name[$i]}"
  done
}

case "$cmd" in
  register) cmd_register; exit 0 ;;
  status)   cmd_status;   exit 0 ;;
  close)    cmd_close;    exit 0 ;;
  user) role=user ;;
  claude|ai) role=claude ;;
  *) usage ;;
esac

# ------------------------------------------------------------------ log one turn
if (( use_stdin )); then body="$(cat)"; else body="$(read_clipboard)"; fi
[[ -n "${body//[[:space:]]/}" ]] || die "Nothing to log (empty input)."

marker=""; marker_name=""
if [[ "$role" == user ]]; then
  first="$(printf '%s\n' "$body" | grep -m1 -v '^[[:space:]]*$' || true)"
  first="${first#"${first%%[![:space:]]*}"}"
  if [[ "$first" =~ ^(SOS|COS)([[:space:]]|$) ]]; then
    marker="${BASH_REMATCH[1]}"
    if [[ "$first" =~ ^(SOS|COS)[[:space:]]+([A-Za-z0-9_-]+)([[:space:]]|$) ]]; then
      marker_name="${BASH_REMATCH[2]}"
    else
      die "$marker needs a project name, for example: $marker <short_name>. Nothing logged."
    fi
  fi
fi

if [[ -f "$HOLD" && -z "$marker" ]]; then
  die "HOLD: $(head -1 "$HOLD") Only a correct 'SOS <short_name>' or 'COS <active>' message is accepted until then. Nothing logged."
fi

warn=""
case "$marker" in
  SOS)
    HOLD_ON_FAIL=1 load_project "$marker_name"     # unregistered or mismatched: set the hold and refuse
    prev="$(reg_active)"
    if [[ -n "$prev" ]]; then
      prev_path="$(reg_path "$prev")"; prev_path="${prev_path/#\~/$HOME}"
      if [[ -n "$prev_path" && -d "$prev_path" ]]; then
        pf="$(latest_log "$prev_path" 0)"
        if [[ -n "$pf" ]]; then
          rc=0; log_state "$pf" "$prev" || rc=$?
          if (( rc == 1 )) && ! [[ "$prev" == "$marker_name" && "$(basename "$pf")" == "$today"* ]]; then
            warn="**⚠ Log check:** the previous session for $prev (\`log/$(basename "$pf")\`) was not closed with \`COS $prev\`. Run \`scripts/log-turn.sh close --previous\`."
            echo "log-turn: WARNING: previous $prev log is not closed (log/$(basename "$pf"))" >&2
            notify "Previous session not closed" "$prev: log/$(basename "$pf") has no COS. Run: log-turn.sh close --previous" critical
          fi
        fi
      fi
    fi
    reg_set_active "$marker_name"
    rm -f "$HOLD"
    ;;
  COS)
    active="$(reg_active)"
    [[ "$marker_name" == "$active" ]] || hold_die "COS $marker_name does not match the active project (${active:-none}). Nothing logged."
    load_project "$active"
    rm -f "$HOLD"
    ;;
  *)
    active="$(reg_active)"
    [[ -n "$active" ]] || die "no active project. Start the session with a message whose first line is: SOS <short_name>"
    load_project "$active"
    ;;
esac

root="$P_ROOT"
label_user="$P_SHORT USER"

# AI replies must name their own project and author in their heading; nothing is guessed or defaulted.
ai=""
if [[ "$role" == claude ]]; then
  hline="$(printf '%s\n' "$body" | grep -v '^[[:space:]]*$' | grep -m1 -v '^---[[:space:]]*$' || true)"
  hre='^##[[:space:]]+🤖[[:space:]]+([A-Za-z0-9_-]+)[[:space:]]+([A-Za-z0-9_-]+)[[:space:]]+·[[:space:]]+Turn[[:space:]]+([0-9]+|N)[[:space:]]+·[[:space:]]+[0-9]{4}-[0-9]{2}-[0-9]{2}[[:space:]]*$'
  [[ "$hline" =~ $hre ]] || die "the pasted reply does not start with a heading like '## 🤖 $P_SHORT <AI> · Turn N · date'. Not logged: replies are never filed under a default name."
  [[ "${BASH_REMATCH[1]}" == "$P_SHORT" ]] || hold_die "the reply heading names project '${BASH_REMATCH[1]}' but the active project is '$P_SHORT' (wrong SOS, or the reply came from another chat)."
  ai="${BASH_REMATCH[2]}"
  [[ " $P_PART " == *" $ai "* ]] || die "'$ai' is not a listed participant for $P_SHORT (project.conf participants: $P_PART). Not logged."
  [[ "$(printf '%s\n' "$body" | grep -m1 -v '^[[:space:]]*$')" == "---" ]] || body=$'---\n\n'"$body"
  [[ "$(printf '%s\n' "$body" | grep -v '^[[:space:]]*$' | tail -1)" == "---" ]] || body="$body"$'\n\n---'
fi
file="$root/log/$today${session:+-$session}.md"
mkdir -p "$root/log"

# Turn numbering: continue from this session file; if it has no user turns yet, continue from the most
# recent earlier log IN THIS REPOSITORY. A repository with no logs starts at 1. --turn N overrides.
last_turn="$(maxturn "$file")"
if [[ -z "$last_turn" ]]; then
  for f in $(ls -1 "$root"/log/[0-9]*.md 2>/dev/null | sed 's/\.md$//' | LC_ALL=C sort -r | sed 's/$/.md/' || true) "$root/log/log.md" "$root/log.md"; do
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
  if [[ -n "$warn" ]]; then printf '%s\n\n' "$warn" >> "$file"; fi
else
  turn="${turn_override:-$(( last_turn > 0 ? last_turn : 1 ))}"
  if [[ "$last_line" == "---" ]]; then   # the file already ends with a rule: drop the reply's leading one
    body="$(printf '%s\n' "$body" | awk '!d && /^---[ \t]*$/ {d=1; next} {print}')"
  fi
  printf '%s\n\n' "$body" >> "$file"
fi

if (( commit )); then
  commit_file "$root" "$file" "log: $today turn $turn ($role)"
fi

msg="Logged $role turn $turn → $P_SHORT"
[[ -n "$ai" ]] && msg="$msg · $ai"
[[ "$marker" == SOS ]] && msg="$msg · name the chat: $P_SHORT · $today · <topic>"
[[ "$marker" == COS ]] && msg="$msg · now log Claude's reply to finish closing"
echo "$msg"
notify "$P_LONG" "$msg"
