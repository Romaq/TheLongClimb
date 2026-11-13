# Handoff state, TLC (2026-11-12)

Purpose: let a fresh Claude conversation in The Long Climb (TLC) continue without re-reading the whole log.
Authority: the committed copy at `STATE.md` in the project root on GitHub `main` (not in `docs/`, per CT Claude). Claude supplies changes; the owner applies,
commits, pushes, and uploads the new copy to the project files. Refer to it only as `STATE.md`.

Caveat for the reader: this version was rebuilt from project memory and the project files, not from a committed copy.
Diff it against the committed root copy and keep anything that copy has that this one lacks. An earlier `docs/STATE.md` may exist and should be retired.

## The project in one paragraph

TLC is a Claude.ai project paired with the public repository github.com/Romaq/TheLongClimb. It manages the
Minecraft modpack "The Long Climb": a technology chain from flintknapping to atomic power and interstellar travel,
tone "grounded with a wink" (`docs/TONE.md`). Generic tooling belongs in CopperToolchain (CT), of which TLC is a customer.

## Names and conventions

- `TLC` always means this project (The Long Climb). `TFC` always means TerraFirmaCraft for Minecraft 1.21.1 on NeoForge. `CT` means CopperToolchain ("Copper Toolchain", "The Copper Toolchain" are synonyms). Correct any ambiguity gently.
- Heading for Claude replies: `## 🤖 TLC CLAUDE · Turn N · YYYY-MM-DD`. Replies start and end with `---`. The user's turn number is authoritative; ask if unsure.
- Heading for ChatGPT turns: `TLC CHATGPT Turn N`.
- The user's turn opens with `SOS TLC` (start) or `COS TLC` (close). `SOS` tells the CT script which project is active.
- Session titles: `<short_name> · YYYY-MM-DD · <task>`; two sessions on one day get `a` and `b`.
- The log is public. Flag personal details before anything else, offer placeholder wording, never repeat them. Private files are attached, not pasted.
- Be direct; say what was tested and what was not; keep steps small. Inventory additions: notice first, then the entry, and the owner applies it.
- Apply the five questions in `docs/runbooks/can-vs-should.md` before adding any tool, script, service, or dependency.
- Claude's sandbox has no SSH or network and cannot fetch GitHub file pages. Anything involving the live repo, a server, or a tunnel is untested until the owner runs it.
- Scripts run on the host through system keyboard shortcuts (the editor is a sandboxed Flatpak).
- One fresh conversation per task; end each session by rewriting `STATE.md`.
- Every reply that ends a session, or produces something the other project needs, closes with a HANDOFF CHECK block (format in the project instructions).
- Design maxim to pass to CT: make mistakes hard to make, easy to catch, easy to correct. Owner's koan for CT's maxim list: "Good judgement comes from experience / Experience comes from bad judgement".

## Tools from CT

