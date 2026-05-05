# Future Ideas for robotframework-testdoc

This document collects potential future features and improvements for `robotframework-testdoc`.
Each idea is listed as its own section with a short description and notes on how it relates to the current architecture.

---

## 2. Suite-Level Setup / Teardown Display

**Summary:** Surface `Suite Setup` and `Suite Teardown` blocks in the generated documentation.

**Details:**  
The `CustomTestSuite` dataclass (`src/testdoc/parser/models.py`) does not currently capture suite-level setup and teardown.
Although the Robot Framework model contains this information, it is discarded when building the custom suite object in `testsuiteparser.py`.
Adding these fields to `CustomTestSuite` and rendering them in the HTML template would give documentation readers a complete picture of a suite's lifecycle.

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