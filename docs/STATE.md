# STATE: The Long Climb (TLC)

Updated: 2026-11-10, end of Turn 8 (session TLC 2026-11-10a closed).
TOOLS.md manifest date: 2026-11-09. Authority for CT tools: docs/TOOLS.md in the CopperToolchain repo on GitHub.

## Glossary
- **TLC**: this project, The Long Climb. Also names this Claude.ai project and its log headings (TLC CLAUDE, TLC CHATGPT).
- **TFC**: TerraFirmaCraft for Minecraft 1.21.1 on NeoForge, always, in this project.
- **CT**: the CopperToolchain project and repository (tools, scripts, process).
- **SOS / COS**: start and close of a logged session, as used by the Live Logging scripts.
- **Hearth**: the pack's Hearth mechanic; "TFC Custom Hearth" is the proposed NeoForge mod that implements it.
Acronyms are easy to confuse. If one looks wrong in context, say so.

## Project
Minecraft Java 1.21.1 modpack, flintknapping to atomic power and interstellar travel.
Tone: grounded with a wink (see docs/TONE.md once committed). Public repo: github.com/Romaq/TheLongClimb. Release target: CurseForge.

## Settled
- Name "The Long Climb"; logo mark chosen; "TLC" lettering requested.
- Design pillars, player archetypes, Hearth mechanic, Arena PVP with consent.
- No early flight, teleportation or waystones; magic stays minor.
- KubeJS for scripting, FTB Quests for questing.
- The Hearth is a custom NeoForge mod (TFC Custom Hearth), not KubeJS. A decision record in docs/decisions/ is still to be written.
- Repo created with bootstrap-project.sh, 0BSD LICENSE (same text and copyright line as CT), first push done over SSH.
- Reply headings: "## 🤖 TLC CLAUDE"; ChatGPT turns use "TLC CHATGPT Turn N". Pre-log turns were 00a to 00g, Turn 1 = push report. Turn 3 was the first post of session 2026-11-10a.

## Working arrangements (agreed 2026-11-10a)
- Participants: the owner (final authority), TLC Claude (technical research and implementation), TLC ChatGPT (design integrity and coordination). All Hearth work stays in this repo, reusing docs/decisions/ (ChatGPT's proposal, not contested).
- STATE.md authority is docs/STATE.md on GitHub main. The owner pushes every change and uploads the file to Claude.
- No AI has GitHub write access. The Claude and ChatGPT GitHub app connections are removed. The owner is the only writer and pushes through the local repo.
- Neither AI can compile or run the mod. Code is untested until the owner builds locally and reports masked output.
- TLC's .git/hooks/pre-push is the kit's hook, unchanged. It runs TLC's own scripts/privacy-check.sh, so that script and its pattern files stay until CT decides otherwise.

## Declared multi-day task
- Live Logging across CT Claude, TLC Claude and TLC ChatGPT, with the owner's keybindings unchanged. Blocks sent to CT Claude: attribution of ChatGPT turns, same-day reopen behavior, privacy gate and tests, plus the koan.
- Session 2026-11-10b, "log-turn rewrite", is later today. The owner will paste the live log-turn.sh and sync.sh so TLC Claude can confirm its understanding.
- The interim rule from 2026-11-08 (logs land in CT/log, move to TLC/log at close, then `git reset origin/main`, mixed not --hard, in CT) applies only if logs still land in CT/log. Owner to confirm.

## Parked (not started)
- GitHub-side privacy check as insurance (CT, at an appropriate stage).
- Cleanup of TLC's scripts/ folder, after Live Logging is settled and CT has decided.
- tools/FROM-COPPERTOOLCHAIN.md: one record file, drafted by Claude, with CT commit hashes supplied by the owner. Needs the sync.sh path list edit too.
- Hearth mod project: placement in the repo, build from the NeoForge MDK (Java 21, ./gradlew build run from the project's own folder), test branches (TFC compatibility with core mods, then a minimal Hearth test set), the cheaper test rig (gameTestServer or junit, unverified), network access for Claude's sandbox, relevant skills.
- Server release vs singleplayer client vs client-only release.
- Mod candidates table: docs/mods/candidates.csv, dependencies.csv, README.md (schema agreed in principle; columns not yet approved; role_group list needs the Feature Groups doc).
- Possible tracked-items database (MariaDB or SQLite with LibreOffice); passed to CT.
- A proper home for stray thoughts (tmp/stray.md for now, git-ignored).
- GPG signing across repos (passed to CT).

## Next TLC steps
1. Commit this file as docs/STATE.md and upload it to the project files.
2. Session 2026-11-10b: confirm the live log-turn.sh and sync.sh from the pasted copies.
3. Edit the project instructions (heading label, ChatGPT participant, Turn 1 note).
4. Create docs/TONE.md from the uploaded file, plus decision records in docs/decisions/ (Hearth as a NeoForge mod, ChatGPT's role, no-AI-write-access).
5. Before any Hearth code: verify TFC's 1.21.1 NeoForge release, its licence and how a mod depends on it.
6. Seed the mod candidates table with the names already stated; leave unverified fields blank.

## Open (modpack)
- Space mod: Northstar Redux or Create Cosmonautics. Nuclear mod: CROWNS or Going Nuclear.
- Licensing for Via Romana, Going Nuclear and the BDCraft add-ons; whether Via Romana fits the no-teleportation rule.
- Single home spawn, catch-up kit vs personal unlocks, Hearth requirements per era.
- Logo legibility at 512 and 64 pixels is unchecked; PNG exports still needed.
- Palette, fonts and menu styles are suggestions only.
