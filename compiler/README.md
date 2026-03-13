# Compiler Adapter Layer

## Purpose

Bridges the `UMG_Envoy_Resleever` runtime repo to the sibling compiler repo `..\\umg-compiler`. It documents paths, staging rules, invocation mechanics, and promotion helpers. It does **not** contain compiler source code.

## Prerequisites

1. Node.js 20 or newer.
2. Dependencies + build artifacts in the sibling repo:
   ```powershell
   npm install --prefix ..\umg-compiler\compiler-v0
   npm run build   --prefix ..\umg-compiler\compiler-v0
   ```

## Staging model

- Staging files live in `runtime/staging/` using `<sleeve-id>--<mode>--<timestamp>.json`.
- Compile outputs land in `runtime/compile-output/` using `<sleeve-id>--<mode>--<timestamp>.runtime.json`.
- Trace exports land in `runtime/traces/` with the same naming but `.trace.json` suffix.

## Invocation

- Entry: `..\umg-compiler\compiler-v0\dist\cli.js`
- Command: `node ..\umg-compiler\compiler-v0\dist\cli.js compile --in <input.json> --out <output.json> [--pretty]`
- Wrapper: `invoke-compiler.ps1`
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\compiler\invoke-compiler.ps1 \
    -InputPath   .\runtime\staging\sample-basic-minimal--dry-run--20260312-1825.json \
    -OutputPath  .\runtime\compile-output\sample-basic-minimal--dry-run--20260312-1826.runtime.json \
    -TracePath   .\runtime\traces\sample-basic-minimal--dry-run--20260312-1826.trace.json \
    -Pretty
  ```

## Promotion helper

`promote-runtime.ps1` safely updates active runtime state:
```powershell
powershell -ExecutionPolicy Bypass -File .\compiler\promote-runtime.ps1 \
  -CompiledOutputPath .\runtime\compile-output\sample-basic-minimal--promote--20260312-1900.runtime.json \
  -TracePath         .\runtime\traces\sample-basic-minimal--promote--20260312-1900.trace.json \
  -SourceSleevePath  .\sleeves\archive\sample-basic_minimal.json \
  -StagedInputPath   .\runtime\staging\sample-basic-minimal--promote--20260312-1900.json \
  -PromotionLabel    "sample-basic"
```

The script:
- Validates the compiled output structure.
- Creates a timestamped backup under `runtime/backups/` (old active files + metadata).
- Writes new `active-sleeve.json` / `active-stack.json` with promotion metadata.

## Adapter rules

- Do not copy compiler source here.
- Keep staging + invocation parameters explicit; no hidden defaults.
- Use the provided scripts so that automation and humans share the same contract.
