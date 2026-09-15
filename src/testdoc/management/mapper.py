from __future__ import annotations

from ..parser.models import CustomTestSuite
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

        for test in suite.tests:
            test_full_name = f"{full_name}.{test.name}"
            management_suite.tests.append(
                ManagementTestCase(
                    full_name=test_full_name,
                    test_case=test,
                    history=history.get(test_full_name, []),
                )
            )

        for sub_suite in suite.suites:
            management_suite.suites.append(self.build(sub_suite, history, full_name))

        return management_suite
