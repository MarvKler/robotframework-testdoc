# Portions of this file are derived from Robot Framework, licensed under the Apache License 2.0.
# Derived code: see class `RobotSuiteFiltering`.

from typing import cast
from robot.api import SuiteVisitor
from robot import running

from testdoc.parser.modifier.sourceprefixmodifier import SourcePrefixModifier
from ..helper.cliargs import CommandLineArguments
from ..helper.pathconverter import PathConverter

from robot.conf import RobotSettings
from robot.api.parsing import get_model
from robot.parsing.model.blocks import File, KeywordSection, Keyword
from robot.running import TestSuiteBuilder
from robot.testdoc import USAGE
from robot.utils import (
    abspath, Application, is_list_like
)

class RobotSuiteParser(SuiteVisitor):
    def __init__(self):
        self.suite_counter = 0
        self.tests = []
        self.args = CommandLineArguments()

        self.robot_suite_model: running.TestSuite = None

    def visit_suite(self, suite: running.TestSuite):

        self.robot_suite_model = suite

    def parse_suite(self) -> running.TestSuite:
        # Use official Robot Framework Application Package to parse cli arguments and modify suite object.
        robot_options = self._convert_args()
        _rfs = RobotSuiteFiltering()
        _rfs.execute_cli(robot_options, False)
        suite = _rfs._suite_object

        # Custom suite object modification with new test doc library
        suite = self._modify_root_suite_details(suite)
        suite.visit(self)

        # Modify the source path for the test documentation
        if self.args.sourceprefix:
            self.robot_suite_model = SourcePrefixModifier().modify_source_prefix(self.robot_suite_model)

        return self.robot_suite_model
    
    ##############################################################################################
    # Helper:
    ##############################################################################################

    # Modify name, doc & metadata via officially provided robot api
    def _modify_root_suite_details(self, suite: running.TestSuite):
        if self.args.name:
            suite.configure(name=self.args.name)
        if self.args.doc:
            suite.configure(doc=self.args.doc)
        if self.args.metadata:
            suite.configure(metadata=self.args.metadata)
        return suite

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
    
    def get_suite_user_keywords(
            self,
            suite_path: str,
        ) -> list:
        """
        function checks if user keywords are defined within the currently visiting suite object
        """

        suite_keywords: list = []
        suite_model: File = get_model(suite_path)
        for section in suite_model.sections:
            if not isinstance(section, KeywordSection):
                continue

            if len(section.body) == 0:
                return suite_keywords.append("No user keywords defined in this suite!")

            section = cast(KeywordSection, section)
            for kw in section.body:
                kw = cast(Keyword, kw)
                suite_keywords.append(kw.name)
        return suite_keywords

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
