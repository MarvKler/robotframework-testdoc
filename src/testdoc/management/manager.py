from __future__ import annotations

from pathlib import Path

import click

from ..helper.logger import Logger
from ..parser.models import CustomTestSuite
from .database import ResultDatabase
from .mapper import ManagementMapper
from .result_parser import ResultParser
from .webapp import ManagementWebRenderer


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

        records = ResultParser().parse(str(report_path))

        database = ResultDatabase(database_file)
        database.initialize()
        database.store_run(str(report_path), records)

        history = database.get_history_by_test()
        management_suite = ManagementMapper().build(suite, history)

        index_file = ManagementWebRenderer().render(management_suite, Path(output_dir))
        Logger().log_key_value("Generated Management Web App: ", str(index_file))
        return index_file
