# Privacy check: when and how to use it

This repository is public and git history is permanent. `scripts/privacy-check.sh` is a
mechanical second pair of eyes that looks for common leaks before they are published.
It does not replace your own judgment: it cannot recognize names, health, money, or
family details. It finds patterns such as addresses, identifiers, keys, and home paths.

## One-time setup (per clone)

    scripts/install-hooks.sh

This installs a `pre-push` hook, so every `git push` (including `scripts/sync.sh`) runs
the check first and is blocked if anything is flagged. Hooks are not versioned, so repeat
this in every clone you push from.

## When to run it

| Moment | Why | Command |
|---|---|---|
| Automatically, just before every push | Catches everything about to become public, including text merged in by `pull --rebase` | (hook, nothing to type) |
| After hand-editing a log, or after pasting a system report or terminal output | Fastest feedback while the text is fresh | `scripts/privacy-check.sh` |
| Before the first push of a new repo, and after bulk edits | Covers files that are not committed yet | `scripts/privacy-check.sh --all` |

Run it again after resolving a rebase conflict, before pushing, because the conflict
resolution can bring text from the other side into your commit.

## Reading the report

    [ipv4-address]   log/2026-11-02.md:41   192...(10 chars)

Each line gives the pattern, the file and line number, and a masked excerpt: the first three
characters and the length. The value itself is never printed, so the report is safe to paste
into a chat. Open the file at that line and decide.

## Fixing a finding

1. Edit the file: delete the value or replace it with a placeholder such as `[REDACTED]`.
2. If the text is already committed but not pushed, squash the commits so the old text never
   reaches GitHub:

       git fetch origin && git reset --soft origin/main
       git add -A && git commit -m "log: what changed"

3. If the match is harmless, add the exact matched text to `scripts/privacy-allow.txt`.
4. To push once despite findings: `CT_SKIP_PRIVACY=1 git push`.

If the text was already pushed, fixing the file is not enough: the old commit stays in history.
Rewrite history and force-push (`git push --force-with-lease`), and treat any secret as exposed
and rotate or revoke it.

## Tuning

- `scripts/privacy-patterns.txt`: one pattern per line as `NAME<TAB>REGEX` (PCRE, used with `grep -P`).
- `scripts/privacy-allow.txt`: exact strings to ignore.
- Files under `surveys/responses/`, `.env` files, and key files are always flagged by path.

## Limits

- Pattern matching produces false positives (version numbers that look like addresses) and false negatives.
- Only added lines are scanned in the default mode, so older text already on GitHub is not re-checked. Use `--all` for a full sweep.
- It runs on the machine where you push. A push from inside a sandboxed app may lack the hook or tools.
