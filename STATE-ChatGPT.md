# ChatGPT handoff state — The Long Climb (TLC)

**Document:** `STATE-ChatGPT.md`  
**Last updated:** 2026-11-13  
**Purpose:** Carry ChatGPT's working context between TLC sessions without requiring the owner to reproduce the conversation history.

## Authority and scope

- The authoritative shared project state is the committed `STATE.md` in the TLC repository root.
- This document is ChatGPT's collaborator-specific handoff. It supplements `STATE.md`; it does not replace it or override it.
- The owner is the final authority on project direction, decisions, priorities, and acceptance.
- If this document conflicts with `STATE.md`, a newer owner instruction, or another authoritative project document, flag the conflict and ask rather than silently choosing.
- Treat this document as a concise working reference, not a transcript. Preserve decisions, current status, unresolved questions, and next actions.
- ChatGPT prepares updates to this document at session close. The owner inspects, approves, and applies them to the repository.
- Do not modify the repository or push changes unless the owner explicitly authorizes that action.

## Names and conventions

- `TLC` always means this project (The Long Climb).
- `TFC` always means TerraFirmaCraft for Minecraft 1.21.1 on NeoForge.
- `CT` means CopperToolchain ("Copper Toolchain" and "The Copper Toolchain" are synonyms). Correct ambiguity gently.
- `Romaq` and `DJV22` are public usernames and may be used in project discussion. Do not infer that other personal names or details are public.
- Heading for Claude replies: `## 🤖 TLC CLAUDE · Turn N · YYYY-MM-DD`. Replies start and end with `---`.
- Heading for ChatGPT replies: `## 🤖 TLC ChatGPT · Turn N · YYYY-MM-DD`. Replies use the same `---` framing.
- ChatGPT entries belong in a discrete segment of TLC's dated log files until the Hearth mod is split into its own project and repository, if ever.
- The user's supplied turn number is authoritative. Use the same turn number in the AI response. Never invent or independently increment it. Ask if it is missing or unclear.
- The user's turn begins with a project/session marker and a `Turn N` line. The marker identifies the project to the CT script.
- `SOS TLC` opens a session and identifies TLC as the active project.
- `COS TLC` closes a session. The closing user turn is followed by the AI's closing response and updated handoff state.
- **Convention clarification:** The current shared `STATE.md` specifies `SOS TLC` for opening and `COS TLC` for closing. One later owner description initially referred to `COS TLC` as the opening marker, but subsequently gave the same `SOS`/`COS` distinction as the shared state. Use `SOS` to open and `COS` to close unless the owner corrects this.
- Session titles: `<short_name> · YYYY-MM-DD · <task>`. Two sessions on the same day use `a` and `b`.
- The dated live log is public. Treat every proposed log entry as public before helping prepare it.
- Private files should be attached, not pasted into the public conversation or log.
- Be direct. State what was tested and what was not. Keep steps small.
- Inventory additions: notify the owner first, then provide the proposed entry. The owner applies it.
- Stray thoughts go in `tmp/stray.md`, which is git-ignored in both CT and TLC. A later session may collect them into a parking document for periodic review.
- Apply the five questions in CT's `docs/runbooks/can-vs-should.md` before proposing any new tool, script, service, or dependency.
- Scripts run on the host through system keyboard shortcuts. The editor is a sandboxed Flatpak.
- Use one fresh conversation per task where practical. End each session by preparing a complete replacement for `STATE-ChatGPT.md`.
- Every session-ending reply, or reply producing something needed by the other project, closes with a `HANDOFF CHECK` block following the project instructions. If the exact project template is unavailable, ask the owner for it rather than claiming to reproduce it exactly.
- Design maxims are in the CT repository at `docs/runbooks/design-maxims.md`. Consult them as a guide to design choices.
- The five-question checklist is in CT at `docs/runbooks/can-vs-should.md`. The path is `docs/runbooks/`, plural.
- Within CT, the maxims and checklist are guidance for judgement, not automatic reasons to reject a proposal. Explain trade-offs and let the owner decide.

## Privacy and public-log review

The TLC log and repository are public. Git history may preserve material after it is removed from the latest file.

ChatGPT acts as an additional human-readable privacy review before log text is handed to the local logging workflow.

