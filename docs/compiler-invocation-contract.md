# Compiler Invocation Contract (Stage 2)

## Overview

`UMG_Envoy_Resleever` invokes the sibling `umg-compiler` repository via the Node CLI that lives at `..\umg-compiler\compiler-v0\dist\cli.js`. The adapter layer provides a wrapper (`compiler/invoke-compiler.ps1`) so the homebase can call the compiler with explicit parameters.

## Inputs

| Item | Description | Source |
| --- | --- | --- |
| Sleeve bundle JSON | Canonical sleeve definition or `{ sleeve, triggerState }` object | Typically produced inside `sleeves/` or a staging file in `runtime/` |
| Trigger state (optional) | Initial trigger state injected via the JSON bundle | Embedded inside the same input JSON |
| Output path | Target file for the compiler result | Defaults to `runtime/compile-output/dry-run-<timestamp>.json` if not specified |
| Trace path | Target file for the extracted trace | Defaults to `runtime/traces/dry-run-<timestamp>-trace.json` if not specified |
| Pretty flag | Optional formatting toggle for easier inspection | `-Pretty` switch in the wrapper |

## Invocation command

- Raw CLI: `node ..\umg-compiler\compiler-v0\dist\cli.js compile --in <input.json> --out <output.json> [--pretty]`
- Preferred wrapper: `pwsh .\compiler\invoke-compiler.ps1 -InputPath <input.json> [-OutputPath <...>] [-TracePath <...>] [-Pretty] [-SkipTraceExport]`
- Node version: `>= 20`
- Build prerequisite: `npm install --prefix ..\umg-compiler\compiler-v0` and `npm run build --prefix ..\umg-compiler\compiler-v0`

## Outputs

The CLI emits a JSON object containing at least:

- `runtimeSpec` — deterministic runtime specification
- `trace` — full trace of compiler decisions

Stage 2 expectations:

- The full CLI output is written to `runtime/compile-output/<file>.json`.
- The wrapper optionally mirrors the `trace` object into `runtime/traces/<file>.json` for easier diffing/auditing.

## Paths

| Purpose | Path |
| --- | --- |
| Workspace root | `C:\Users\Tammie\.openclaw\workspace\skills` |
| Resleever root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever` |
| Compiler root | `C:\Users\Tammie\.openclaw\workspace\skills\umg-compiler` |
| Wrapper script | `UMG_Envoy_Resleever\compiler\invoke-compiler.ps1` |
| Default compile output | `UMG_Envoy_Resleever\runtime\compile-output\dry-run-<timestamp>.json` |
| Default trace output | `UMG_Envoy_Resleever\runtime\traces\dry-run-<timestamp>-trace.json` |

## Contract guarantees (Stage 2)

- Compiler source is not copied into the homebase repo.
- All invocations flow through the documented Node CLI or the wrapper.
- Inputs and outputs live entirely within the Resleever workspace.
- Trace exports are optional and performed only after successful compile.

## Outstanding items for later stages

- Automated selection of which sleeve JSON should be compiled.
- Consistent naming/versioning for outputs beyond the dry-run defaults.
- Trigger-state management policies.
- Promotion of compiled results into active runtime state.
