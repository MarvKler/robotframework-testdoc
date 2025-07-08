# Portions of this file are derived from Robot Framework, licensed under the Apache License 2.0.
# Derived code: see class `RobotSuiteFiltering`.
import os
from pathlib import Path

from robot.api import SuiteVisitor, TestSuite
from .testcaseparser import TestCaseParser
from .modifier.suitefilemodifier import SuiteFileModifier
from ..helper.cliargs import CommandLineArguments
from..helper.pathconverter import PathConverter

from robot.conf import RobotSettings
from robot.running import TestSuiteBuilder
from robot.testdoc import USAGE
from robot.utils import (
    abspath, Application, is_list_like
)

class RobotSuiteParser(SuiteVisitor):
    def __init__(self):
        self.suite_counter = 0
        self.suites = []
        self.tests = []
        self.args = CommandLineArguments()

    def visit_suite(self, suite):
        
        # Skip suite if its already parsed into list
        self._already_parsed(suite)

        # Test Suite Parser
        suite_info = {
            "id": str(suite.longname).lower().replace(".", "_").replace(" ", "_"),
            "filename": str(Path(suite.source).name) if suite.source else suite.name,
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

    def parse_suite(self):
        # Use official Robot Framework Application Package to parse cli arguments and modify suite object.
        robot_options = self._convert_args()
        _rfs = RobotSuiteFiltering()
        _rfs.execute_cli(robot_options, False)
        suite = _rfs._suite_object

        # Custom suite object modification with new test doc library
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
        
    def _convert_args(self):
        """ Convert given cli args to match internal robotframework syntax """
        _include = self.args.include
        _exclude = self.args.exclude
        _source = self.args.suite_file

        # Format / Syntax Conversions
        robot_options = []
        for item in _include:
            robot_options.append("-i")
            robot_options.append(f"{item}")
        for item in _exclude:
            robot_options.append("-e")
            robot_options.append(f"{item}")
        for item in _source:
            _os_indep_path = PathConverter().conv_generic_path(item)
            robot_options.append(f"{_os_indep_path}")
        robot_options.append(self.args.output_file)
        return robot_options

class RobotSuiteFiltering(Application):
    """ Use official RF Application package to build test suite object with given cli options & arguments """
    OPTIONS = """
Options
=======
NOT SUPPORTED YET: -T --title title       Set the title of the generated documentation.
                         Underscores in the title are converted to spaces.
                         The default title is the name of the top level suite.
NOT SUPPORTED YET: -N --name name         Override the name of the top level suite.
NOT SUPPORTED YET: -D --doc document      Override the documentation of the top level suite.
NOT SUPPORTED YET: -M --metadata name:value *  Set/override metadata of the top level suite.
NOT SUPPORTED YET: -G --settag tag *      Set given tag(s) to all test cases.
NOT SUPPORTED YET: -t --test name *       Include tests by name.
NOT SUPPORTED YET: -s --suite name *      Include suites by name.
  -i --include tag *     Include tests by tags.
  -e --exclude tag *     Exclude tests by tags.
"""
    def __init__(self):
        self._suite_object = None
        Application.__init__(self, USAGE, arg_limits=(2,))

    def main(self, datasources, title=None, **options):
        abspath(datasources.pop())
        settings = RobotSettings(options)
        if not is_list_like(datasources):
            datasources = [datasources]
        suite = TestSuiteBuilder(process_curdir=False).build(*datasources)
        suite.configure(**settings.suite_config)
        self._suite_object = suite
