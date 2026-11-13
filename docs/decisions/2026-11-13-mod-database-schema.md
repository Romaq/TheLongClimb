# Decision: mod database schema

Date: 2026-11-13. Status: accepted by the owner (Turns 14 and 15). Files: `docs/mods/`.

## Decision

- One flat table, `docs/mods/mods.csv`, one row per element. "Mods" is the collective word for mods, resource packs, datapacks, shaders, and reference modpacks.
- The key is a permanent slug, assigned once and never derived, changed, or reused.
- Dependencies are stored once, forward only (`requires`, `soft_requires`). Reverse lookups are made by filtering.
- `loader` names what runs the element (`neoforge`, `fabric`, `datapack`, `resourcepack`, `shaderpack`, `modpack`, `unknown`). Fabric elements are tracked through a `sinytra` result.
- `status` replaces the old 1 to 5 importance and the sort order. Both are dropped.
- `memory_impact` (0 to 5, blank when unmeasured) replaces file size as the cost measure. Its MB bands are provisional until profiled.
- A `licenses.csv` table holds short IDs with what each means for TLC.

## Rejected

- A hash of "stable" fields as the key: it changes when a field is corrected, which breaks every reference.
- Two Boolean fields for server and client: they allow an impossible "neither".
- A stored sort order or combined sort key: it goes stale whenever a row is inserted or a group changes.
- Storing dependencies in both directions: the old table drifted, with seven references matching no row.

## Open

- Whether processing cost (frame or tick time) needs its own field.
- Recalibrating the memory bands after the first profiling round.
- The Modrinth-only distribution question.
- A script to check slugs and dependency references. Wait until the table has real rows.
