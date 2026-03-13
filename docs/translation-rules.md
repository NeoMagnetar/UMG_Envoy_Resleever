# Translation Rules — Stage 4

This document explains how to ingest future source material into the canonical JSON formats defined in Stage 4.

## 1. Atomic MOLT Blocks

1. **Identify the block type** (Directive, Trigger, Instruction, Subject, Primary, Philosophy, Blueprint).
2. **Assign the canonical ID** (`TRG.###`, `DIR.###`, etc). IDs must be unique and stable.
3. **Set metadata fields**
   - `type`, `name`, `category`, `subcategory`, `status`, `version`, `tags`.
   - `category` must be one of the top-level categories (`general`, `domain_specific`, `framework_specific`, `experimental`, `archived`).
   - `subcategory` is snake_case derived from the user-supplied grouping.
4. **Populate content**
   - Map descriptive text into `content.summary` (short) and `content.details` (long form) when available.
   - Use `content.structure` and `constraints` for structured payloads (e.g., blueprint requirements).
5. **Type-specific data**
   - Triggers: `activation`, `signals`, `required_context`, `examples`.
   - Directives: `scope`, `constraints`, `governance_links`.
   - Instructions: `action`, `expected_output`, `steps`.
   - Subjects: `definition`, `key_attributes`, `related_subjects`.
   - Primary: `essence`, `core_concern`, `driver`.
   - Philosophy: `core_principles`, `application`, `risks`.
   - Blueprint: `structure`, `input_contract`, `output_characteristics`.
6. **Provenance**
   - Record `source.library_name`, `source.library_version`, `created`, `created_by`, `supervised_by`, and any external references (PDF, doc link, etc.).
7. **Partial input**
   - If data is missing, set the field to `null` and document the gap in `notes`.
   - Do **not** invent activation text, examples, or structure.
8. **Deduplication & versioning**
   - Check `blocks/manifests/molt-library-index.json` for existing IDs.
   - If content changes, bump `version` (semver) and record the prior version in `notes`.

## 2. NeoBlocks

1. **Gather component MOLT blocks** and confirm each exists in the normalized libraries.
2. **Assign ID (`NBK.xxx`)** and metadata (`category`, `subcategory`, `status`, `version`).
3. **Document composition** in `composition_logic`:
   - `sequence`: ordered list of block IDs.
   - `parallel`: parallelizable sets.
   - `conditions`: gating logic.
   - `notes`: human-readable rationale.
4. **Governing directives**
   - Reference directive IDs that bound this NeoBlock.
5. **Provenance**
   - Same as MOLT blocks, referencing the NeoBlock library.
6. **Handling partial input**
   - If referenced blocks are missing, pause ingestion and log the blocker. Do not inline text.
   - For ambiguous ordering, capture the uncertainty in `notes` and mark `status` as `experimental`.

## 3. NeoStacks

1. **Select NeoBlocks** (`NBK.xxx`) that compose the higher-level capability.
2. **Assign ID (`NST.xxx`)** and metadata.
3. **Activation logic**
   - Describe entry conditions, sequencing, fallback blocks, and conditions for escalation within `activation_logic`.
4. **Governance**
   - Reference directive IDs or governance policies that apply across the entire stack.
5. **Provenance & Versioning**
   - Follow the same pattern as other assets; bump `version` when composition changes.
6. **Partial input**
   - Do not substitute missing NeoBlocks with raw text. Gather/ingest the missing NeoBlocks first.

## 4. Sleeves

1. **Reference NeoStacks** (`NST.xxx`). Sleeves may not reference raw MOLT blocks.
2. **Assign ID (`SLV.name`)** and metadata.
3. **Capture runtime details** in the `runtime` object (staging file, active stack path, compiler helper, etc.).
4. **Governance**
   - Document directive IDs, approval notes, and governance status.
5. **Activation notes**
   - Describe deployment prerequisites, dependencies, or allowed channels.
6. **Partial input**
   - A sleeve cannot be normalized until all referenced NeoStacks exist. Hold the sleeve record in `status = "staged"` if necessary.

## 5. Provenance preservation

- Every asset must store `source.library_name`, `library_version`, `created`, `created_by`, and `ingested_by`.
- When ingesting from PDFs or external systems, include `source.reference` (URL or file path).
- When translating updates, append to `notes` or create a `history` array if provenance requires auditing.

## 6. Duplicate handling

- Check for existing IDs before ingestion.
- If content is identical, update `source` metadata but leave `version` unchanged.
- If content diverges, bump `version` and describe the delta in `notes`.

## 7. Categorization model

- Top level: `general`, `domain_specific`, `framework_specific`, `experimental`, `archived`.
- Subcategories must be snake_case and recorded in `blocks/manifests/category-index.json`.
- Domain-specific assets should include an additional tag for the domain (e.g., `healthcare`).

## 8. Future workflow summary

1. Receive source material.
2. Determine asset level (MOLT, NeoBlock, NeoStack, Sleeve).
3. Apply ID + metadata.
4. Populate canonical template (markdown guidance + JSON template).
5. Update the appropriate library file (`library.v*.json`).
6. Update manifests (library index, category index) to include the new entries.
7. If applicable, update examples and documentation.

Following these rules keeps Stage 4 assets machine-readable, traceable, and ready for compiler ingestion.
