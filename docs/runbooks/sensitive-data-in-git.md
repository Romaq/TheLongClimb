# Runbook: sensitive data committed to git

Use this when something that should not be public was committed. The skill it builds is
**proportion**: matching the size of the response to the size of the problem.

## 1. Triage: what kind of data is it?

| Class | Examples | Response |
|---|---|---|
| **Credential** | password, token, API key, private key | Treat as compromised the moment it is pushed. **Rotate or revoke first**, then clean up history. Rotation is the fix; cleanup is tidying. |
| **Personal or private** | address, phone, health, finance, other people's details | Cannot be rotated. Remove from history **quickly**, then consider asking the host to purge cached views. |
| **Low sensitivity** | exact software versions, default hostnames, hardware models | Fix going forward. History cleanup is optional (good practice, low urgency). Tune the checker so it stops crying wolf, or accept the risk knowingly. |

If unsure, treat it as one class higher until you know.

## 2. The sequence

1. **Stop.** Do not push or commit more until you know where the data is.
2. **Assess.** Which file or line, which commits, and was it pushed?
3. **Contain.** Rotate credentials. For personal data, move to step 4 immediately.
4. **Remove.** Case A or B below.
5. **Verify.** Prove the data is gone from history, not just from the latest snapshot.
6. **Prevent.** Close the gap that let it in.
7. **Record.** One short decision record in `docs/decisions/`, with no sensitive details in it.

## 3. Assess

    git log --all --oneline --name-status -- <path>    # commits that added or removed the file
    git fetch origin
    git branch -r --contains <sha>                      # "origin/main" listed = it was pushed

A common mistake: `git rm` plus a new commit only removes the file from the **newest** snapshot.
Every earlier commit still contains it.

## 4. Remove

### Case A: committed but NOT pushed (cheap)

Squash the unpushed commits so the old text never leaves your machine:

    git fetch origin
    git reset --soft origin/main
    git add -A && git commit -m "describe the real change"
    git reflog expire --expire=now --all && git gc --prune=now    # optional: purge local copies

### Case B: already pushed

1. **Back up first**, because the rewrite is irreversible: `cp -r <repo> <repo>-backup`
2. Install git-filter-repo (GitHub's current guide wants version 2.47 or newer for the extra flag; the plain command works on older versions).
3. Rewrite, then restore the remote that the tool removes on purpose, then force-push:

       git status                                   # must be clean
       git filter-repo --sensitive-data-removal --invert-paths --path <path> --force
       git remote add origin <url>
       git push --force origin main

4. Text that appears in **other** files or in commit messages is not removed by `--invert-paths`.
   Use `--replace-text` with a file of the strings to replace.
5. Old commits can stay reachable through clones, forks, and cached views by commit hash.
   For personal data that cannot be rotated, ask the host's support to purge cached views.
   Support may decline when rotating a credential is enough, so rotate first.

## 5. Verify

    git log --all --oneline -- <path>                      # expect nothing
    git log --all -S'<distinctive fragment>' --oneline     # expect nothing; run locally, never paste the fragment anywhere public
    scripts/privacy-check.sh --all

## 6. Prevent

- `.gitignore`: one entry **per line** (`surveys/responses/`, `tmp/`). Confirm with `git check-ignore -v <path>`.
- Stage explicit paths, not everything (`git add -A` is how stray files get in).
- Keep the pre-push hook installed (`scripts/install-hooks.sh`).
- Tune `scripts/privacy-patterns.txt` and `scripts/privacy-allow.txt` when a pattern is too noisy or too quiet.

## 7. Practice drill (scratch repo, fake values only)

Rehearsing is how this becomes fluent. Nothing here touches a real repo.

    cd /tmp && rm -rf drill drill-remote.git
    git init -q --bare -b main drill-remote.git && git clone -q drill-remote.git drill && cd drill
    echo hello > README.md && git add -A && git commit -qm init && git push -q origin main

    # Drill 1: unpushed leak (Case A)
    echo "FAKE-NOT-REAL-123456" > notes.txt && git add -A && git commit -qm oops
    git rm -q notes.txt && git commit -qm "remove notes"
    echo "real work" > work.md && git add -A && git commit -qm "real work"
    git log --oneline --all -- notes.txt          # the fake leak is still in history
    # now apply Case A, then confirm the same command prints nothing

    # Drill 2: pushed leak (Case B)
    # repeat the leak, run `git push origin main`, then practice Case B against the scratch remote

Success looks like: you can state the class, run the right case without looking, and verify.
