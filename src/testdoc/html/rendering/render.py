from testdoc.parser.models import CustomTestSuite

from ...helper.cliargs import CommandLineArguments
from .jinja2 import JinjaIntegration
from .json_renderer import JsonRenderer
from .mkdocs import MkdocsIntegration
from .pdf_renderer import PdfRenderer


class TestDocHtmlRendering:
    def __init__(self) -> None:
        self.args = CommandLineArguments()

    def render_testdoc(self, suites: CustomTestSuite, output_file):
        if self.args.mkdocs_usage:
            MkdocsIntegration().render_mkdocs_page(suites)
            return

        if self.args.output_format.lower() == "json":
            JsonRenderer().render(suites, output_file)
        elif self.args.output_format.lower() == "pdf":
            PdfRenderer().render(suites, output_file)
        else:
            JinjaIntegration().render_jinja2_page(suites, output_file)
