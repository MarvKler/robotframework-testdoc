from .helper.pathconverter import PathConverter
from .parser.testsuiteparser import RobotSuiteParser
from .html.rendering.render import TestDocHtmlRendering
from robot import running

class TestDoc():
    
    def main(self):
        # Parse suite object & return complete suite object with all information
        suite_object: running.TestSuite = RobotSuiteParser().parse_suite()

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suite_object, PathConverter().path_convertion())