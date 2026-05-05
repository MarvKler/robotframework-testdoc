# Future Ideas for robotframework-testdoc

This document collects potential future features and improvements for `robotframework-testdoc`.
Each idea is listed as its own section with a short description and notes on how it relates to the current architecture.

---

## 1. Additional VCS Source Prefix Providers

**Summary:** Extend the `SourceModifierFactory` to support more version-control hosting platforms beyond GitLab and GitHub.

**Details:**  
The `SourcePrefixModifier` in `src/testdoc/parser/modifier/sourceprefixmodifier.py` already uses a Factory + Strategy pattern that makes adding new providers straightforward.
The file itself contains a comment explicitly inviting future extensions (line 170).
Natural candidates are **Bitbucket**, **Azure DevOps**, and **Gitea**, all following the existing `platform::url` CLI convention (e.g. `bitbucket::https://bitbucket.org/myorg/myrepo`).

---

## 2. Suite-Level Setup / Teardown Display

**Summary:** Surface `Suite Setup` and `Suite Teardown` blocks in the generated documentation.

**Details:**  
The `CustomTestSuite` dataclass (`src/testdoc/parser/models.py`) does not currently capture suite-level setup and teardown.
Although the Robot Framework model contains this information, it is discarded when building the custom suite object in `testsuiteparser.py`.
Adding these fields to `CustomTestSuite` and rendering them in the HTML template would give documentation readers a complete picture of a suite's lifecycle.

---

## 3. Client-Side Tag Filter in the HTML Output

**Summary:** Add a JavaScript-based tag filter so users can show/hide test cases by tag directly in the browser.

**Details:**  
The generated HTML already renders tags as styled badges for every test case (`jinja_template.html`, "Tags" section inside the test-block loop).
A lightweight client-side filter (dropdown or checkbox list of all present tags) that toggles test-block visibility would make navigating large documentation pages much more practical — similar to the tag filter in Robot Framework's built-in `log.html`.
This change requires only additions to `script.js` and a minor template update; no parser changes are needed.

---

## 4. Test Name and Suite Name Filtering (`--test` / `--suite`)

**Summary:** Implement the `-t/--test` and `-s/--suite` CLI options that are currently marked as `NOT SUPPORTED YET`.

**Details:**  
The `RobotSuiteFiltering.OPTIONS` docstring in `src/testdoc/parser/testsuiteparser.py` (lines 172–179) lists several options as not yet supported, including `-t/--test` and `-s/--suite`.
These mirror the standard Robot Framework CLI and would allow users to generate focused documentation for a single test case or a specific sub-suite without having to filter afterwards.

---

## 5. Full Multi-line Keyword Documentation in Tooltips

**Summary:** Show complete keyword docstrings (not just the first line) in the hover tooltip / info panel.

**Details:**  
`TestCaseParser._first_doc_line` (`src/testdoc/parser/testcaseparser.py`, lines 25–42) intentionally returns only the first non-empty line of a keyword's docstring to keep the UI compact.
Supporting full multi-line documentation — rendered as Robot Framework RST or Markdown — in an expandable tooltip or a side-panel would give users complete API-level context without leaving the documentation page.

---

## 6. Additional Output Formats: PDF and Plain Markdown

**Summary:** Add `--output-format pdf` and `--output-format markdown` modes alongside the existing HTML and MkDocs outputs.

**Details:**  
The custom dataclass model (`src/testdoc/parser/models.py`) serialises cleanly to JSON via Python's `dataclasses.asdict` (already used in `mkdocs.py:66`), making it straightforward to feed additional renderers.
- **PDF**: could be produced via `weasyprint` or a headless Chromium call after generating the HTML.
- **Plain Markdown**: useful for including test documentation in wikis, GitHub Wikis, or static sites that do not use MkDocs.

---

## 7. JSON / Machine-readable Output Mode

**Summary:** Expose the parsed suite tree as a standalone `--output-format json` option.

**Details:**  
The MkDocs renderer already writes the complete parsed suite to `suites.json` (`src/testdoc/html/rendering/mkdocs.py`, lines 64–74).
Making this a first-class output mode would allow downstream tooling — dashboards, CI quality gates, or custom report generators — to consume rich test metadata without needing to parse Robot Framework files themselves.

---

## 8. Incremental Regeneration / Watch Mode

**Summary:** Add a `--watch` flag that monitors `.robot` files for changes and regenerates only the affected parts of the documentation.

**Details:**  
For large test suites (exercised in `atest/performance/test_performance.py`), a full regeneration on every change is expensive.
A filesystem watcher (e.g. using the `watchdog` library) that triggers incremental regeneration for changed `.robot` files — and optionally re-serves the MkDocs site via `mkdocs serve` — would significantly improve the developer feedback loop.

---

## 9. Statistics Dashboard Page

**Summary:** Add an optional summary dashboard showing test-per-suite breakdown, tag distribution, documentation coverage, and metadata completeness.

**Details:**  
The top bar in the generated HTML already displays the total test count (`jinja_template.html`, lines 51–55).
An optional dashboard section (or a dedicated tab/page in the MkDocs output) with charts or tables covering:
- number of tests per suite,
- tag usage frequency,
- percentage of tests with documentation,
- metadata key coverage

would provide project managers and quality engineers with a high-level overview of test coverage and documentation health.

---

## 10. Fully Config-driven Invocation (No CLI Arguments Required)

**Summary:** Allow `suite_file` and `output_file` to be defined in `pyproject.toml` or a custom TOML file so that `testdoc` can be run with zero command-line arguments.

**Details:**  
The TOML reader (`src/testdoc/helper/toml_reader.py`, line 22) already parses all other options from the config file, but the two positional CLI arguments (`PATH` and `OUTPUT`, defined in `cli.py` lines 40–41) are currently required on the command line.
Supporting these fields in the TOML config — and making them optional CLI arguments when a config file is present — would let teams run `testdoc -c pyproject.toml` with nothing else, which simplifies CI pipeline configuration.
