from testdoc.parser.models import CustomTestSuite

from .helper.pathconverter import PathConverter
from .html.rendering.render import TestDocHtmlRendering
from .parser.testsuiteparser import RobotSuiteParser


class TestDoc:
    def main(self) -> None:
        # Parse suite object & return complete suite object with all information
        suite_object: CustomTestSuite = RobotSuiteParser().parse_suite()

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suite_object, PathConverter().path_convertion())
