from pathlib import Path

from ...helper.logger import Logger
from ...parser.models import CustomKeywordCall, CustomTestCase, CustomTestSuite
from ...parser.testcaseparser import TestCaseParser


class MarkdownRenderer:
    """Render the parsed suite tree as one Markdown document."""

    def __init__(self) -> None:
        self._body_parser = TestCaseParser()

    def render(self, suites: CustomTestSuite, output_file: Path) -> None:
        lines = [f"# {suites.name}", ""]
        self._append_suite(lines, suites, level=2)
        Path(output_file).write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
        Logger().log_key_value("Generated Test Documentation Markdown: ", output_file)

    def _append_suite(self, lines: list[str], suite: CustomTestSuite, level: int) -> None:
        lines.append(f"{'#' * level} Suite: {suite.name}")
        lines.append("")
        self._append_value(lines, "Type", suite.type)
        self._append_value(lines, "Source", suite.custom_source or suite.source)
        self._append_value(lines, "Test count", suite.test_count)

        if suite.metadata:
            lines.extend(["", "### Metadata", ""])
            for key, value in suite.metadata.items():
                lines.append(f"- **{key}:** {value}")

        if suite.doc:
            lines.extend(["", "### Documentation", "", suite.doc.rstrip(), ""])

        self._append_fixture(lines, "Setup", suite.setup)
        self._append_fixture(lines, "Teardown", suite.teardown)

        if suite.user_keywords:
            lines.extend(["", "### User Keywords", ""])
            lines.extend(f"- {keyword}" for keyword in suite.user_keywords)

        for test in suite.tests:
            self._append_test(lines, test, level + 1)

        for child in suite.suites:
            self._append_suite(lines, child, level + 1)

    def _append_test(self, lines: list[str], test: CustomTestCase, level: int) -> None:
        lines.extend(["", f"{'#' * level} Test: {test.name}", ""])
        self._append_value(lines, "Source", test.custom_source or test.source)

        if test.tags:
            self._append_value(lines, "Tags", ", ".join(str(tag) for tag in test.tags))
        if test.doc:
            lines.extend(["", "#### Documentation", "", test.doc.rstrip(), ""])

        self._append_fixture(lines, "Setup", test.setup)
        self._append_fixture(lines, "Teardown", test.teardown)

        body = self._body_parser._keyword_parser(test.body) if test.body else []
        if body:
            lines.extend(["", "#### Test Body", "", "```robotframework", *body, "```", ""])

    def _append_fixture(self, lines: list[str], name: str, fixture: CustomKeywordCall | None) -> None:
        if fixture is None:
            return
        args = "    ".join(str(arg) for arg in (fixture.args or []))
        value = fixture.name if not args else f"{fixture.name}    {args}"
        self._append_value(lines, name, value)

    def _append_value(self, lines: list[str], label: str, value: object) -> None:
        lines.append(f"- **{label}:** {value}")
