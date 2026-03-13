# Artifact Naming and Retention (Stage 3)

## Categories & naming patterns

| Artifact | Folder | Pattern | Example |
| --- | --- | --- | --- |
| Staged compiler input | `runtime/staging/` | `<sleeve-id>--<mode>--<YYYYMMDD-HHmmss>.json` | `sample-basic-minimal--dry-run--20260312-1825.json` |
| Compiler output | `runtime/compile-output/` | `<sleeve-id>--<mode>--<YYYYMMDD-HHmmss>.runtime.json` | `sample-basic-minimal--dry-run--20260312-1826.runtime.json` |
| Trace export | `runtime/traces/` | `<sleeve-id>--<mode>--<YYYYMMDD-HHmmss>.trace.json` | `sample-basic-minimal--dry-run--20260312-1826.trace.json` |
| Promotion backup | `runtime/backups/<timestamp-label>/` | `active-sleeve.json`, `active-stack.json`, `metadata.json` | `runtime/backups/20260312-1830-sample-basic-minimal/active-sleeve.json` |
| Active runtime files | `runtime/` | `active-sleeve.json`, `active-stack.json` | (always the live copies) |

## Mode tokens

- `dry-run` – compile for inspection only.
- `promote` – compile intended for runtime promotion.

## Retention policy (Stage 3)

- **Staging files**: kept indefinitely for traceability. Manual cleanup allowed if they are not referenced by backups.
- **Compile outputs / traces**: kept indefinitely; no auto-deletion.
- **Backups**: never deleted automatically. Each promotion creates a new timestamped directory.
- **Active files**: overwritten only through `promote-runtime.ps1`, which first writes a backup.

## What must never be auto-deleted in Stage 3

- Anything under `runtime/backups/`
- The latest successful compile output & trace for any sleeve currently under review
- `active-sleeve.json` / `active-stack.json`

## Future considerations (Stage 4+)

- Add optional retention windows for staging/outputs once promotion history grows.
- Introduce manifest-driven naming (e.g., include version tokens) once sleeves carry richer metadata.
- Consider linking promotion metadata back into manifests for provenance.
