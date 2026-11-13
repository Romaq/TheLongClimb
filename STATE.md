# Handoff state, TLC (2026-11-12)

Purpose: let a fresh Claude conversation in The Long Climb (TLC) continue without re-reading the whole log.
Authority: the committed copy at `STATE.md` in the project root on GitHub `main` (not in `docs/`, per CT Claude). Claude supplies changes; the owner applies,
commits, pushes, and uploads the new copy to the project files. Refer to it only as `STATE.md`.

Provenance: the committed derived copy of 2026-11-12, merged on the same day with the stale copy dated 2026-11-08 (`STATE.md~`).
Items carried over from the stale copy are marked "(from 2026-11-08)"; their current status is unconfirmed unless stated.
An earlier `docs/STATE.md` may exist and should be retired.

## The project in one paragraph

TLC is a Claude.ai project paired with the public repository github.com/Romaq/TheLongClimb. It manages the
Minecraft modpack "The Long Climb": a technology chain from flintknapping to atomic power and interstellar travel,
tone "grounded with a wink" (`docs/TONE.md`). Generic tooling belongs in CopperToolchain (CT), of which TLC is a customer.

## Names and conventions

- `TLC` always means this project (The Long Climb). `TFC` always means TerraFirmaCraft for Minecraft 1.21.1 on NeoForge. `CT` means CopperToolchain ("Copper Toolchain", "The Copper Toolchain" are synonyms). Correct any ambiguity gently.
- Heading for Claude replies: `## 🤖 TLC CLAUDE · Turn N · YYYY-MM-DD`. Replies start and end with `---`. The user's turn number is authoritative; ask if unsure.
- Heading for ChatGPT turns: `TLC CHATGPT Turn N`.
- Pre-log turns were numbered 00a to 00g; Turn 1 was the push report (from 2026-11-08).
- The user's turn opens with `SOS TLC` (start) or `COS TLC` (close). `SOS` tells the CT script which project is active.
- Session titles: `<short_name> · YYYY-MM-DD · <task>`; two sessions on one day get `a` and `b`.
- The log is public. Flag personal details before anything else, offer placeholder wording, never repeat them. Private files are attached, not pasted.
- Be direct; say what was tested and what was not; keep steps small. Inventory additions: notice first, then the entry, and the owner applies it.
- Stray thoughts go in `tmp/stray.md` (git-ignored) until a proper home exists (from 2026-11-08).
- Apply the five questions in `docs/runbooks/can-vs-should.md` before adding any tool, script, service, or dependency.
- Claude's sandbox has no SSH or network and cannot fetch GitHub file pages. Anything involving the live repo, a server, or a tunnel is untested until the owner runs it.
- Scripts run on the host through system keyboard shortcuts (the editor is a sandboxed Flatpak).
- One fresh conversation per task; end each session by rewriting `STATE.md`.
- Every reply that ends a session, or produces something the other project needs, closes with a HANDOFF CHECK block (format in the project instructions).
- Design maxim to pass to CT: make mistakes hard to make, easy to catch, easy to correct. Owner's koan for CT's maxim list: "Good judgement comes from experience / Experience comes from bad judgement".

## Tools from CT

