# Sleeve Selection Workflow (Stage 3)

## Sources of truth

1. **Manifests (`sleeves/manifests/`)** – e.g., `catalog.json` lists known sleeves with `id`, `name`, `status`, and relative `source_path`.
2. **Archive (`sleeves/archive/`)** – long-term sleeve storage; any file here can be referenced directly by path.
3. **Active (`sleeves/active/`)** – reserved for sleeves that have already been promoted. Currently empty; promotion will populate it later.

## Selection modes

| Mode | When to use | Input | Result |
| --- | --- | --- | --- |
| Manifest ID | Normal case | `sample-basic-minimal` | Resolves to manifest entry and underlying source path |
| Direct file | Ad-hoc testing | Relative or absolute JSON path | Uses the specified file as-is |
| Active alias | Runtime inspection | `active` keyword | Points at whichever sleeve is currently active (read-only) |

## Priority

1. If a manifest ID is supplied, the manifest entry wins. If multiple entries share an ID, selection fails until manifest is corrected.
2. If a file path is supplied, the file is used directly and manifest metadata is optional.
3. The `active` alias is read-only and cannot be compiled/promoed until a new sleeve is chosen; attempting to recompile the currently active sleeve will force the user to stage it explicitly.

## Minimum metadata before compilation

A sleeve must provide at least:

- `sleeve.id`
- `sleeve.name`
- `sleeve.blocks` array

Optional but recommended:

- `sleeve.version`
- `triggerState` (defaults to `{ "activeTriggerIds": [] }` if omitted)

If any required field is missing, the selection workflow marks the sleeve as invalid and refuses to prepare compile input.

## Distinguishing intents

- **Dry-run target** – `mode=dry-run`. Sleeve is compiled into `runtime/staging/` and `runtime/compile-output/` but nothing is promoted.
- **Promotion candidate** – `mode=promote`. Sleeve must either come from a manifest or provide explicit metadata. Successful compile output can be fed into `promote-runtime.ps1`.
- **Currently active** – referenced via `runtime/active-sleeve.json`. Only maintained by promotion workflow; never compiled automatically.

## Invalid/unclear selections

- Manifest entry missing `source_path` → selection fails with an explicit error.
- File path that does not exist → selection fails.
- Sleeve JSON lacking `sleeve.id` or `sleeve.blocks` → selection fails.
- Attempting to promote without first running a successful compile output → fail and prompt to run dry-run.

## Edge cases still unresolved (Stage 3)

- Multiple candidate sleeves queued simultaneously (out of scope until Stage 4 scheduling work).
- Auto-selecting based on latest archive timestamp (manual for now).
- Handling manifests that reference remote sleeves (not supported yet).