- `docs/TOOLS.md` in the project files has manifest date **2026-11-06** (hand-written stopgap; CT's GitHub `docs/TOOLS.md` on `main` is the authority and will become generated). State the date at each session start. Do not assume a tool exists if it is not listed.
- Needs go to CT as `REQUEST FOR THE COPPERTOOLCHAIN PROJECT` blocks. Copied scripts are recorded in `tools/FROM-COPPERTOOLCHAIN.md` and credited in the README.
- TLC's `.git/hooks/pre-push` is the kit's hook and stays unchanged; it runs TLC's own `scripts/privacy-check.sh`. Do nothing to TLC's `scripts/` folder until CT Claude decides.

## Live Logging (the current verification task)

- Scripts live in `~/Projects/CopperToolchain/scripts` and are maintained by CT for all projects. TLC, CT Claude and TLC ChatGPT use the same keybindings and workflow.
- Test so far: on 2026-11-12 the owner opened with `SOS TLC` (Turns 1 and 10) to test the handover. The script requires that first line; Claude disregards it.
- Header check: `🤖 CLAUDE` failed; `## 🤖 TLC CLAUDE · Turn N · date` is the expected form. Corrected in the 2026-11-12 close.
- Closed-session rule in the CT design: a session is closed if the last user turn starts with `COS <short_name>` and a Claude turn follows. The first close attempt used `COS` alone; the second used `COS TLC` correctly. Turn-number errors in the log came from hand-editing and are corrected.
- Tomorrow: open with `SOS TLC` and verify the handover works in practice, then triage pending TLC issues. The ChatGPT block waits until Live Logging is verified.

## Decisions so far

1. Repository `TheLongClimb` is public, licence 0BSD, remote style SSH, first push done 2026-11-08 with a clean privacy check.
2. Pack platform: CurseForge. NeoForge 1.21.1. KubeJS for scripting, FTB Quests for questing. The pack is a "love letter" to the owner's group but will be released publicly.
3. Core content mods: TerraFirmaCraft, Create, Create Aeronautics. No Alex's Caves; avoid kitchen-sink mod lists. No early flight or teleportation (no waystones). Magic is not a major feature.
4. Design (see the Design Pillars Claude Doc): arena-based PVP ("the Arena zone is the consent"), "A Climb You Can Finish", Keeping the Group Together, Partner Quests and Cooperative Mining, Beyond the Summit ("cooperation multiplies, never gates"), Costumes and Props, Building Support, Respecting Boundaries in PVP, friendly fire pushes but never hurts.
5. The Hearth: single player spawn and community focus; personal tech gated by individual play within each era; new eras unlocked by a Hearth upgrade; optional branches and catch-up kits; community storage at the Hearth. "One home location" stays an open question.
6. Hearth mechanism probably needs a NeoForge mod rather than KubeJS (a "TFC Custom Hearth" mod was suggested by ChatGPT). Workflow, tentative: Claude and ChatGPT specify code, the owner builds with `./gradlew build`, tests on a server, and reports back.
7. ChatGPT is a collaborator (proposals, documentation, later Java for the Hearth mod). Its sessions become part of the log. The owner relays block text between ChatGPT and TLC Claude. ChatGPT may read `STATE.md` from GitHub. Its write access is revoked until a gate exists. The Claude and ChatGPT GitHub apps were removed; the owner pushes manually.
8. `.gitignore`: remove the `./gradle/` line and trust the MDK; keep `build/`, `run/`, and the scratch-file comment.
9. Cadence: TLC and CT alternate days, except when a CT tool blocks TLC or a multi-day task is declared (note it here).

## Open items and parked

Today's scope was Live Logging only. Everything below is parked until it is verified.

- Triage of pending TLC issues (tomorrow, after the handover test).
- Mod candidates table (space and nuclear mods first; plain format editable in LibreOffice; role, suitability, loader flags, dependencies, current and stable versions) and the possible "Mod Database" in MariaDB, to be offered to CT as a general tool.
- Late-era mod review (Sable-based and Aeronautics-extending candidates; stability, longevity, open source on GitHub preferred). Nuclear era should genuinely require nuclear power.
- Layered unit-test plan (test rig branch for TFC compatibility with core mods, then a smaller branch for the Hearth jar), "Log Vomit" reporting upstream, the 1.21.1 test map, and the clean 32x resource pack. Server release vs singleplayer client vs client-only differences.
- Placement of the Hearth mod project, a cheaper test rig, network access for Claude's sandbox, and skills.
- Supplying NeoForge build code (NeoGradle) and the licence position.
- GPG signing in all repositories, raised with CT Claude.
- GitHub-side privacy check as insurance (parked with CT).
- Cleanup of TLC's `scripts/` folder, pending CT Claude.
- Moving TLC's earlier work out of old conversations and the `TheLongClimb~` backup folder into the repo, then deleting the backup.
- Remaining Design Pillars items: the fourth-respondent assumptions swapped for real answers where they differ.

## Where to look

`docs/TOOLS.md`, `docs/TONE.md`, `docs/runbooks/can-vs-should.md`, the Design Pillars and test plan documents, `log/` (full history; search by phrase, not turn number).

## HANDOFF CHECK (for this close)

- Upload to CopperToolchain project files: none
- Paste into CopperToolchain chat: none
- Commit in the CopperToolchain repo: none
- Upload to TLC project files: STATE.md (after commit)
- Commit in the TLC repo: STATE.md (project root)
