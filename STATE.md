# Handoff state, TLC (2026-11-13, end of session)

Purpose: let a fresh Claude conversation in The Long Climb (TLC) continue without re-reading the whole log.
Authority: the committed copy at `STATE.md` in the project root on GitHub `main` (not in `docs/`). Claude supplies changes; the owner applies,
commits, pushes, and uploads the new copy to the project files. Refer to it only as `STATE.md`. An earlier `docs/STATE.md` may exist and should be retired.
`STATE-ChatGPT.md` in the root is ChatGPT's supplemental state file, written by ChatGPT and applied by the owner; it does not replace this file.

## The project in one paragraph

TLC is a Claude.ai project paired with the public repository github.com/Romaq/TheLongClimb. It manages the
Minecraft modpack "The Long Climb": a technology chain from flintknapping to atomic power and interstellar travel,
tone "grounded with a wink" (`docs/TONE.md`). Generic tooling belongs in CopperToolchain (CT), of which TLC is a customer.

## Names and conventions

- `TLC` always means this project (The Long Climb). `TFC` always means TerraFirmaCraft for Minecraft 1.21.1 on NeoForge. `CT` means CopperToolchain ("Copper Toolchain", "The Copper Toolchain" are synonyms). Correct any ambiguity gently.
- In this project, "mods" is the owner's collective word for mods, resource packs, datapacks and shaders. Where the strict sense is meant, say "a NeoForge or Fabric mod". Raise ambiguity when it matters.
- Status vocabulary (owner's usage): `selected` means the pack cannot function without it. `optional` means it ships but the pack works without it. There is no `core`. Use `selected` only in that sense.
- Heading for Claude replies: `## 🤖 TLC CLAUDE · Turn N · YYYY-MM-DD`. Replies start and end with `---`. The user's turn number is authoritative; if it repeats or skips, use it as written and flag it in one line at the top.
- Heading for ChatGPT turns: `## 🤖 TLC ChatGPT · Turn N · YYYY-MM-DD`, with the same `---` framing, in a discrete segment of the TLC log files until the Hearth mod is split into its own project and repository (if ever).
- Pre-log turns were numbered 00a to 00g; Turn 1 was the push report.
- The user's turn opens with `SOS TLC` (start) or `COS TLC` (close). `SOS` tells the CT script which project is active.
- Session titles: `<short_name> · YYYY-MM-DD · <task>`; two sessions on one day get `a` and `b`.
- The log is public. Flag personal details before anything else, offer placeholder wording, never repeat them. Private files are attached, not pasted.
- Be direct; say what was tested and what was not; keep steps small. Inventory additions: notice first, then the entry, and the owner applies it.
- Stray thoughts go in `tmp/stray.md` (git-ignored, `tmp/` in both CT and TLC). A later session may gather them into a "parking document" for periodic review.
- Apply the five questions in `docs/runbooks/can-vs-should.md` before adding any tool, script, service, or dependency.
- Claude's sandbox has no SSH or network. It can fetch public web pages, including CurseForge file pages (sometimes rate-limited), but cannot write to GitHub. Anything involving the live repo, a server, or a tunnel is untested until the owner runs it.
- Scripts run on the host through system keyboard shortcuts (the editor is a sandboxed Flatpak).
- One fresh conversation per task; end each session by rewriting `STATE.md`.
- Every reply that ends a session, or produces something the other project needs, closes with a HANDOFF CHECK block (format in the project instructions).
- Owner's koan for CT's maxim list: "Good judgement comes from experience / Experience comes from bad judgement". The owner is prone to mixing up 1.20.1 and 1.21.1 filters; the mod database is meant to do that filtering.

## Tools from CT

- `docs/TOOLS.md` is parked until Live Logging is clearly stable. CT will then generate it (completed tools vs tools pending in priority order). TLC is first in line. CT's GitHub `docs/TOOLS.md` on `main` is the authority. The copy in project files had manifest date 2026-11-06; it was not visible in the 2026-11-13 session, so state the date seen at each session start. Known inaccurate about `setup-repo.sh` and `bootstrap-project.sh`.
- Needs go to CT as `REQUEST FOR THE COPPERTOOLCHAIN PROJECT` blocks. Copied scripts are recorded in `tools/FROM-COPPERTOOLCHAIN.md` and credited in the README.
- TLC's `.git/hooks/pre-push` is the kit's hook and stays unchanged; it runs TLC's own `scripts/privacy-check.sh`. Do nothing to TLC's `scripts/` folder until CT Claude decides. A version number with four dot-separated parts matches the `ipv4-address` pattern; if that trips the hook, raise it with CT.
- Project files should not hold CT's own `STATE.md` copies (two were seen, dated 2026-11-09 and 2026-11-12). The owner is removing them to avoid stale conflicts. `templates/new-project-kit/` stays, as read from CT's GitHub source.

## Live Logging

- Scripts live in `~/Projects/CopperToolchain/scripts` and are maintained by CT for all projects. TLC, CT Claude and TLC ChatGPT use the same keybindings and workflow.
- 2026-11-13: the session opened with `SOS TLC` (Turn 14) and closes with `COS TLC` (Turn 18). Turn 16 was used twice by mistake; the owner has corrected the headings by hand. Whether the script handled the open and close cleanly is shown by its notification and the log, which Claude cannot see.
- Closed-session rule: a session is closed if the last user turn starts with `COS <short_name>` and a Claude turn follows.
- The ChatGPT block waits until Live Logging is verified.

## Decisions so far

1. Repository `TheLongClimb` is public, licence 0BSD, remote style SSH, first push done 2026-11-08 with a clean privacy check.
2. Pack platform: CurseForge. NeoForge 1.21.1. KubeJS for scripting, FTB Quests for questing. The pack is a "love letter" to the owner's group but will be released publicly.
3. Core content mods: TerraFirmaCraft, Create, Create Aeronautics. No Alex's Caves; avoid kitchen-sink mod lists. No early flight or teleportation (no waystones). Magic is not a major feature.
4. Design (see the Design Pillars Claude Doc): arena-based PVP ("the Arena zone is the consent"), "A Climb You Can Finish", Keeping the Group Together, Partner Quests and Cooperative Mining, Beyond the Summit ("cooperation multiplies, never gates"), Costumes and Props, Building Support, Respecting Boundaries in PVP, friendly fire pushes but never hurts.
5. The Hearth: single player spawn and community focus; personal tech gated by individual play within each era; new eras unlocked by a Hearth upgrade; optional branches and catch-up kits; community storage at the Hearth. "One home location" stays an open question.
6. Hearth mechanism probably needs a NeoForge mod rather than KubeJS (a "TFC Custom Hearth" mod was suggested by ChatGPT). Workflow, tentative: Claude and ChatGPT specify code, the owner builds with `./gradlew build`, tests on a server, and reports back.
7. ChatGPT must be credited for its production within the project. The owner keeps full control and weighs each AI's suggestions for its own role. Reasons for ChatGPT on the Hearth mod: divide token use across two AI accounts, and learn the strengths and weaknesses of Claude.ai versus ChatGPT. Open: whether ChatGPT should write and test the actual `Hearth.jar` (placeholder name), and whether it should have its own project. Its sessions become part of the log; the owner relays block text. ChatGPT may read `STATE.md` from GitHub. Its write access is revoked; the Claude and ChatGPT GitHub apps were removed; the owner pushes manually.
8. `.gitignore`: remove the `./gradle/` line and trust the MDK; keep `build/`, `run/`, and the scratch-file comment.
9. Name "The Long Climb"; logo mark chosen; "TLC" lettering requested. The repository was created with `bootstrap-project.sh`; the 0BSD `LICENSE` has the same text and copyright line as CT's.
10. Cadence: TLC and CT alternate days, except when a CT tool blocks TLC or a multi-day task is declared (note it here).
11. Mod database (2026-11-13), in `docs/mods/`, record `docs/decisions/2026-11-13-mod-database-schema.md`: one flat table `mods.csv`; permanent slug as the key; dependencies stored once, forward only, `;`-separated; `loader` says what runs the element (neoforge, fabric, datapack, resourcepack, shaderpack, modpack, unknown); Fabric elements are tracked through a `sinytra` result and stay out of `selected` and `optional` until it is `works`; `memory_impact` and `cpu_impact` (0 to 5, blank means not measured, bands provisional until profiled; CPU is a share of the 50 ms tick or 16.7 ms frame budget); `licenses.csv` with a `flag` of ok, review or danger. The 1 to 5 priority, Order and file size fields were dropped. The CSV format reads fine in LibreOffice; revisit only if the tables become too cumbersome for decisions.
12. Spark is `selected` and ships on client and server as the standby diagnostic tool for players and ops. Non-op players get only `spark.health` (covers `/spark health`, `/spark tps`, `/spark ping`) through FTB Ranks or LuckPerms; profiler, heap and activity commands stay admin-only. Minecraft's own profiler is dropped. `lightning-profiler` is kept as `reference` in case Spark proves insufficient for per-mod decisions.

## Mod database: where it stands

- Built and committed: `README.md` (fields, vocabularies, scales), `mods.csv` (17 sample rows holding only what the owner stated or what a source page showed), `licenses.csv` (9 starter rows, first-pass pointers, not legal advice).
- The owner starts filling `mods.csv` next session, with scratch ideas as minimum rows (`slug`, `common_name`, `loader`, `group`, `status`; use `status=candidate`, `group=unsorted`). Claude then organizes them into `docs/roadmap.md`, and a "next topic" threshold there drives changes to `STATE.md`.
- Research flags recorded in the rows: Streams Reflowing is All Rights Reserved (no modifying or re-hosting; check modpack inclusion is allowed; builds every few days, pin only after testing); Spark 1.21.1 NeoForge latest release seen is 1.10.124; FTB Ranks 1.21.1 NeoForge release 2101.1.3; LuckPerms has only alpha-labelled NeoForge 1.21.1 files (5.4.140, Aug 2024), with newer releases for newer Minecraft versions only; Homestead has no licensing issue on the client per the owner, its server pack is a Google Drive download, and it is also on Modrinth (terms not understood).
- The owner plans to review licensing across the current mod list. Questions can be asked at any time.
- Untested: whether Spark honors FTB Ranks or LuckPerms nodes; anything about real packs; memory and CPU bands.

## Open items and parked

- Triage of pending TLC issues (after Live Logging is verified).
- Late-era mod review (Sable-based and Aeronautics-extending candidates; stability, longevity, open source on GitHub preferred). Nuclear era should genuinely require nuclear power.
- Layered unit-test plan (test rig branch for TFC compatibility with core mods, then a smaller branch for the Hearth jar), "Log Vomit" reporting upstream, the 1.21.1 test map, and the clean 32x resource pack. Server release vs singleplayer client vs client-only differences, including the `.disabled` question.
- A script to check slugs, duplicate links and dependency references: wait until the table has real rows.
- Modrinth-only distribution question (Homestead is the reference case).
- Placement of the Hearth mod project, a cheaper test rig, network access for Claude's sandbox, and skills.
- Supplying NeoForge build code (NeoGradle) and the licence position.
- GPG signing in all repositories, raised with CT Claude.
- GitHub-side privacy check as insurance (parked with CT).
- Cleanup of TLC's `scripts/` folder, pending CT Claude.
- Generic tracked-items tool and a stray-thoughts parking lot, possibly for CT.
- `STATE-Hearth.md`: ChatGPT now keeps `STATE-ChatGPT.md` instead; decide whether a Hearth-only file is still wanted.
- Moving TLC's earlier work out of old conversations and the `TheLongClimb~` backup folder into the repo, then deleting the backup.
- Remaining Design Pillars items: the fourth-respondent assumptions swapped for real answers where they differ.

## Open (modpack)

- Space mod: Northstar Redux or Create Cosmonautics. Nuclear mod: CROWNS or Going Nuclear. Licensing for Going Nuclear and the BDCraft add-ons.
- Via Romana: after testing the owner leans toward Roads and Roofs TFC plus Block Runner (a soft dependency of Roads and Roofs TFC) instead; a Create rail line may serve transport better. Owner's testing, not verified by Claude.
- Streams Reflowing: judged very important for TFC 1.21.1 terrain; discuss in a world generation session, with its license in mind.
- Single home spawn, catch-up kit versus personal unlocks, and Hearth requirements per era.
- Whether KubeJS is enough or a small custom mod is needed (decision 6 says probably a mod; unconfirmed).
- Logo legibility at 512 and 64 pixels is unchecked; PNG exports are still needed. Palette, fonts and menu styles are suggestions only.

## Carried over from 2026-11-08: confirm status, then keep or delete

- Edit the project instructions (heading label, ChatGPT participant, Turn 1 note).
- `docs/TONE.md` and its decision record (likely done; confirm).
- `sync.sh` path list (add `tools`, `STATE.md`); `tools/FROM-COPPERTOOLCHAIN.md` with source links and the CT commit hash; credit the tools in the README Tools section.
- The interim workaround for logs landing in `CT/log` is probably superseded by Live Logging; delete once that is verified.

## Next session

Open with `SOS TLC` and state your turn number. Start by filling `mods.csv`, then licensing questions as they arise. Check the `docs/TOOLS.md` date and the Live Logging result first.

## Where to look

`docs/mods/README.md`, `docs/mods/mods.csv`, `docs/mods/licenses.csv`, `docs/decisions/`, `docs/TOOLS.md`, `docs/TONE.md`, `docs/runbooks/can-vs-should.md`, the Design Pillars and test plan documents, `STATE-ChatGPT.md`, `log/` (full history; search by phrase, not turn number).
