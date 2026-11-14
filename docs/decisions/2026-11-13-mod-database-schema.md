# Decision: mod database schema

Date: 2026-11-13. Status: accepted by the owner (Turns 14 and 15). Files: `docs/mods/`.

## Decision

- One flat table, `docs/mods/mods.csv`, one row per element. "Mods" is the collective word for mods, resource packs, datapacks, shaders, and reference modpacks.
- The key is a permanent slug, assigned once and never derived, changed, or reused.
- Dependencies are stored once, forward only (`requires`, `soft_requires`). Reverse lookups are made by filtering.
- `loader` names what runs the element (`neoforge`, `fabric`, `datapack`, `resourcepack`, `shaderpack`, `modpack`, `unknown`). Fabric elements are tracked through a `sinytra` result.
- `status` replaces the old 1 to 5 importance and the sort order. Both are dropped. In `status`, `selected` means the pack cannot function without the element, and `optional` means it ships but the pack works without it. There is no `core` value.
- `memory_impact` and `cpu_impact` (0 to 5, blank when unmeasured) replace file size as the cost measures. Their bands are provisional until profiled. CPU is a share of the tick or frame budget, so one scale covers server and client.
- A `licenses.csv` table holds short IDs with what each means for TLC.

## Rejected

- A hash of "stable" fields as the key: it changes when a field is corrected, which breaks every reference.
- Two Boolean fields for server and client: they allow an impossible "neither".
- A stored sort order or combined sort key: it goes stale whenever a row is inserted or a group changes.
- Storing dependencies in both directions: the old table drifted, with seven references matching no row.

## Open

- Recalibrating the memory and CPU bands after the first profiling round.
- The Modrinth-only distribution question.
- A script to check slugs and dependency references. Wait until the table has real rows.
