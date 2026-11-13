# STATE-ChatGPT.md — The Long Climb

**Last updated:** 2026-11-13  
**Maintained by:** TLC ChatGPT  
**Purpose:** ChatGPT-specific continuity and handoff notes. This document supplements the repository-root `STATE.md`; it does not replace it.

---

## 1. Project and collaboration

**TLC** means The Long Climb, a Minecraft modpack project.

**TFC** means TerraFirmaCraft for Minecraft 1.21.1 on NeoForge.

**CT** means CopperToolchain. “Copper Toolchain” and “The Copper Toolchain” refer to the same project.

The project owner is the final decision-maker. ChatGPT is an additional collaborator alongside TLC Claude.

### Division of responsibilities

ChatGPT contributes:
- Character and personality development.
- World-building and gameplay design.
- Functional requirements and design review.
- Documentation and decision consistency.
- Independent review of Claude's technical proposals and code.
- Technical research and implementation assistance where useful.

Claude is the primary technical implementation collaborator:
- Technical architecture.
- Java mod development.
- Build configuration.
- Technical integration research.

The owner relays material between the AI collaborators as needed.

Keep all Hearth work in the TLC repository unless a concrete operational need for a separate repository is established and the owner approves it.

The owner is a capable technical thinker but does not write Java. If implementation work begins, provide buildable increments and clear testing instructions.

---

## 2. Current priority: Live Logging

**Live Logging remains the immediate priority.**

Do not resume Hearth design or implementation until the owner confirms that Live Logging is reliable and provides a new direction.

The Live Logging workflow is still in flux and has not yet been confirmed as reliable end-to-end. The owner has indicated that current sessions may soon be folded into `TLC/log/2026-11-13.md`, but this must not be treated as verified.

This session was explicitly outside Live Logging, pending CT's decision about whether and how to incorporate its discussion.

ChatGPT must not claim that a conversation has been logged, processed by the local script, or committed unless the owner confirms that this actually happened.

### Known workflow context

The existing CT clipboard workflow has been described as:

1. The user copies an AI response's designated text block.
2. A keybind or script reads the clipboard.
3. The script determines the dated log destination and appends or creates the log.
4. Local commits are managed.
5. Sensitive information is screened.
6. Commits may be held until content is sanitized, security issues are resolved through allow-list files, or the user explicitly authorizes a one-time force.
7. Local changes are synchronized.

The complete execution chain has not yet been established.

Published CT scripts previously inspected:
- `scripts/log-turn.sh`
- `scripts/sync.sh`

The published `log-turn.sh` appeared to support clipboard/stdin input, dated logs, session names, turn numbering, and USER/CLAUDE roles. It appeared to commit immediately, with no visible privacy scan in that script itself. Privacy screening may occur in a wrapper, keybinding, Git hook, another script, or a newer local version.

Do not assume published scripts match the owner's local versions.

Before proposing changes, establish the actual execution chain, including:
- Keybinding or launcher.
- Clipboard wrapper.
- Logging script.
- Privacy checker.
- Git hooks.
- Commit and synchronization scripts.

Preserve existing CLAUDE/USER behavior and all privacy and commit safeguards. Test changes in a scratch environment, not live logs. Do not modify scripts without owner approval.

ChatGPT cannot invoke the owner's local keybind, inspect the clipboard, run local scripts, or independently receive automatic live events. ChatGPT can prepare correctly formatted log blocks, inspect accessible repository content, review proposed changes, and help troubleshoot.

---

## 3. Sensitive-data documentation ownership — OPEN / PROPOSED

The owner is reconsidering whether TLC should maintain its own sensitive-data runbook.

**Current proposal for CT discussion:**
- CT should maintain the authoritative specifics of sensitive-data guidance.
- TLC and other CT-dependent projects should refer to CT's authoritative documentation rather than maintain independent copies.
- The goal is to avoid peer drift between documents that are essential and unlikely to need project-specific forks.

This is a proposal to raise in a CT session. It is **not an accepted decision**.

Until CT decides:
- TLC's existing `docs/runbooks/sensitive-data-in-git.md` remains present, but its authority and future status are under review.
- Do not treat that TLC document as the authoritative source of TLC privacy policy without checking the CT decision.
- Do not delete, retire, or replace it based on this proposal alone.
- Do not assume an equivalent authoritative CT runbook exists without verifying it.
- Preserve the owner's concern about peer drift.

The CT repository's `docs/privacy-check.md` has been inspected. It describes the privacy checker and hook, including limitations: the checker does not reliably recognize names, health, money, or family details; it can catch patterns such as addresses, identifiers, keys, and home paths; false positives and false negatives are possible. Human review remains necessary.

---

## 4. ChatGPT privacy-review responsibility — ACCEPTED

ChatGPT is expected to act as a second pair of eyes when reviewing visible conversation content or proposed public log content.

Review for potential disclosure of:
- Personal names, except approved public usernames.
- Health information.
- Financial information.
- Family details.
- Addresses and other identifying details.
- Credentials and private paths.
- Identifying details about other people.

If potential disclosure is present:
1. Flag it before discussing other content.
2. Do not repeat the sensitive value in the warning or quote it back.
3. Offer neutral placeholder wording, such as `[PRIVATE-1]`, `[HEALTH-DETAIL-1]`, or `[REDACTED]`.
4. Leave the final decision to the owner.

