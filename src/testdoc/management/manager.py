from __future__ import annotations

from pathlib import Path

import click

from ..helper.cliargs import CommandLineArguments
from ..helper.logger import Logger
from ..html.rendering.render import TestDocHtmlRendering
from ..html.rendering.webapp import TestDocWebRenderer
from ..parser.models import CustomTestSuite
from .database import ResultDatabase
from .identity import documentation_test_key
from .mapper import ManagementMapper
from .result_parser import ResultParser, TestResultRecord


class ManagementTool:
    """Orchestrates the `testdoc management` subcommand.

    Combines the parsed test documentation with the Robot Framework execution results
    (output.xml) and persists the result history in a local SQLite database. The combined
    data is rendered as a static web dashboard.
    """

    def run(self, suite: CustomTestSuite, report_file: str, database_file: str, output_dir: str) -> Path:
        report_path = Path(report_file)
        if not report_path.is_file():
            raise click.ClickException(f"Report file not found: '{report_path}'")

        records = self._prepare_records(suite, report_path)

        database = ResultDatabase(database_file)
        database.initialize()
        stored = database.store_run(str(report_path), records)
        if not stored:
            Logger().log("Report already exists in the management history; reusing the existing run.", "yellow")

        history = database.get_history_by_test()
        management_suite = ManagementMapper().build(suite, history)

        documentation_output = self._render_documentation(suite, Path(output_dir))
        index_file = TestDocWebRenderer().render(management_suite, Path(output_dir))
        Logger().log_key_value("Generated Test Documentation: ", str(documentation_output))
        Logger().log_key_value("Generated Management Web App: ", str(index_file))
        return index_file

    def _prepare_records(self, suite: CustomTestSuite, report_path: Path) -> list[TestResultRecord]:
        records = ResultParser().parse(str(report_path))
        result_keys = {record.test_key for record in records}

        for test in self._iter_tests(suite):
            test_key = documentation_test_key(test)
            if test_key in result_keys:
                continue

            records.append(
                TestResultRecord(
                    full_name=test.name,
                    test_key=test_key,
                    status="NOT_RUN",
                    message="",
                    start_time=None,
                    elapsed_time=0.0,
                )
            )

        return records

    def _render_documentation(self, suite: CustomTestSuite, output_dir: Path) -> Path:
        args = CommandLineArguments()
        output_dir.mkdir(parents=True, exist_ok=True)
        output_format = args.output_format.lower()
        if args.mkdocs_usage:
            documentation_output = output_dir / "documentation"
            documentation_output.mkdir(parents=True, exist_ok=True)
        else:
            extension = {"json": ".json", "pdf": ".pdf"}.get(output_format, ".html")
            documentation_output = output_dir / f"documentation{extension}"

        original_args = dict(args.all_as_dict)
        updated_args = dict(original_args)
        updated_args["output_file"] = str(documentation_output)
        args.set_args(**updated_args)
        try:
            TestDocHtmlRendering().render_testdoc(suite, documentation_output)
        finally:
            args.set_args(**original_args)
        return documentation_output

    def _iter_tests(self, suite: CustomTestSuite):
        yield from suite.tests
        for sub_suite in suite.suites:
            yield from self._iter_tests(sub_suite)