- Review visible conversation content and proposed log entries for personal or sensitive information, especially personal names, health, financial or money details, family details, addresses, credentials, private paths, and identifying information about other people.
- If a potential disclosure is present, flag it before addressing the rest of the proposed content.
- Do not repeat the sensitive value in the warning or quote it back. Refer to its category or location in general terms.
- Offer neutral placeholder wording, such as `[PRIVATE-1]`, `[HEALTH-DETAIL-1]`, or `[REDACTED]`.
- The owner decides whether a detail is safe and whether a proposed placeholder is appropriate.
- Public usernames explicitly approved by the owner (`Romaq` and `DJV22`) are permitted. This permission does not extend to legal names or other identifying details.
- Do not encourage pasting private files or unredacted private reports into the public log. Attach private files instead.
- If the owner pastes potentially sensitive content, avoid repeating it in the response, even when explaining the concern.
- If uncertain, flag the concern and ask the owner to decide. Do not silently assume a detail is safe.

**Important limitation:** ChatGPT's review is an additional qualitative check, not a substitute for the CT privacy checker or TLC's local Git hook. ChatGPT cannot execute the owner's local scripts, inspect the clipboard, inspect the local working tree, or verify what the pre-push hook will detect. It cannot guarantee detection of every disclosure.

The CT privacy guidance explains that its automated checker has both false positives and false negatives. It does not reliably recognize names, health, money, or family details. Human review remains necessary.

Relevant references:

- TLC: `docs/runbooks/sensitive-data-in-git.md`
- CT: `docs/privacy-check.md`
- CT: `scripts/privacy-check.sh`
- TLC: `.git/hooks/pre-push` invokes TLC's privacy check.

Never recommend bypassing or weakening the privacy check merely to make logging easier. Any exception or allow-list change belongs to the owner and must be deliberate.

## Project context and collaborator role

The Long Climb is a Minecraft modpack project targeting Minecraft 1.21.1 on NeoForge, with TerraFirmaCraft as a central dependency.

ChatGPT is an additional collaborator. Its useful responsibilities include:

- Character, personality, and dialogue development.
- World-building and gameplay design.
- Functional requirements and design review.
- Documentation and decision consistency.
- Independent review of Claude's technical proposals and generated code.
- Technical research and implementation assistance where useful.

Claude is the primary technical implementation collaborator for architecture, Java mod development, build configuration, and integration research. These roles are primary responsibilities, not exclusive restrictions.

The owner makes final decisions and coordinates work between the AIs.

The Hearth is a planned stationary, multi-block community guide and technological-uplift intelligence within TLC. It is intended to support the community's progression through technological eras. Its detailed design and implementation are secondary to the current Live Logging work.

All Hearth work remains within TLC's repository and documentation structure for now. Do not create a separate repository without a concrete operational reason and owner approval.

## Current priority: CopperToolchain Live Logging

**Status as of 2026-11-13: In progress; not yet verified end-to-end.**

The immediate priority is to make the existing CT Live Logging workflow reliably accept ChatGPT contributions alongside the user's and Claude's turns.

The owner reports that the workflow is nearing the point where the current sessions can be incorporated into:

`TLC/log/2026-11-13.md`

However, the workflow is still in flux. Do not describe it as complete, tested, or accepted until the owner verifies it.

### Owner's logging convention

- The owner opens a session with `SOS TLC`.
- The next line supplies the turn number, for example `Turn 13`.
- That turn number is used for the corresponding AI response.
- Claude's response heading follows the exact convention:

  `## 🤖 TLC CLAUDE · Turn 13 · 2026-11-12`

- ChatGPT's corresponding heading follows:

  `## 🤖 TLC ChatGPT · Turn 13 · 2026-11-12`

- The owner may spend turns with different AI agents within the same TLC project. The turn number is not an AI-specific counter.
- The AI speaker is identified by the response heading.
- The owner closes a session with `COS TLC`, followed by the turn number.
- The AI then acknowledges the close and supplies its updated state document.
- The CT script maintains a registry of project shortnames and the active project. The marker identifies the project/session state for the script.
- The owner is responsible for supplying the correct turn number. If uncertain, ChatGPT asks rather than guessing.

### Logging workflow requirements

The intended workflow should:

1. Preserve the existing user and Claude logging behavior.
2. Accept ChatGPT as an additional speaker, identified by its response header.
3. Keep ChatGPT's entries in TLC's dated logs, not a separate Hearth log or repository.
4. Preserve the owner's turn numbering as authoritative.
5. Recognize session opening and closing markers consistently.
6. Retain existing privacy checks, approval mechanisms, and commit safeguards.
7. Avoid creating a second logging system if the existing CT workflow can be generalized safely.

### Known status and limitations

