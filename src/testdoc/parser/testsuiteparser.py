import os
from pathlib import Path

from robot.api import SuiteVisitor, TestSuite
from .testcaseparser import TestCaseParser
from .modifier.suitefilemodifier import SuiteFileModifier

class RobotSuiteParser(SuiteVisitor):
    def __init__(self):
        self.suite_counter = 0
        self.suites = []
        self.tests = []

    def visit_suite(self, suite):
        
        # Skip suite if its already parsed into list
        self._already_parsed(suite)

        # Test Suite Parser
        suite_info = {
            "id": str(suite.longname).lower().replace(".", "_").replace(" ", "_"),
            "filename": str(Path(suite.source).name),
            "name": suite.name,
            "doc": "<br>".join(line.replace("\\n","") for line in suite.doc.splitlines() if line.strip()) if suite.doc else None,
            "is_folder": self._is_directory(suite),
            "num_tests": len(suite.tests),
            "source": str(suite.source),
            "total_tests": 0,
            "tests": [],
            "sub_suites": [],
            "metadata": "<br>".join([f"{k}: {v}" for k, v in suite.metadata.items()]) if suite.metadata else None
        }

        # Parse Test Cases
        suite_info = TestCaseParser().parse_test(suite, suite_info)

        # Collect sub-suites recursive
        suite_info, total_tests = self._recursive_sub_suite(suite, suite_info)

        # Append to suites object
        suite_info["total_tests"] = total_tests
        self.suites.append(suite_info)

    def parse_suite(self, suite_path):
        suite = TestSuite.from_file_system(suite_path)
        suite = TestCaseParser().consider_tags(suite)
        suite = SuiteFileModifier()._modify_root_suite_details(suite)
        suite.visit(self)
        return self.suites
    
    ##############################################################################################
    # Helper:
    ##############################################################################################

    def _recursive_sub_suite(self,
            suite: TestSuite,
            suite_info: dict
        ):
        total_tests = suite_info["num_tests"]
        for sub_suite in suite.suites:
            sub_parser = RobotSuiteParser()
            sub_parser.visit_suite(sub_suite)
            suite_info["sub_suites"].extend(sub_parser.suites)
            total_tests += sum(s["total_tests"] for s in sub_parser.suites)
        return suite_info, total_tests

    def _is_directory(self, suite) -> bool:
        suite_path = suite.source if suite.source else ""
        return(os.path.isdir(suite_path) if suite_path else False)
    
    def _already_parsed(self, suite):
        existing_suite = next((s for s in self.suites if s["name"] == suite.name), None)
        if existing_suite:
            return
