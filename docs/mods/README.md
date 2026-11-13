# Mod database

One table of everything that might go into, or inform, the pack. In this project, "mods" is the collective word for all of it: mods, resource packs, datapacks, shaders, and reference modpacks. The `loader` field says which kind a row is. Where "mod" must mean the strict sense, the text says "a NeoForge or Fabric mod".

Files:

- `mods.csv`: the table, one row per element.
- `licenses.csv`: one row per license short ID used in `mods.csv`, with what it means for TLC.
- `notes/<slug>.md`: optional long notes for one element (how it was measured, why it was rejected, upstream reports). If the file exists, it is authoritative over the short `notes` field. Create it only when a row needs it.

## Rules for the CSV

- UTF-8, comma-separated, LF line endings, header row first.
- No formulas, no spreadsheet text-prefix apostrophes, no comments.
- Lists inside a field (`requires`, `soft_requires`, `competes_with`) use `;` between slugs, so they never need quoting.
- Blank means "not known yet" unless a field says otherwise. A scratch idea needs only the five required fields.
- Never put credentials, personal details, or addresses in any field. This repository is public.
- Sort and view in the spreadsheet (group, then `common_name`). Do not store a sort order or a combined key in the CSV.

## The slug

The slug is the permanent ID of an element. Lowercase letters, digits, and single hyphens only (`streams-reflowing`). Set once and never changed or reused.

- Renaming an element changes `common_name`, never the slug.
- A rejected element keeps its row, so it is not evaluated twice.
- One element has one slug, whichever platform, loader build, or site it comes from. Chunky for NeoForge and Chunky for Fabric are the same element.
- Duplicates are caught by checking that `slug`, `modlink`, and `jar_file` are each unique when filled.

## Fields

Required: `slug`, `common_name`, `loader`, `group`, `status`.

| Field | Meaning |
|---|---|
| `slug` | Permanent ID, see above. |
| `common_name` | What players call it. |
| `loader` | What runs this element: `neoforge`, `fabric`, `datapack`, `resourcepack`, `shaderpack`, `modpack` (a reference pack), or `unknown`. Add a value here first if a new kind of element appears. |
| `group` | One value from the group list below. |
| `status` | One value from the status list below. |
| `purpose` | One line. |
| `list_name` | Exact title on its download page, when it differs from `common_name`. |
| `jar_file` | Exact filename of the pinned version. Filled when pinned. |
| `side` | `both`, `server`, or `client`. `client` means it never ships in the server pack. Blank means not yet known. |
| `mc_version` | Minecraft version of the pinned file. |
| `version_pinned` | The version known to work with the proposed release. Known-bad versions go in the element's notes file. |
| `source` | `curseforge`, `external`, `internal`, or `modrinth-only`. `internal` means this project makes it, and `modlink` stays blank. |
| `modlink` | URL of the element's page. |
| `license` | A `short_id` from `licenses.csv`. |
| `sinytra` | Only for `loader=fabric`: `untested`, `works`, or `fails`. Blank for everything else. A failure is reported upstream, with the report recorded in the notes file. |
| `memory_impact` | 0 to 5, see below. Blank means not measured, which is different from 0. |
| `requires` | Hard dependencies: slugs. |
| `soft_requires` | Optional dependencies: slugs. |
| `competes_with` | Slugs of rivals when only one will ship (both rows stay `evaluating`). |
| `notes` | Short text. |

"Required by" is not stored. Filter `requires` for the slug to see it. Every slug named in `requires`, `soft_requires`, or `competes_with` must exist as a row, even if the row is only a stub.

## Loader and Fabric elements

NeoForge is the target. A Fabric element is a candidate only through Sinytra Connector. A Fabric row stays out of `selected` and `core` until `sinytra` is `works`. Forge-only elements are unlikely and are recorded with `loader=unknown` and a note until a value is agreed. A Fabric element that fails under the connector is a finding to report upstream, and the row becomes `blocked` with the report noted.

## Status

| Value | Meaning |
|---|---|
| `candidate` | Named but not yet evaluated. |
| `evaluating` | Under test, or one side of a head-to-head. |
| `selected` | Chosen for the pack, but the pack works without it. |
| `core` | Required. The pack does not work without it. |
| `blocked` | Wanted but cannot ship yet: no NeoForge build, a failed Sinytra test, a license problem, or unsupported. The reason and next step go in the notes. |
| `reference` | Studied for ideas, not shipped. |
| `rejected` | Decided against. The row stays. |

## Groups

`worldgen`, `structures`, `transport`, `user-interface`, `maps`, `tuning-debug`, `server-admin`, `storage`, `decoration`, `fauna`, `quality-of-life`, `visuals`, `tech`, `compat`, `library`, `unsorted`.

Add a group only when a real element will not fit an existing one. Use `unsorted` for scratch ideas until they are placed.

## Memory impact

The question this field answers: how much running memory does this element occupy, and for how long? It is a decision aid. Combined with `status`, it shows which nice-to-have elements are not worth their cost.

| Value | Meaning | Provisional size above baseline |
|---|---|---|
| 0 | Occupies nothing once it has done its job | none retained |
| 1 | Negligible | under about 10 MB |
| 2 | Small | about 10 to 50 MB |
| 3 | Noticeable | about 50 to 150 MB |
| 4 | Large | about 150 to 400 MB |
| 5 | Major factor at all times | over about 400 MB, or growing with play time |

The MB figures are placeholders chosen so each step is roughly three times the last. They are not measurements. Recalibrate them after the first round of profiling, and record the change in the decision records.

How to measure when testing starts: run the pack's baseline and the baseline plus the element in the same world with the same settle time, and compare memory after a garbage collection. Record the tool, the pack version, the side (client or server), and the result in `notes/<slug>.md`. Client and server memory differ, so say which one the number describes.

This field does not measure processing cost (frame time or server tick time). Add a separate field if that turns out to matter.

## Licenses

`licenses.csv` is a first-pass guide to what each license means for modifying an element to suit TLC. It is not legal advice. Read the actual license text on the element's page and add a row for any license not listed. The `flag` column is `ok`, `review`, or `danger`. Use `danger` for anything that forbids modification or redistribution, or that has not been read.

## What has and has not been tested

- Checked by script: the CSV files parse, every row has the same number of fields, slugs are unique and well formed, every value of `loader`, `group`, `status`, `side`, `source`, and `license` is in its list, and every slug named in a dependency field exists.
- Not tested: opening the files in LibreOffice Calc, and the privacy check against these exact files.
- The sample rows hold only what the owner stated or what a source page showed. Nothing is pinned, measured, or verified against a real pack.
