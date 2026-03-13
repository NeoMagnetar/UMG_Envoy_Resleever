# UMG Envoy Resleever

Private UMG homebase repository for one OpenClaw agent.

## Purpose

This repository is the runtime homebase and organizational layer for a UMG-enabled OpenClaw agent. It is responsible for storing sleeves and blocks, tracking runtime state, maintaining manifests, and bridging to the external `umg-compiler` repository.

## What this repository is

This repository is:

- a private OpenClaw homebase
- a UMG runtime and orchestration layer
- a storage and management surface for sleeves, stacks, and blocks
- the future control surface for resleeving and runtime reconfiguration

## What this repository is not

This repository is **not**:

- the canonical compiler source
- a duplicate copy of the compiler repo
- a public marketplace
- a generic prompt dump
- a monolithic all-in-one codebase

The compiler exists separately as a sibling repository: `..\\umg-compiler`.

## Repository relationship

These repositories are intentionally separated.

### `UMG_Envoy_Resleever`
Handles:

- OpenClaw-facing skill behavior
- UMG homebase organization
- sleeve storage
- block storage
- runtime state
- manifests
- compiler bridge logic

### `umg-compiler`
Handles:

- compilation
- transformation
- synthesis
- validation
- trace generation
- compiler-specific source logic

## Major folders

- `blocks/` — MOLT, NeoBlock, and NeoStack storage
- `sleeves/` — active, archived, and manifest-driven sleeve storage
- `runtime/` — runtime state, compile outputs, traces
- `compiler/` — adapter layer only, not compiler source
- `docs/` — repo contracts and workflow documentation

## Runtime design principle

UMG source assets, compiled outputs, and runtime state remain separate. This repository should preserve clean boundaries between source definitions, runtime state, compiler outputs, and external compiler logic.

## Current status

**Stage 1** established the foundations:

- repo role separation
- path contract
- compiler adapter scaffolding
- documentation for future automation

**Stage 2** layered in sleeve/block scaffolding and the runtime promotion helper.

**Stage 3** activated sleeve inventory discovery, runtime staging/backups, promotion helpers, and the runtime promotion workflow/tests.

**Stage 4** (this stage) adds:

- canonical templates for every hierarchy level (MOLT, NeoBlock, NeoStack, Sleeve)
- normalized machine-readable MOLT libraries (triggers populated, other types scaffolded for ingestion)
- manifests and indexes (`molt-library-index.json`, `category-index.json`)
- translation rules and worked examples for each level
- repository config updates pointing at the normalized libraries/templates

Upcoming stages will build on this foundation for fully automated sleeve activation, stack switching, pre-pass integration, compiler invocation, and runtime reconfiguration.
