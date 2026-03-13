# Path Contract

## Purpose

This document defines the canonical local path relationships for the UMG/OpenClaw environment. These paths are the Stage 1 contract for the sibling homebase + compiler layout.

## Absolute paths

| Label | Path |
| --- | --- |
| Workspace root | `C:\Users\Tammie\.openclaw\workspace\skills` |
| Resleever root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever` |
| Compiler root | `C:\Users\Tammie\.openclaw\workspace\skills\umg-compiler` |
| Compiler adapter root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\compiler` |
| Sleeves root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\sleeves` |
| Blocks root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\blocks` |
| Runtime root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\runtime` |
| Compile output root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\runtime\compile-output` |
| Traces root | `C:\Users\Tammie\.openclaw\workspace\skills\UMG_Envoy_Resleever\runtime\traces` |

## Relative relationships

- From the Resleever root, the compiler root is `..\umg-compiler`.
- From the compiler adapter root, the compiler root is `..\..\umg-compiler`.

## Folder intent (Resleever repo)

- `sleeves/active/` — active sleeve assets
- `sleeves/archive/` — archived sleeve assets
- `sleeves/manifests/` — manifests and indexes
- `blocks/molt/`, `blocks/neoblocks/`, `blocks/neostacks/`, `blocks/manifests/` — block storage and metadata
- `runtime/active-sleeve.json`, `runtime/active-stack.json` — selectors for current state
- `runtime/compile-output/` — compiler artifacts written back from the sibling compiler
- `runtime/traces/` — compiler trace artifacts

## Stage 1 note

This path contract establishes locations only. Stage 1 does **not** finalize the compiler entrypoint or wrapper command. Stage 5 will define the actual invocation contract once the adapter layer inspects the sibling compiler in detail.
