# AGENT_SCOPE

## Current role

This repository is the private UMG homebase for one OpenClaw agent.

Its current role is to:

- maintain the homebase structure
- maintain sleeve storage
- maintain block storage
- maintain runtime state files
- maintain manifests and indexes
- bridge to the external compiler repository
- prepare the environment for later UMG runtime behavior

## Allowed responsibilities

The agent may use this repository to:

- read and organize sleeves
- read and organize MOLT blocks
- read and organize NeoBlocks
- read and organize NeoStacks
- maintain runtime state files
- maintain path and repo contracts
- maintain documentation
- inspect the external compiler repository
- invoke the external compiler through the adapter layer when that path is finalized

## Current limits

The agent should **not** assume that the compiler is embedded in this repository.

The agent should **not** duplicate the full compiler source tree inside this repository unless explicitly instructed.

The agent should **not** treat the `compiler/` folder here as the actual compiler implementation.

The `compiler/` folder in this repository is an adapter layer only.

## Sibling compiler model

Canonical compiler source lives in the sibling repository `..\\umg-compiler`.

This repository should interact with that compiler through path contracts, wrapper scripts, adapter configuration, and future invocation logic.

## Stage 1 behavior constraints

At this stage, the agent should focus on:

- stable structure
- explicit documentation
- clean repo boundaries
- path clarity
- scaffold normalization

At this stage, the agent should not yet implement runtime sleeve switching, pre-pass logic, block mutation workflows, stack mutation workflows, compiler source redesign, or OpenClaw restart behavior.

## Stage 4 behavior constraints

With the Stage 4 objective active the agent **must**:

- preserve strict hierarchy separation (MOLT → NeoBlock → NeoStack → Sleeve)
- keep canonical templates and translation rules up to date
- normalize new MOLT libraries into JSON before referencing them elsewhere
- update manifests (`molt-library-index.json`, `category-index.json`) whenever new assets land
- document provenance for every ingested asset

The agent **must not**:

- collapse hierarchy layers
- invent block content without source material
- duplicate compiler logic or runtime mutation behavior reserved for Stage 5+

## Operating principle

Keep the system explicit, inspectable, and modular. Preserve clean separation between:

- homebase runtime repo
- compiler repo
- source assets
- runtime state
- compiled outputs
