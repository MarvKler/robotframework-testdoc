from __future__ import annotations

from dataclasses import dataclass, field

from ..parser.models import CustomTestCase, CustomTestSuite


@dataclass
class TestResultEntry:
    """A single recorded test execution result, persisted in the management database."""

    run_id: int
    recorded_at: str
    status: str
    message: str
    start_time: str | None
    elapsed_time: float


@dataclass
class ManagementTestCase:
    """Test case documentation combined with its recorded execution history."""

    full_name: str
    test_case: CustomTestCase
    history: list[TestResultEntry] = field(default_factory=list)

    @property
    def latest_status(self) -> str:
        return self.history[-1].status if self.history else "UNKNOWN"


@dataclass
class ManagementSuite:
    """Suite documentation combined with the management test cases and sub-suites."""

    full_name: str
    suite: CustomTestSuite
    tests: list[ManagementTestCase] = field(default_factory=list)
    suites: list[ManagementSuite] = field(default_factory=list)

    @property
    def test_count(self) -> int:
        return len(self.tests) + sum(sub_suite.test_count for sub_suite in self.suites)
