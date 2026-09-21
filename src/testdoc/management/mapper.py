from __future__ import annotations

from ..parser.models import CustomTestSuite
from .identity import documentation_test_key
from .models import ManagementSuite, ManagementTestCase, TestResultEntry


class ManagementMapper:
    """Maps the parsed test documentation tree onto the recorded execution history.

    Test cases are matched against the history by their dotted full name (Robot Framework
    "longname" convention: `RootSuite.SubSuite.TestName`), computed from the same suite tree
    that was used to generate the documentation.
    """

    def build(self, suite: CustomTestSuite, history: dict[str, list[TestResultEntry]], parent_full_name: str = "") -> ManagementSuite:
        full_name = f"{parent_full_name}.{suite.name}" if parent_full_name else suite.name
        management_suite = ManagementSuite(full_name=full_name, suite=suite)
        management_suite.tests.extend(self._map_tests(suite, full_name, history))
        management_suite.suites.extend(self._map_sub_suites(suite, full_name, history))
        return management_suite

    def _map_tests(
        self,
        suite: CustomTestSuite,
        suite_full_name: str,
        history: dict[str, list[TestResultEntry]],
    ) -> list[ManagementTestCase]:
        tests = []
        for test in suite.tests:
            test_full_name = f"{suite_full_name}.{test.name}"
            test_history = history.get(documentation_test_key(test), history.get(test_full_name, []))
            tests.append(
                ManagementTestCase(
                    full_name=test_full_name,
                    test_case=test,
                    history=test_history,
                )
            )
        return tests

    def _map_sub_suites(
        self,
        suite: CustomTestSuite,
        suite_full_name: str,
        history: dict[str, list[TestResultEntry]],
    ) -> list[ManagementSuite]:
        return [self.build(sub_suite, history, suite_full_name) for sub_suite in suite.suites]