Do not encourage pasting private files or unredacted private reports into public conversation or logs. Suggest attaching private files instead when appropriate.

ChatGPT's review is qualitative and imperfect. It cannot run local scripts, inspect the clipboard or working tree, or guarantee detection. It does not replace CT's automated privacy checker.

Do not weaken safeguards or advise bypassing the privacy checker merely to make logging easier.

---

## 5. Names, session markers, and formatting

### Approved public usernames

The public usernames `Romaq` and `DJV22` may be used in project discussion. This permission does not extend to legal names or other personal identifying details.

### Session markers

- `SOS TLC` opens a TLC session.
- `COS TLC` closes a TLC session.

Use SOS for opening and COS for closing unless the owner explicitly changes the convention.

### AI headings

Claude:
`## 🤖 TLC CLAUDE · Turn N · YYYY-MM-DD`

ChatGPT:
`## 🤖 TLC ChatGPT · Turn N · YYYY-MM-DD`

AI replies begin and end with `---` framing.

The user-supplied turn number is authoritative. Ask if unsure; never invent or increment it. If the user writes `Turn N` as a placeholder, do not construct a formal heading until the actual number is known.

A user turn may be spent across multiple AI agents; turn numbering is not AI-specific.

### Session titles

`<short_name> · YYYY-MM-DD · <task>`

If there are two sessions on the same day, append `a` and `b`.

Use a fresh conversation per task where practical.

If the owner says “More to follow — please wait,” acknowledge briefly and wait. If multiple messages are expected, wait for “That's the complete submission. Please respond.”

### Stray thoughts

Use `tmp/stray.md` for stray thoughts. It is git-ignored in both CT and TLC. A future parking document may periodically gather parked topics.

---

## 6. Repository and authority

Repositories:
- Copper Toolchain: `https://github.com/Romaq/CopperToolchain`
- The Long Climb: `https://github.com/Romaq/TheLongClimb`

The authoritative shared TLC `STATE.md` is in the repository root:

`TheLongClimb/STATE.md`

It is not in `docs/`.

ChatGPT maintains this supplemental document in the same repository root:

`TheLongClimb/STATE-ChatGPT.md`

At the beginning of the next TLC ChatGPT session, read both root-level documents and reconcile conflicts rather than silently choosing one.

The owner reviews, approves, and applies ChatGPT's proposed state-document updates. ChatGPT must not write to GitHub or modify the repository without explicit owner authorization.

Repository access and previously observed permissions do not constitute authorization to commit or push.

---

## 7. Design judgement references

CT guidance previously consulted:

- `CopperToolchain/docs/runbooks/can-vs-should.md`
- `CopperToolchain/docs/runbooks/design-maxims.md`
- `CopperToolchain/docs/PROJECT-GUIDE.md`
- `CopperToolchain/docs/privacy-check.md`

The five questions in `can-vs-should.md`:

1. What problem does it solve today?
2. What breaks if it fails?
3. How many minutes a month does it cost to maintain?
4. Could I rebuild it from a short written recipe?
5. Is there an existing tool, or a simpler 80% solution?

Relevant design maxims:
- Make mistakes hard to make, easy to catch, and easy to correct.
- Make bad judgement cheap through scratch testing, backups, and reversible steps.
- Ask whether something should exist before asking whether it can be built.
- When options are imperfect, prefer the one that is easiest to undo, fails visibly, and can be rebuilt from a short recipe.
- Make it work and define verification before polishing.
- Avoid reinventing tools without a clear reason.
- Test risky changes where failure is cheap and know the rollback path.
- A long run of green checks is a reason to test the checks.
- Automation needs an alert when it stops.
- On failure, stop, contain, record the lesson without sensitive details, and take one small next step.

---

## 8. Accepted conventions and unresolved items

### Accepted

- TLC and TFC terminology as defined above.
- CT means CopperToolchain.
- SOS opens and COS closes a session.
- User-supplied turn numbers are authoritative.
- ChatGPT provides qualitative privacy review as an independent safeguard.
- ChatGPT prepares complete replacement state documents for owner review.
- TLC's root `STATE.md` remains the shared project authority.
- ChatGPT's `STATE-ChatGPT.md` is supplemental.
- No repository writes without explicit owner approval.

### Open / proposed

- CT decision on central ownership of sensitive-data guidance and TLC's reference/copy policy.
- The complete local Live Logging execution chain.
- End-to-end reliability verification for Live Logging.
- Whether and how ChatGPT sessions should be incorporated into the logging workflow.
- Exact `HANDOFF CHECK` template, if one is prescribed by the repository's current project instructions.

---

## 9. Next TLC ChatGPT session

1. Read root `STATE.md`.
2. Read this root `STATE-ChatGPT.md`.
3. Reconcile any discrepancies and identify which decisions are accepted versus proposed.
4. Confirm the current Live Logging status with the owner.
5. Do not resume Hearth design or implementation until the owner confirms Live Logging is reliable and gives a new direction.
6. Carry the CT sensitive-data documentation ownership proposal into the next CT discussion; do not treat it as decided.
7. Continue the qualitative privacy-review responsibility.
8. Do not claim that this session or any other session was logged unless verified by the owner.

At session close, prepare a complete replacement of this document with the date, current priority, decisions, open items, and next-session instructions. The owner reviews and applies it.

---

**End of ChatGPT-specific project state.**
