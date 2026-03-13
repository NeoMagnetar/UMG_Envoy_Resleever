# Compile Input Preparation (Stage 3)

## Goal

Transform a selected sleeve into a deterministic compiler input artifact before calling the Node CLI.

## Staging location

- Directory: `runtime/staging/`
- File pattern: `<sleeve-id>--<mode>--<YYYYMMDD-HHmmss>.json`
- Examples:
  - `sample-basic-minimal--dry-run--20260312-1825.json`
  - `support-v1--promote--20260312-1900.json`

## JSON shape

Each staged file contains:

```jsonc
{
  "sleeve": { /* normalized sleeve object from source */ },
  "triggerState": { /* optional, defaults to {} */ },
  "metadata": {
    "source_path": "..\\sleeves\\archive\\sample-basic_minimal.json",
    "sleeve_id": "sample-basic-minimal",
    "mode": "dry-run" | "promote",
    "prepared_at": "2026-03-12T18:25:00-06:00"
  }
}
```

Notes:
- If the source JSON already contains `sleeve` + `triggerState`, they are copied directly.
- If the source JSON is only the sleeve object, prepare step wraps it and injects `triggerState: {}`.
- Additional metadata (stack IDs, tags, etc.) remains inside `sleeve`.

## Validation before staging

1. Ensure the source file exists and parses as JSON.
2. Ensure `sleeve.id` and `sleeve.blocks` exist.
3. If `triggerState` is missing, set it to `{ "activeTriggerIds": [] }`.
4. Stamp metadata with absolute source path, mode, and timestamp.

## Relationship to compiler

- The staged file becomes the `--in` argument for `invoke-compiler.ps1`.
- The metadata block is ignored by the compiler but retained for auditing and promotion metadata.

## Cleanup

- Stage 3 keeps staging files for traceability; no auto-cleanup yet.
- Later stages may add retention/GC rules once promotion workflows mature.
