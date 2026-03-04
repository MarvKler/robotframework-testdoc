from testdoc.parser.models import CustomTestSuite
from .mkdocs import MkdocsIntegration
from .jinja2 import JinjaIntegration


from ...helper.cliargs import CommandLineArguments

class TestDocHtmlRendering():

    def __init__(self):
        self.args = CommandLineArguments()

    def render_testdoc(self,
            suites: CustomTestSuite,
            output_file
        ):

        if self.args.mkdocs_usage:
            mkdocs = MkdocsIntegration()
            mkdocs.render_mkdocs_page(suites)
            return
        
        j2 = JinjaIntegration()
        j2.render_jinja2_page(suites, output_file)