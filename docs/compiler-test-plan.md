# Compiler Test Plan (Stage 2)

## Goal

Provide a non-destructive procedure to verify that the Resleever adapter can invoke the sibling compiler and capture outputs without mutating live runtime state.

## Prerequisites

1. Node.js 20+ installed.
2. Dependencies installed and build artifacts present:
   ```powershell
   npm install --prefix ..\umg-compiler\compiler-v0
   npm run build --prefix ..\umg-compiler\compiler-v0
   ```
3. At least one sleeve JSON available for testing. Stage 2 uses the sample provided with the compiler repo.

## Test input

Use the upstream sample to avoid touching active sleeves:
```
..\umg-compiler\compiler-v0\samples\basic_minimal.json
```

Copying the file into a local staging area is optional; the adapter wrapper accepts the absolute path as-is.

## Command

```powershell
pwsh .\compiler\invoke-compiler.ps1 \
  -InputPath   ..\umg-compiler\compiler-v0\samples\basic_minimal.json \
  -OutputPath  .\runtime\compile-output\dry-run-basic_minimal.json \
  -TracePath   .\runtime\traces\dry-run-basic_minimal-trace.json \
  -Pretty
```

## Expected results

- Exit code 0 from the wrapper.
- `runtime/compile-output/dry-run-basic_minimal.json` exists and contains a JSON object with `runtimeSpec` and `trace`.
- `runtime/traces/dry-run-basic_minimal-trace.json` exists and mirrors the `trace` object (unless `--SkipTraceExport` was used).
- No other runtime files are modified.

## Failure modes to watch

| Symptom | Likely cause | Remedy |
| --- | --- | --- |
| Wrapper errors "entrypoint not found" | Compiler not built yet | Re-run the `npm install` + `npm run build` steps |
| Node exits with non-zero code | Invalid input JSON | Validate the sleeve JSON; ensure it parses |
| Trace export warning | Output JSON missing `trace` field | Investigate compiler output; still non-destructive |

## Success criteria

- Wrapper runs to completion with the sample input.
- Output + trace artifacts land in the expected folders.
- No active runtime state (`runtime/active-*.json`) is touched.
- Procedure can be repeated without additional cleanup.
