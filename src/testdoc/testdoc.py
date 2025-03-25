from .helper.pathconverter import PathConverter
from .parser.testsuiteparser import RobotSuiteParser
from .html_rendering.render import TestDocHtmlRendering
from .parser.modifier.suitefilemodifier import SuiteFileModifier

class TestDoc():
    
    def main(self):
        # Convert to correct pathes
        suite_path, output_path, config_path = PathConverter().path_convertion()
        
        # Parse suite object & return complete suite object with all information
        suite_object = RobotSuiteParser().parse_suite(suite_path)
        
        # Run SuiteFileModifier to modify the test suite object
        suite_object = SuiteFileModifier().run(suite_object)

        # Render HTML file
        TestDocHtmlRendering().render_testdoc(suite_object, output_path)