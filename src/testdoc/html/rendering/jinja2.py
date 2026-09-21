from pathlib import Path

from testdoc.parser.models import CustomTestSuite

from ...helper.cliargs import CommandLineArguments
from ...helper.logger import Logger
from ...management.mapper import ManagementMapper
from .webapp import TestDocWebRenderer


class JinjaIntegration:
    def __init__(self):
        self.args = CommandLineArguments()

    def render_jinja2_page(self, suites: CustomTestSuite, output_file: Path):
        management_suite = ManagementMapper().build(suites, {})
        index_file = TestDocWebRenderer().render(management_suite, Path(output_file), show_history=False)
        Logger().log_key_value("Generated Test Documentation File: ", index_file)
