from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from robot.api import ExecutionResult
from robot.result import ResultVisitor


@dataclass
class TestResultRecord:
    """A single test result extracted from a Robot Framework output.xml file."""

    full_name: str
    status: str
    message: str
    start_time: str | None
    elapsed_time: float


class _ResultCollector(ResultVisitor):
    def __init__(self) -> None:
        self.records: list[TestResultRecord] = []

    def visit_test(self, test):
        start_time = getattr(test, "start_time", None) or getattr(test, "starttime", None)
        elapsed_time = getattr(test, "elapsed_time", None)
        elapsed_seconds = elapsed_time.total_seconds() if elapsed_time is not None else getattr(test, "elapsedtime", 0) / 1000.0

        self.records.append(
            TestResultRecord(
                full_name=test.longname,
                status=test.status,
                message=test.message,
                start_time=str(start_time) if start_time else None,
                elapsed_time=elapsed_seconds,
            )
        )


class ResultParser:
    """Parses a Robot Framework `output.xml` file into flat test result records."""

    def parse(self, report_file: str) -> list[TestResultRecord]:
        result = ExecutionResult(Path(report_file))
        collector = _ResultCollector()
        result.visit(collector)
        return collector.records
