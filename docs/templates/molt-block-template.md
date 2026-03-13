# Canonical Template — MOLT Blocks

Stage 4 defines this template as the canonical shape for **all atomic MOLT blocks** (Directives, Triggers, Instructions, Subjects, Primary, Philosophy, Blueprints). Every normalized block **must** adhere to these rules to stay compatible with downstream compilers.

## Required fields

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Stable identifier such as `TRG.001`, `DIR.010`, `SUB.004`. |
| `type` | enum | One of `DIRECTIVE`, `TRIGGER`, `INSTRUCTION`, `SUBJECT`, `PRIMARY`, `PHILOSOPHY`, `BLUEPRINT`. |
| `name` | string | Human-readable label. |
| `category` | enum | Top-level classification (`general`, `domain_specific`, `framework_specific`, `experimental`, `archived`). |
| `subcategory` | string | Lower-level grouping (snake_case). |
| `status` | enum | `active`, `deprecated`, `experimental`, `archived`, etc. |
| `version` | semver string | Version of this individual block. |
| `tags` | array[string] | Free-form tags to assist discovery. |
| `source` | object | Provenance information (library name, version, created/updated metadata, steward). |

## Optional / contextual fields

| Field | Applies to | Notes |
| --- | --- | --- |
| `scope` | directives, instructions | Describes the operating scope (e.g., `architecture`, `communication`). |
| `content.summary` | all | Short description; default to `name` if unset. |
| `content.details` | directives, philosophy, blueprints | Longer descriptive text or structured payload. |
| `content.structure` | blueprints | JSON object describing required structure. |
| `constraints` | directives, instructions | Array of constraint statements. |
| `examples` | triggers, instructions, subjects | Example invocations/responses. |
| `type_specific` | all | Object containing per-type fields (see below). |
| `notes` | all | Free-form clarifications. |

### Type-specific guidance

| Type | Additional fields |
| --- | --- |
| Directive | `scope`, `constraints`, `governance_links` |
| Trigger | `activation`, `signals`, `required_context` |
| Instruction | `action`, `expected_output`, `steps` |
| Subject | `definition`, `key_attributes`, `related_subjects` |
| Primary | `essence`, `core_concern`, `driver` |
| Philosophy | `core_principles`, `application`, `risks` |
| Blueprint | `structure`, `input_contract`, `output_characteristics` |

## Machine-readable template

A machine-oriented template lives at `blocks/manifests/templates/molt-block.template.json`. Copy that file when instantiating new blocks and fill the required placeholders.

Key rules:

1. **Do not remove required fields.** If data is unknown, set the value to `null` and record a note in `notes`.
2. **Preserve provenance.** Every block must record its originating library and steward in `source`.
3. **Keep atomicity.** One file entry represents exactly one block.
4. **Use snake_case** for subcategories and tag terms.

## Example (abridged)

```json
{
  "id": "TRG.000",
  "type": "TRIGGER",
  "name": "Example Trigger",
  "category": "general",
  "subcategory": "analytical_requests",
  "status": "experimental",
  "version": "0.0.1",
  "tags": ["trigger", "example"],
  "source": {
    "library_name": "Example MOLT Trigger Library",
    "library_version": "0.0.1",
    "created": "2026-03-12",
    "created_by": "Stage4-Agent"
  },
  "scope": null,
  "content": {
    "summary": "Example Trigger",
    "details": null,
    "structure": null
  },
  "constraints": [],
  "activation": "Describe when the trigger should fire.",
  "examples": [],
  "type_specific": {
    "signals": [],
    "required_context": []
  },
  "notes": "Replace placeholder values before committing."
}
```
