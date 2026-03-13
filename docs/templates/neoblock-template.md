# Canonical Template — NeoBlocks

NeoBlocks are compositional units built **only** from atomic MOLT blocks. They capture a reusable combination of directives, triggers, instructions, etc., and expose a named purpose.

## Required fields

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Stable identifier (e.g., `NBK.010`). |
| `name` | string | Human-friendly label. |
| `purpose` | string | Summary of why this NeoBlock exists. |
| `category` | enum | `general`, `domain_specific`, `framework_specific`, `experimental`, `archived`. |
| `subcategory` | string | Lower-level grouping. |
| `status` | enum | `active`, `deprecated`, etc. |
| `version` | semver | Version of this NeoBlock definition. |
| `molt_block_ids` | array[string] | Ordered list of referenced atomic block IDs. |
| `composition_logic` | object | Describes how the referenced blocks interact (sequence, conditions, weights, etc.). |
| `source` | object | Provenance (library name/version, author, steward). |

## Optional fields

| Field | Notes |
| --- | --- |
| `governing_directives` | Array of directive IDs that set boundaries for this NeoBlock. |
| `notes` | Free-form clarifications. |
| `examples` | Example usage contexts. |
| `tags` | Additional discovery hooks. |

The machine template lives at `blocks/manifests/templates/neoblock.template.json`.

## Example (abridged)

```json
{
  "id": "NBK.100",
  "name": "Analytical Intake",
  "purpose": "Bundle the analytical trigger + directive pair used in intake flows.",
  "category": "general",
  "subcategory": "analytical",
  "status": "active",
  "version": "1.0.0",
  "molt_block_ids": ["TRG.001", "DIR.010"],
  "composition_logic": {
    "sequence": ["TRG.001", "DIR.010"],
    "notes": "Fire trigger, then enforce directive scope."
  },
  "governing_directives": ["DIR.010"],
  "source": {
    "library_name": "UMG NeoBlock Library",
    "library_version": "1.0.0"
  }
}
```
