# Repo Responsibilities

## Overview

The local UMG/OpenClaw environment uses two separate sibling repositories:

- `UMG_Envoy_Resleever`
- `umg-compiler`

This separation is intentional and should be preserved.

---

## Repository: `UMG_Envoy_Resleever`

### Primary responsibility

This repository is the UMG runtime homebase and OpenClaw-facing skill surface.

### It is responsible for

- storing sleeves
- storing MOLT blocks
- storing NeoBlocks
- storing NeoStacks
- maintaining runtime state
- maintaining manifests and indexes
- defining active runtime structure
- exposing future resleeving and reconfiguration workflows
- documenting local repo contracts
- providing a compiler adapter layer

### It should contain

- `blocks/`
- `sleeves/`
- `runtime/`
- `compiler/` (adapter only)
- `docs/`
- `SKILL.md`
- runtime-facing config files

### It should not contain

- duplicated full compiler source
- ad hoc copies of compiler internals
- mixed runtime and compiler logic with no boundary

---

## Repository: `umg-compiler`

### Primary responsibility

This repository is the compiler toolchain for UMG structures.

### It is responsible for

- parsing source structures
- validating structures
- transforming normalized inputs
- synthesizing runtime outputs
- generating compile artifacts
- generating trace artifacts
- maintaining compiler-specific code and tests

### It should contain

- compiler source code
- compiler tests
- compiler build scripts
- compiler documentation
- compiler samples

### It should not be responsible for

- storing runtime state for the OpenClaw homebase
- acting as the OpenClaw homebase repo
- managing the full runtime sleeve library directly

---

## Relationship between the two repos

`UMG_Envoy_Resleever` depends on `umg-compiler`, but it is not the same repo.

The relationship is:

- sibling repos
- separate git histories
- separate responsibilities
- explicit bridge layer through `UMG_Envoy_Resleever\\compiler`

---

## Adapter model

Inside `UMG_Envoy_Resleever`, the `compiler/` folder serves as an adapter layer.

It should contain:

- path configuration
- invocation notes
- wrapper scripts
- adapter status docs

It should not contain the entire compiler source tree.

---

## Source of truth policy

- For runtime/homebase structures → source of truth is `UMG_Envoy_Resleever`
- For compiler logic → source of truth is `umg-compiler`

---

## Future interaction pattern

Expected long-term flow:

1. Source sleeves and block assets are maintained in `UMG_Envoy_Resleever`.
2. Normalized inputs are prepared in the homebase repo.
3. The adapter layer invokes `umg-compiler`.
4. Compiler outputs are written into `runtime/compile-output/` and `runtime/traces/`.
5. Runtime state is updated only after successful compile/integration flow.

---

## Rule

Do not collapse these repositories together unless there is an explicit redesign decision. The current architecture depends on separation.
