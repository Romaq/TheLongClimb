#!/usr/bin/env bash
# install-hooks.sh - ONE-TIME per clone: block any `git push` that fails the privacy check.
# Git hooks are not versioned, so run this in every clone you push from.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
hook="$root/.git/hooks/pre-push"
if [[ -e "$hook" ]] && ! grep -q 'privacy-check.sh' "$hook"; then
  echo "A different pre-push hook already exists: $hook" >&2
  echo "Add this line to it instead: scripts/privacy-check.sh --unpushed --notify || exit 1" >&2
  exit 1
fi
cat > "$hook" << 'HOOK'
#!/usr/bin/env bash
# Installed by scripts/install-hooks.sh: stop pushes that contain possible personal details.
[[ -n "${CT_SKIP_PRIVACY:-}" ]] && exit 0
root="$(git rev-parse --show-toplevel)"
exec "$root/scripts/privacy-check.sh" --unpushed --notify
HOOK
chmod +x "$hook"
echo "Installed pre-push hook: $hook"
