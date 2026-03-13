# Canonical Template — Sleeves

Sleeves are the **top level** runtime configurations. Each sleeve references NeoStacks (and, by extension, NeoBlocks and MOLT blocks) plus governance and runtime metadata.

## Required fields

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Stable identifier such as `SLV.sample-basic`. |
| `name` | string | Human-readable sleeve name. |
| `purpose` | string | Summary of the runtime capability offered by this sleeve. |
| `category` | enum | `general`, `domain_specific`, `framework_specific`, `experimental`, `archived`. |
| `subcategory` | string | Lower-level grouping. |
| `status` | enum | Lifecycle of the sleeve (`active`, `staged`, `archived`, etc.). |
| `version` | semver | Sleeve definition version. |
| `neostack_ids` | array[string] | Ordered list of stacks that compose the sleeve. |
| `source` | object | Provenance metadata for this sleeve definition. |

## Optional fields

| Field | Notes |
| --- | --- |
| `governance` | Object describing governance IDs, approval chains, and enforcement notes. |
| `runtime` | Object capturing runtime settings (compiler helper, staging file, config knobs). |
| `activation_notes` | Optional text describing activation requirements. |
| `tags` | Additional search terms. |
| `examples` | Example deployments. |
| `notes` | Free-form context.

The machine template resides at `blocks/manifests/templates/sleeve.template.json`.

## Example (abridged)

```json
{
  "id": "SLV.sample-basic",
  "name": "Sample Basic Sleeve",
  "purpose": "Demonstrate Stage 3 runtime promotion flow",
  "category": "framework_specific",
  "subcategory": "umg_envoy",
  "status": "staged",
  "version": "1.0.0",
  "neostack_ids": ["NST.050"],
  "governance": {
    "directive_ids": ["DIR.010"],
    "notes": "Follows Stage 3 approval path"
  },
  "runtime": {
    "staging_file": "runtime/staging/sample-basic-minimal--promote--20260312-182853.json",
    "active_stack_path": "runtime/active-stack.json"
  },
  "source": {
    "library_name": "UMG Sleeve Library",
    "library_version": "1.0.0",
    "created": "2026-03-12"
  }
}
```
