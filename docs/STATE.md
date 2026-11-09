# STATE: The Long Climb (TLC)

Updated: 2026-11-08, end of Turn 2 (session closed).
TOOLS.md manifest date: 2026-11-06. Known to be inaccurate about setup-repo.sh and bootstrap-project.sh; do not rely on it for either.

## Project
Minecraft Java 1.21.1 modpack, flintknapping to atomic power and interstellar travel.
Tone: grounded with a wink (see docs/TONE.md once committed). Public repo: github.com/Romaq/TheLongClimb. Release target: CurseForge.

## Settled
- Name "The Long Climb"; logo mark chosen; "TLC" lettering requested.
- Design pillars, player archetypes, Hearth mechanic, Arena PVP with consent.
- No early flight, teleportation or waystones; magic stays minor.
- KubeJS for scripting, FTB Quests for questing.
- Repo created with bootstrap-project.sh, 0BSD LICENSE (same text and copyright line as CT), first push done over SSH.
- Reply headings: "## 🤖 TLC CLAUDE"; pre-log turns were 00a to 00g, Turn 1 = push report.

## Declared multi-day task
- Fix the CT script/key-binding problem. Started 2026-11-08; CT session Tue 2026-11-10; TLC resumes Wed 2026-11-11 if it runs over, otherwise after the CT work.
- Until fixed: logs land in CT/log; move to TLC/log at close of day, then `git reset origin/main` (mixed, not --hard) in CT.

## Parked (not started)
- Mod candidates table: docs/mods/candidates.csv, dependencies.csv, README.md (schema agreed in principle; the owner has not yet approved the columns; role_group list needs the Feature Groups doc).
- Possible tracked-items database (MariaDB or SQLite with LibreOffice); discuss after setup; passed to CT.
- A proper home for stray thoughts (tmp/stray.md for now, git-ignored).
- GPG signing across repos (passed to CT).

## Next TLC steps
1. Insert STATE.md, commit with the log; upload STATE.md to project files; attach the repo as file context.
2. Edit the project instructions (heading label, Turn 1 note).
3. Create docs/TONE.md from the uploaded file plus a short decision record in docs/decisions/.
4. Edit sync.sh path list (add tools, STATE.md); create tools/FROM-COPPERTOOLCHAIN.md with source links and the CT commit hash; credit the tools in the README Tools section.
5. Seed the mod candidates table with the names already stated; leave unverified fields blank.

## Open (modpack)
- Space mod: Northstar Redux or Create Cosmonautics. Nuclear mod: CROWNS or Going Nuclear.
- Licensing for Via Romana, Going Nuclear and the BDCraft add-ons; whether Via Romana fits the no-teleportation rule.
- Single home spawn, catch-up kit vs personal unlocks, Hearth requirements per era.
- Whether KubeJS is enough or a small custom mod is needed.
- Logo legibility at 512 and 64 pixels is unchecked; PNG exports still needed.
- Palette, fonts and menu styles are suggestions only.
