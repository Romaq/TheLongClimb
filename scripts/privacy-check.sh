#!/usr/bin/env bash
# privacy-check.sh - scan text you are about to publish for personal or sensitive details.
#
# Usage: scripts/privacy-check.sh [--unpushed | --all] [--notify]
#   --unpushed  (default) scan what a push would publish: every added line that differs from
#               origin/main (unpushed commits plus uncommitted changes to tracked files).
#               Before the first push (no origin/main yet) the whole tracked tree is scanned.
#   --all       scan every non-ignored file in the working tree, tracked or not
#   --notify    also raise a desktop notification on failure (used by the pre-push hook)
# Exit status: 0 clean, 1 possible issues found, 2 setup/usage error.
#
# Patterns live in scripts/privacy-patterns.txt; ignored text in scripts/privacy-allow.txt.
# Matched values are masked in the report, so the output is safe to paste into a chat.
set -uo pipefail

mode=unpushed; notify=0
for a in "$@"; do
  case "$a" in
    --unpushed) mode=unpushed ;;
    --all)      mode=all ;;
    --notify)   notify=1 ;;
    *) echo "Usage: $0 [--unpushed | --all] [--notify]" >&2; exit 2 ;;
  esac
done

root="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Not inside a git repo." >&2; exit 2; }
cd "$root"
patterns="$root/scripts/privacy-patterns.txt"
allow="$root/scripts/privacy-allow.txt"
[[ -f "$patterns" ]] || { echo "Missing $patterns" >&2; exit 2; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
skip_self=(':!scripts/privacy-patterns.txt' ':!scripts/privacy-allow.txt')

# What are we comparing against?
if git rev-parse --verify -q origin/main >/dev/null; then base=origin/main
else base="$(git hash-object -t tree /dev/null)"; fi

# 1) Build the list of paths and the list of lines to scan. Line format: path<TAB>number<TAB>text
if [[ "$mode" == "all" ]]; then
  git ls-files -co --exclude-standard | grep -vxF -e scripts/privacy-patterns.txt -e scripts/privacy-allow.txt > "$tmp/paths"
  : > "$tmp/lines"
  while IFS= read -r f; do
    [[ -f "$f" ]] && grep -Iq . "$f" 2>/dev/null && awk -v OFS='\t' -v p="$f" '{print p, NR, $0}' "$f" >> "$tmp/lines"
  done < "$tmp/paths"
else
  git diff --name-only --diff-filter=AM "$base" -- . "${skip_self[@]}" > "$tmp/paths"
  git diff --no-color -U0 --diff-filter=AM "$base" -- . "${skip_self[@]}" \
    | awk -v OFS='\t' '
        /^\+\+\+ /  { path = substr($0, 7); next }
        /^@@/       { match($0, /\+[0-9]+/); line = substr($0, RSTART + 1, RLENGTH - 1) + 0; next }
        /^\+/       { print path, line, substr($0, 2); line++ }' > "$tmp/lines"
fi

mapfile -t META < <(cut -f1,2 "$tmp/lines")
cut -f3- "$tmp/lines" > "$tmp/text"

grep -vE '^[[:space:]]*(#|$)' "$allow" 2>/dev/null > "$tmp/allow" || true

mask() { local v="$1"; if (( ${#v} <= 4 )); then echo '***'; else echo "${v:0:3}...(${#v} chars)"; fi; }
count=0
report() { printf '  %-28s %-34s %s\n' "$1" "$2" "$3"; count=$((count + 1)); }

echo "Privacy check ($mode, compared with ${base:0:12}):"

# 2) Paths that should never be published.
bad_path='^surveys/responses/|(^|/)\.env($|\.)|\.pem$|(^|/)id_(rsa|ed25519|ecdsa)(\.pub)?$|\.private\.'
while IFS= read -r p; do
  [[ "$p" =~ $bad_path ]] && report "sensitive-path" "$p" "file should not be published"
done < "$tmp/paths"

# 3) Pattern matches inside the scanned lines.
while IFS=$'\t' read -r name regex; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  while IFS= read -r hit; do
    idx="${hit%%:*}"; val="${hit#*:}"
    if [[ -s "$tmp/allow" ]] && grep -qxFf "$tmp/allow" <<< "$val"; then continue; fi
    IFS=$'\t' read -r path line <<< "${META[idx-1]}"
    report "[$name]" "$path:$line" "$(mask "$val")"
  done < <(grep -noP -- "$regex" "$tmp/text" 2>/dev/null)
done < "$patterns"

if (( count == 0 )); then
  echo "  No possible issues found. (Names, health, money, and similar need your own judgment.)"
  exit 0
fi

cat >&2 << MSG

$count possible issue(s). Nothing was changed.
 1. Edit the flagged file(s): remove each value or swap in a placeholder such as [REDACTED].
 2. If the text is already committed but NOT pushed:
      git fetch origin && git reset --soft origin/main
      git add -A && git commit -m "log: <what changed>"
    (No origin/main yet? Start history over: git update-ref -d HEAD && git add -A && git commit -m "Initial commit")
 3. Harmless match? Add the matched text to scripts/privacy-allow.txt.
 4. One-time override for a push: CT_SKIP_PRIVACY=1 git push
MSG
(( notify )) && command -v notify-send >/dev/null && notify-send -u critical "CopperToolchain privacy check" "$count possible issue(s); push blocked"
exit 1
