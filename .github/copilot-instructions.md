# Copilot Instructions

## Context efficiency

- Inspect only files directly relevant to the requested task.
- Do not inspect the entire repository unless explicitly required.
- Do not open unrelated files.
- Do not search broadly when a targeted search is sufficient.
- Reuse existing implementations instead of exploring or designing alternatives.
- Stop investigating once enough context is available to implement the change.
- Do not summarize files that are not relevant to the task.

## Implementation

- Make the smallest change that solves the request.
- Modify only necessary files.
- Do not refactor unrelated code.
- Do not introduce new abstractions unless necessary.
- Reuse existing utilities, helpers, components, keywords and patterns.
- Do not introduce dependencies unless necessary.
- Preserve existing architecture and conventions.

## Code generation

- Generate only the code required for the requested change.
- Do not regenerate complete files when only a section needs modification.
- Do not add unnecessary comments.
- Do not add boilerplate.
- Do not generate alternative implementations unless requested.

## Testing

- Inspect only tests relevant to the changed functionality.
- Run only targeted tests relevant to the change.
- Do not create tests for unrelated functionality.

## Response

- Keep the response concise.
- Do not explain unchanged code.
- Do not repeat the request.
- Do not provide alternatives unless requested.
- Summarize only the changes made and tests run.