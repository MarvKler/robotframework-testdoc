from .helper.path_converter import PathConverter
from .parser.suite_parser import RobotSuiteParser
from .html_rednering.render_testdoc import TestDocHtmlRendering
from .helper.datetime_converter import DateTimeConverter
from .helper.cli_args import CommandLineArguments

class TestDoc():

    def __init__(self):
        cli_args = CommandLineArguments()
        self.suite = cli_args.get_suite_file()
        self.output = cli_args.get_output_file()
        self.config = cli_args.get_config_file()

    def main(self):
        # Convert to correct pathes
        suite_path, output_path, config_path = PathConverter().path_convertion(self.suite, self.output, self.config)
        
        # Parse suite object
        suites_tests = RobotSuiteParser().parse_suite(suite_path)

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suites_tests, output_path)