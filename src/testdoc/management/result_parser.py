from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from robot.api import ExecutionResult
from robot.result import ResultVisitor

from .identity import result_test_key


@dataclass
class TestResultRecord:
    """A single test result extracted from a Robot Framework output.xml file."""

    full_name: str
    test_key: str
    status: str
    message: str
    start_time: str | None
    elapsed_time: float


class _ResultCollector(ResultVisitor):
    def __init__(self) -> None:
        self.records: list[TestResultRecord] = []

    def visit_test(self, test):
        self.records.append(
            TestResultRecord(
                full_name=test.longname,
                test_key=result_test_key(getattr(test, "source", None), getattr(test, "id", None)),
                status=test.status,
                message=test.message,
                start_time=self._start_time(test),
                elapsed_time=self._elapsed_seconds(test),
            )
        )

    def _start_time(self, test) -> str | None:
        start_time = getattr(test, "start_time", None) or getattr(test, "starttime", None)
        return str(start_time) if start_time else None

    def _elapsed_seconds(self, test) -> float:
        elapsed_time = getattr(test, "elapsed_time", None)
        if elapsed_time is not None:
            return elapsed_time.total_seconds()
        return getattr(test, "elapsedtime", 0) / 1000.0


class ResultParser:
    """Parses a Robot Framework `output.xml` file into flat test result records."""

    def parse(self, report_file: str) -> list[TestResultRecord]:
        result = ExecutionResult(Path(report_file))
        collector = _ResultCollector()
        result.visit(collector)
        return collector.records
