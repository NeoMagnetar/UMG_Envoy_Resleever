# Runtime Promotion Test Plan (Stage 3)

## Test A — Dry-run compile from selected sleeve

**Prerequisites**
1. Sleeve staged at `runtime/staging/sample-basic-minimal--dry-run--20260312-182850.json`.
2. Compiler build ready (Node 20, `npm install/run build`).

**Command**
```powershell
powershell -ExecutionPolicy Bypass -File .\compiler\invoke-compiler.ps1 \
  -InputPath  .\runtime\staging\sample-basic-minimal--dry-run--20260312-182850.json \
  -OutputPath .\runtime\compile-output\sample-basic-minimal--dry-run--20260312-182850.runtime.json \
  -TracePath  .\runtime\traces\sample-basic-minimal--dry-run--20260312-182850.trace.json \
  -Pretty
```

**Expected results**
- Exit code 0.
- Runtime artifact + trace created with matching timestamp.
- No changes to `runtime/active-*.json`.

**Failure modes**
- Input JSON invalid (rewrap staging file).
- Compiler build missing (rerun `npm run build`).

---

## Test B — Controlled promotion

**Prerequisites**
1. Promotion-stage input at `runtime/staging/sample-basic-minimal--promote--20260312-182853.json`.
2. Promotion compile output + trace exist:
   - `runtime/compile-output/sample-basic-minimal--promote--20260312-182853.runtime.json`
   - `runtime/traces/sample-basic-minimal--promote--20260312-182853.trace.json`
3. Optional: `runtime/active-*.json` can be empty (script handles it) but will be backed up if present.

**Commands**
1. Compile (if not already done):
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\compiler\invoke-compiler.ps1 \
     -InputPath  .\runtime\staging\sample-basic-minimal--promote--20260312-182853.json \
     -OutputPath .\runtime\compile-output\sample-basic-minimal--promote--20260312-182853.runtime.json \
     -TracePath  .\runtime\traces\sample-basic-minimal--promote--20260312-182853.trace.json \
     -Pretty
   ```
2. Promote:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\compiler\promote-runtime.ps1 \
     -CompiledOutputPath .\runtime\compile-output\sample-basic-minimal--promote--20260312-182853.runtime.json \
     -TracePath         .\runtime\traces\sample-basic-minimal--promote--20260312-182853.trace.json \
     -SourceSleevePath  .\sleeves\archive\sample-basic_minimal.json \
     -StagedInputPath   .\runtime\staging\sample-basic-minimal--promote--20260312-182853.json \
     -PromotionLabel    "sample-basic"
   ```

**Expected results**
- Backup folder created under `runtime/backups/20260312-183148-sleeve_basic-sample-basic/` (timestamp varies).
- `runtime/active-sleeve.json` and `runtime/active-stack.json` updated with promotion metadata.
- Script prints backup + target paths.

**Failure modes**
- Compiled output missing or malformed → script aborts before any writes.
- Backup write failure → promotion aborts, manual investigation required.
- Trace path missing → recorded as `null`, but promotion continues (safe).

**Success criteria**
- Backup folder exists with previous active files + metadata.
- Active runtime files reference the promoted artifacts and timestamp.
- No other runtime directories are modified.