- The owner has described a clipboard-based workflow using local scripts and system keyboard shortcuts.
- The CT scripts are maintained centrally for use by projects.
- ChatGPT can prepare correctly formatted text for the clipboard workflow.
- ChatGPT cannot invoke the owner's local shortcuts, read the clipboard, or observe script notifications.
- A successful-looking response in chat does not prove that the local script appended, committed, or synchronized the entry.
- The actual execution chain, including wrappers, keybindings, privacy checks, and Git hooks, must be understood before proposing changes.
- Published script contents may not represent every local change. The local installation must be compared with the repository before drawing conclusions.
- Do not modify TLC scripts or hooks as a workaround for an unverified CT issue.
- Do not weaken the privacy safeguards to make ChatGPT logging work.

### Immediate next steps

1. Continue from the owner's current Live Logging work and the latest response from TLC Claude.
2. Establish the complete local execution chain and compare it with the published CT scripts.
3. Determine the minimum safe change needed to support ChatGPT as a speaker.
4. Preserve the existing safeguards and test in a scratch environment where possible.
5. Have the owner verify the actual local append, commit, close-session behavior, and privacy check.
6. Only after the owner confirms success should Live Logging be marked verified and Hearth design work resume.

Do not assume that the sessions have already been incorporated into `log/2026-11-13.md`. The owner will confirm when that has happened.

## Design judgement

Use CT's design maxims as practical prompts:

- Make mistakes hard to make, easy to catch, and easy to correct.
- Good judgement comes from experience; make bad judgement cheap through scratch testing, backups, and reversible steps.
- Ask whether a thing should exist before asking whether it can be built.
- When all options are imperfect, choose the easiest to undo, the one that fails visibly, and the one that can be rebuilt from a short written recipe.
- Make it work, define how it will be verified, and defer polish until it works.
- Do not reinvent an existing tool without a clear reason.
- Test risky changes where failure is cheap; know the exit or rollback path first.
- A long run of green checks is a reason to test the checks themselves.
- Automation that runs unattended needs a way to report when it stops working.
- Consider the needs of the person using the tool, not just the convenience of its author.
- When failure occurs, stop, contain it, record the lesson without sensitive details, and take one small next step.

For new tools, scripts, services, or dependencies, consult all five questions in `CopperToolchain/docs/runbooks/can-vs-should.md`:

1. What problem does it solve today?
2. What breaks if it fails?
3. How many minutes a month does it cost to maintain?
4. Could it be rebuilt from a short written recipe?
5. Is there an existing tool, or a simpler 80% solution?

## Current accepted and open items

### Accepted working conventions

- TLC is the project and repository for current Hearth work.
- `STATE.md` in the repository root is the shared project-state reference.
- `STATE-ChatGPT.md` in the repository root is ChatGPT's supplemental handoff document.
- The owner's turn number is authoritative.
- ChatGPT uses the `TLC ChatGPT` response heading.
- ChatGPT's log entries belong in the TLC dated log.
- Session opening and closing use `SOS TLC` and `COS TLC`, respectively, pending owner correction of the one conflicting description noted above.
- The owner reviews and applies state-document updates.
- Privacy review is required before preparing public log content.

### Open or unverified

- Live Logging support for ChatGPT has not yet been verified end-to-end.
- The exact local script/keybinding execution chain must be confirmed.
- The complete privacy screening and commit chain must be confirmed against the local installation.
- The exact HANDOFF CHECK format in the current project instructions must be consulted when available.
- The owner has not yet confirmed that the current sessions have been folded into the dated live log.
- Hearth design and implementation remain secondary until Live Logging is reliable.

## Next-session instructions

At the start of a new TLC ChatGPT session:

1. Read this file and the current root-level `STATE.md`.
2. Follow the owner's opening marker and turn number.
3. Confirm the current task and any changes since this document was written.
4. If the task concerns logging, continue the Live Logging verification work. Do not jump ahead to Hearth design.
5. Consult relevant CT documentation when making proposals about scripts, privacy, or workflow.
6. Review public-log content for sensitive details before helping prepare it.
7. Keep accepted decisions distinct from proposals and open questions.

At session close:

1. Acknowledge `COS TLC`.
2. Do not assume that the logging script successfully closed the session; the owner verifies that locally.
3. Prepare a complete replacement for `STATE-ChatGPT.md`, not merely a list of suggested edits.
4. Update the date, current priority, accepted decisions, open items, and next-session instructions.
5. Do not promote proposals to accepted decisions without the owner's approval.
6. Close with the required `HANDOFF CHECK` block.
7. Leave the final application, commit, and push to the owner unless explicitly instructed otherwise.

---

**End of ChatGPT handoff state.**
