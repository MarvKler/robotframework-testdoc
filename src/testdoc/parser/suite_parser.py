import os

from robot.api import ExecutionResult, SuiteVisitor, TestSuite

class RobotSuiteParser(SuiteVisitor):
    def __init__(self):
        self.suites = []
        self.tests = []

    def visit_suite(self, suite):
        """Wird für jede Test-Suite aufgerufen und speichert ihre Hierarchie."""

        # Skip suite if its already parsed into list
        self.already_parsed(suite)

        # Test Suite Parser
        suite_info = {
            "name": suite.name,
            "doc": "<br>".join([line for line in suite.doc.split("\n") if line.strip()]) if suite.doc else "No suite documentation available - please add!", 
            "is_folder": self.is_directory(suite),
            "num_tests": len(suite.tests),
            "source": str(suite.source),
            "total_tests": 0,
            "tests": [],
            "sub_suites": []
        }

        # Test Case Parser
        for test in suite.tests:
            test_info = {
                "name": test.name,
                "doc": "<br>".join([line for line in test.doc.split("\n") if line.strip()]) if test.doc else "No test documentation available - please add!", 
                "tags": test.tags if test.tags else [],
                "source": str(test.source),
                "keywords": [kw.name for kw in test.body if hasattr(kw, 'name')]
            }
            suite_info["tests"].append(test_info)

        # Collect sub-suites recursive
        total_tests = suite_info["num_tests"]
        for sub_suite in suite.suites:
            sub_parser = RobotSuiteParser()
            sub_parser.visit_suite(sub_suite)
            suite_info["sub_suites"].extend(sub_parser.suites)
            total_tests += sum(s["total_tests"] for s in sub_parser.suites)

        suite_info["total_tests"] = total_tests
        self.suites.append(suite_info)

    def is_directory(self, suite) -> bool:
        suite_path = suite.source if suite.source else ""
        return(os.path.isdir(suite_path) if suite_path else False)
    
    def already_parsed(self, suite):
        existing_suite = next((s for s in self.suites if s["name"] == suite.name), None)
        if existing_suite:
            return

    def parse_suite(self, suite_path):
        """Lädt eine `.robot` Suite oder einen Ordner mit Suiten."""
        suite = TestSuite.from_file_system(suite_path)
        suite.visit(self)
        return self.suites
