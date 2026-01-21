from .mkdocs import MkdocsIntegration
from .jinja2 import JinjaIntegration

from ...parser.models import SuiteInfoModel

from ...helper.cliargs import CommandLineArguments

class TestDocHtmlRendering():

    def __init__(self):
        self.args = CommandLineArguments()

    def render_testdoc(self,
            suites: list[SuiteInfoModel],
            output_file
        ):

        if self.args.mkdocs_usage:
            mkdocs = MkdocsIntegration()
            mkdocs.render_mkdocs_page(suites)
            return
        
        j2 = JinjaIntegration()
        j2.render_jinja2_page(suites, output_file)