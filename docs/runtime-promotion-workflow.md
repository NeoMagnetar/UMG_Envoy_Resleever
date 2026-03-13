# Runtime Promotion Workflow (Stage 3)

## Overview

Promotion converts a verified compiler output into the authoritative runtime state by updating `runtime/active-sleeve.json` and `runtime/active-stack.json` after backing up the previous state.

## Modes

### Dry-run mode
- Prepare sleeve input → stage file in `runtime/staging/`.
- Invoke compiler via `compiler/invoke-compiler.ps1` with `mode=dry-run` naming.
- Inspect `runtime/compile-output/` + `runtime/traces/` artifacts.
- No changes to active runtime files.

### Promotion mode
1. Prepare sleeve input with `mode=promote` (still staged first).
2. Compile via the same CLI (output/trace files use `--promote--` naming).
3. Review artifacts.
4. Run `compiler/promote-runtime.ps1 -CompiledOutputPath <...runtime.json> [-TracePath ...] [-SourceSleevePath ...] [-PromotionLabel ...]`.

## Promotion steps

1. **Verify source artifacts** – ensure compiled output JSON exists and contains `runtime` + `trace` sections.
2. **Capture context** – sleeve ID, name, mode, original sleeve path, staged input path.
3. **Backup active state** – copy `runtime/active-sleeve.json` and `runtime/active-stack.json` (if they exist) into `runtime/backups/<timestamp>-<label>/` along with a `metadata.json` summary.
4. **Write new active files** – update `active-sleeve.json` with metadata + pointers (compile output path, trace path, source sleeve path). Update `active-stack.json` with the compiled runtime stacks/neoBlocks summary.
5. **Result logging** – wrapper echoes backup path + new active paths.

## Failure handling

- Missing compiled output → abort before touching active files.
- JSON missing `runtime.runtimeSpec` equivalents → abort.
- Backup failure → abort before writing new active files.
- Partial promotion (e.g., sleeve file written but stack not) → script attempts to roll back using the freshly created backup and surfaces the error for manual review.

## Rollback (Stage 3 manual)

- Use the latest folder under `runtime/backups/` to restore `active-sleeve.json` and `active-stack.json` manually if needed.
- Stage 4+ may automate rollback, but for now every promotion ensures a restorable snapshot exists.

## Metadata recorded in `active-sleeve.json`

- `active` flag
- sleeve id/name/version (if provided)
- source sleeve path
- staged input path
- compile output path
- trace path
- promotion label + timestamp
- previous backup folder reference

## Out-of-scope (Stage 3)

- Automatic block mutation or stack reordering
- Multi-agent or concurrent promotion queues
- Enforcement of governance beyond backup + active state updates
