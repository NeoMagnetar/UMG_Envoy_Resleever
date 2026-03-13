# Canonical Template — NeoStacks

NeoStacks are higher-order constructs built from **one or more NeoBlocks**. They represent cohesive capabilities or modes the runtime can activate.

## Required fields

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Stable identifier such as `NST.020`. |
| `name` | string | Human label. |
| `purpose` | string | Summary of the capability this stack enables. |
| `category` | enum | `general`, `domain_specific`, `framework_specific`, `experimental`, `archived`. |
| `subcategory` | string | Lower-level grouping. |
| `status` | enum | Lifecycle state. |
| `version` | semver | Stack definition version. |
| `neoblock_ids` | array[string] | Ordered list of referenced NeoBlocks. |
| `activation_logic` | object | Explains sequencing, gating, fallback logic, or triggers for the stack. |
| `source` | object | Provenance metadata. |

## Optional fields

| Field | Notes |
| --- | --- |
| `notes` | Free-form clarifications. |
| `examples` | Example runtime contexts. |
| `governance` | Optional governance references (`directive_ids`, `policy_links`). |
| `tags` | Additional search terms. |

The machine template is located at `blocks/manifests/templates/neostack.template.json`.

## Example (abridged)

```json
{
  "id": "NST.050",
  "name": "Analytical Intake Stack",
  "purpose": "Bring together analytical triggers + safety directives for intake workflows.",
  "category": "general",
  "subcategory": "analytical",
  "status": "active",
  "version": "1.0.0",
  "neoblock_ids": ["NBK.100", "NBK.105"],
  "activation_logic": {
    "entry": "fire NBK.100",
    "loop": ["NBK.105"],
    "conditions": ["if escalation needed -> NBK.210"],
    "notes": "explicit order only"
  },
  "governance": {
    "directive_ids": ["DIR.010"],
    "policy_links": []
  },
  "source": {
    "library_name": "UMG NeoStack Library",
    "library_version": "1.0.0"
  }
}
```