- `docs/TOOLS.md` in the project files has manifest date **2026-11-06** (hand-written stopgap; CT's GitHub `docs/TOOLS.md` on `main` is the authority and will become generated). State the date at each session start. Do not assume a tool exists if it is not listed. The manifest is known to be inaccurate about `setup-repo.sh` and `bootstrap-project.sh`; do not rely on it for either (from 2026-11-08).
- Needs go to CT as `REQUEST FOR THE COPPERTOOLCHAIN PROJECT` blocks. Copied scripts are recorded in `tools/FROM-COPPERTOOLCHAIN.md` and credited in the README.
- TLC's `.git/hooks/pre-push` is the kit's hook and stays unchanged; it runs TLC's own `scripts/privacy-check.sh`. Do nothing to TLC's `scripts/` folder until CT Claude decides.

## Live Logging (the current verification task)

- Scripts live in `~/Projects/CopperToolchain/scripts` and are maintained by CT for all projects. TLC, CT Claude and TLC ChatGPT use the same keybindings and workflow.
- Test so far: on 2026-11-12 the owner opened with `SOS TLC` (Turns 1 and 10) to test the handover. The script requires that first line; Claude disregards it.
- Header check: `🤖 CLAUDE` failed; `## 🤖 TLC CLAUDE · Turn N · date` is the expected form. Corrected in the 2026-11-12 close.
- Closed-session rule in the CT design: a session is closed if the last user turn starts with `COS <short_name>` and a Claude turn follows. The first close attempt used `COS` alone; the second used `COS TLC` correctly. Turn-number errors in the log came from hand-editing and are corrected.
- 2026-11-12, later: the owner opened a new session with `SOS TLC` (Turn 11), uploaded the committed `STATE.md` and the stale `STATE.md~`, and began merging them. Whether the handover works is proved by the script's notification and the log, which Claude cannot see.
- Next: triage pending TLC issues. The ChatGPT block waits until Live Logging is verified.

## Decisions so far

1. Repository `TheLongClimb` is public, licence 0BSD, remote style SSH, first push done 2026-11-08 with a clean privacy check.
2. Pack platform: CurseForge. NeoForge 1.21.1. KubeJS for scripting, FTB Quests for questing. The pack is a "love letter" to the owner's group but will be released publicly.
3. Core content mods: TerraFirmaCraft, Create, Create Aeronautics. No Alex's Caves; avoid kitchen-sink mod lists. No early flight or teleportation (no waystones). Magic is not a major feature.
4. Design (see the Design Pillars Claude Doc): arena-based PVP ("the Arena zone is the consent"), "A Climb You Can Finish", Keeping the Group Together, Partner Quests and Cooperative Mining, Beyond the Summit ("cooperation multiplies, never gates"), Costumes and Props, Building Support, Respecting Boundaries in PVP, friendly fire pushes but never hurts.
5. The Hearth: single player spawn and community focus; personal tech gated by individual play within each era; new eras unlocked by a Hearth upgrade; optional branches and catch-up kits; community storage at the Hearth. "One home location" stays an open question.
6. Hearth mechanism probably needs a NeoForge mod rather than KubeJS (a "TFC Custom Hearth" mod was suggested by ChatGPT). Workflow, tentative: Claude and ChatGPT specify code, the owner builds with `./gradlew build`, tests on a server, and reports back.
7. ChatGPT is a collaborator (proposals, documentation, later Java for the Hearth mod). Its sessions become part of the log. The owner relays block text between ChatGPT and TLC Claude. ChatGPT may read `STATE.md` from GitHub. Its write access is revoked until a gate exists. The Claude and ChatGPT GitHub apps were removed; the owner pushes manually.
8. `.gitignore`: remove the `./gradle/` line and trust the MDK; keep `build/`, `run/`, and the scratch-file comment.
9. Name "The Long Climb"; logo mark chosen; "TLC" lettering requested (from 2026-11-08). The repository was created with `bootstrap-project.sh`; the 0BSD `LICENSE` has the same text and copyright line as CT's.
10. Cadence: TLC and CT alternate days, except when a CT tool blocks TLC or a multi-day task is declared (note it here).

## Open items and parked

Today's scope was Live Logging only. Everything below is parked until it is verified.

- Triage of pending TLC issues (tomorrow, after the handover test).
- Mod candidates table (space and nuclear mods first; plain format editable in LibreOffice; role, suitability, loader flags, dependencies, current and stable versions). Planned files: `docs/mods/candidates.csv`, `dependencies.csv`, `README.md`. Schema agreed in principle; the owner has not approved the columns; the `role_group` list needs the Feature Groups document (from 2026-11-08). Possible tracked-items or "Mod Database" (MariaDB or SQLite with LibreOffice), to be offered to CT as a general tool.
- Late-era mod review (Sable-based and Aeronautics-extending candidates; stability, longevity, open source on GitHub preferred). Nuclear era should genuinely require nuclear power.
- Layered unit-test plan (test rig branch for TFC compatibility with core mods, then a smaller branch for the Hearth jar), "Log Vomit" reporting upstream, the 1.21.1 test map, and the clean 32x resource pack. Server release vs singleplayer client vs client-only differences.
- Placement of the Hearth mod project, a cheaper test rig, network access for Claude's sandbox, and skills.
- Supplying NeoForge build code (NeoGradle) and the licence position.
- GPG signing in all repositories, raised with CT Claude.
- GitHub-side privacy check as insurance (parked with CT).
- Cleanup of TLC's `scripts/` folder, pending CT Claude.
- Moving TLC's earlier work out of old conversations and the `TheLongClimb~` backup folder into the repo, then deleting the backup.
- Remaining Design Pillars items: the fourth-respondent assumptions swapped for real answers where they differ.

## Open (modpack), from 2026-11-08

- Space mod: Northstar Redux or Create Cosmonautics. Nuclear mod: CROWNS or Going Nuclear.
- Licensing for Via Romana, Going Nuclear and the BDCraft add-ons; whether Via Romana fits the no-teleportation rule.
- Single home spawn, catch-up kit versus personal unlocks, and Hearth requirements per era.
- Whether KubeJS is enough or a small custom mod is needed (decision 6 says probably a mod; unconfirmed).
- Logo legibility at 512 and 64 pixels is unchecked; PNG exports are still needed. Palette, fonts and menu styles are suggestions only.
- The owner is considering asking ChatGPT to create `STATE-Hearth.md` from `STATE.md` as a template, for the Hearth mod companion. Not decided; depends on where the Hearth project lives.

## Carried over from 2026-11-08: confirm status, then keep or delete

- Edit the project instructions (heading label, Turn 1 note).
- `docs/TONE.md` from the uploaded file plus a short decision record in `docs/decisions/` (CT's `STATE.md` says TONE.md was moved to TLC, so likely done).
- `sync.sh` path list (add `tools`, `STATE.md`); `tools/FROM-COPPERTOOLCHAIN.md` with source links and the CT commit hash; credit the tools in the README Tools section.
- Seed the mod candidates table with the names already stated; leave unverified fields blank.
- Declared multi-day task (2026-11-08): fix the CT script and key-binding problem; CT session 2026-11-10. Interim workaround: logs land in `CT/log`, move to `TLC/log` at the close of the day, then `git reset origin/main` (mixed, not `--hard`) in CT. Probably superseded by Live Logging; delete once that is verified.

## Where to look

`docs/TOOLS.md`, `docs/TONE.md`, `docs/runbooks/can-vs-should.md`, the Design Pillars and test plan documents, `log/` (full history; search by phrase, not turn number).

## HANDOFF CHECK (for this close)

- Upload to CopperToolchain project files: none
- Paste into CopperToolchain chat: none
- Commit in the CopperToolchain repo: none
- Upload to TLC project files: STATE.md (after commit)
- Commit in the TLC repo: STATE.md (project root)
- Note: this is a working draft; the close of the session rewrites it.
