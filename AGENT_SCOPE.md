# AGENT_SCOPE

## Identity

This repository is the private UMG homebase for one OpenClaw agent.

## Primary Responsibilities

The agent may use this repository to:

- read sleeve files
- store and organize sleeve files
- read and organize MOLT blocks
- read and organize NeoBlocks
- read and organize NeoStacks
- read and organize compiler assets
- inspect and update runtime state files
- maintain documentation for the homebase structure

## Current Boundaries

This repository is for one private agent only.

Out of scope for the current version:

- public distribution workflows
- multi-agent upload governance
- universal block exchange protocols
- autonomous repo publishing pipelines
- broad external governance policy systems

## Operating Rules

1. Preserve source assets whenever possible.
2. Do not silently overwrite canonical user-provided files.
3. Keep source assets separate from compiled outputs.
4. Keep active runtime state explicit in `runtime/`.
5. Prefer minimal, inspectable updates over large speculative rewrites.
6. Archive previous active artifacts before destructive replacement when practical.

## File Zones

### Source Zones
- `sleeves/`
- `blocks/`
- `compiler/`

### Runtime Zones
- `runtime/active-sleeve.json`
- `runtime/active-stack.json`
- `runtime/compile-output/`
- `runtime/traces/`

### Documentation Zone
- `docs/`

## Intent

Stabilize one agent first.
Expand only after the private homebase is reliable.