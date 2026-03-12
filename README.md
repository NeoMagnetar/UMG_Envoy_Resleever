# UMG Envoy Resleever

Private UMG homebase repository for one OpenClaw agent.

## Purpose

This repository is the local and Git-backed homebase for a single OpenClaw agent using UMG-style structured configuration.

It is used to store and manage:

- sleeves
- MOLT blocks
- NeoBlocks
- NeoStacks
- compiler assets
- runtime state
- internal documentation

## Scope

This repository is intentionally private and single-agent.

It does **not** yet attempt to be:

- a public UMG marketplace
- a multi-agent upload hub
- a generalized governance framework
- a universal skill registry

Its job is to stabilize one agent first.

## Directory Layout

- `compiler/` — compiler code and related assets
- `sleeves/active/` — currently active sleeve assets
- `sleeves/archive/` — archived or prior sleeve assets
- `sleeves/manifests/` — sleeve indexes and manifests
- `blocks/molt/` — MOLT blocks
- `blocks/neoblocks/` — NeoBlocks
- `blocks/neostacks/` — NeoStacks
- `blocks/manifests/` — block indexes and manifests
- `runtime/active-sleeve.json` — current active sleeve reference
- `runtime/active-stack.json` — current active runtime stack reference
- `runtime/compile-output/` — compiler outputs
- `runtime/traces/` — compile or runtime traces
- `docs/` — internal repo and architecture documentation

## Current State

This is the initial scaffold version of the homebase.

Core OpenClaw skill activation is working.
Directory structure is in place.
Compiler assets, sleeve files, and block libraries will be added next.

## Intended Workflow

1. Store source assets in the repo
2. Select active sleeve and active stack state
3. Run compiler or transformation steps
4. Save outputs to `runtime/compile-output/`
5. Preserve prior states in archive locations
6. Sync changes back to GitHub

## Notes

The repository should prefer explicit, inspectable files over hidden state.
Source assets, compiled outputs, and active runtime state should remain separate.