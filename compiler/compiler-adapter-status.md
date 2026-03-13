# Compiler Adapter Status

## Current status

- **Stage:** 3
- **Status:** invocation-and-promotion-ready

## Verified

- Compiler entrypoint + wrapper (`invoke-compiler.ps1`) are functional on Node 20.
- Staging/compile/trace paths follow the documented naming contract.
- Promotion helper (`promote-runtime.ps1`) performs backup-first updates of `active-sleeve.json` and `active-stack.json`.

## Pending / future work

- Automated sleeve selection + staging commands (currently manual via docs/workflows).
- Rollback helper that restores from `runtime/backups/` (manual for now).
- Governance around multi-sleeve queues and retention policies (Stage 4+).

## Rules that still apply

- No compiler source belongs in this repo.
- Active runtime files change only through the promotion helper.
- Backups must exist before every promotion.
