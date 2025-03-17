from .helper.pathconverter import PathConverter
from .parser.testsuiteparser import RobotSuiteParser
from .html_rednering.render import TestDocHtmlRendering

class TestDoc():
    
    def main(self):
        # Convert to correct pathes
        suite_path, output_path, config_path = PathConverter().path_convertion()
        
        # Parse suite object
        suites_tests = RobotSuiteParser().parse_suite(suite_path)

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suites_tests, output_path)