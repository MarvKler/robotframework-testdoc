from .helper.pathconverter import PathConverter
from .parser.testsuiteparser import RobotSuiteParser
from .html.rendering.render import TestDocHtmlRendering
from .parser.modifier.suitefilemodifier import SuiteFileModifier

class TestDoc():
    
    def main(self):        
        # Parse suite object & return complete suite object with all information
        suite_object = RobotSuiteParser().parse_suite()
        
        # Run SuiteFileModifier to modify the test suite object
        suite_object = SuiteFileModifier().run(suite_object)

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suite_object, PathConverter().path_convertion())