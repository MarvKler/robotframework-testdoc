from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from testdoc.html.rendering.jinja2_support.lexer_support import highlight_robot_in_pre, pygments_css
from testdoc.parser.models import CustomTestSuite
from testdoc.parser.testcaseparser import TestCaseParser

from ...helper.cliargs import CommandLineArguments
from ...helper.datetimeconverter import DateTimeConverter
from ...helper.logger import Logger


class JinjaIntegration:
    def __init__(self):
        self.args = CommandLineArguments()

    def _get_jinja_template_path(self) -> Path:
        """Check which HTML template should selected - custom specific configuration"""
        if self.args.custom_jinja_template:
            return Path(self.args.custom_jinja_template).expanduser().resolve()
        return Path(__file__).resolve().parent / ".." / "templates" / "jinja_html_default" / "jinja_template.html"

    def render_jinja2_page(self, suites: CustomTestSuite, output_file: Path):
        jinja_template_file = self._get_jinja_template_path()

        env = Environment(loader=FileSystemLoader(jinja_template_file.parent))

        env.filters["format_test_body"] = TestCaseParser()._keyword_parser
        env.filters["highlight_robot_in_pre"] = highlight_robot_in_pre

        template = env.get_template(jinja_template_file.name)

        rendered_html = template.render(
            suites=suites,
            generated_at=DateTimeConverter().get_generated_datetime(),
            title=self.args.title,
            contact_mail="marvinklerx20@gmail.com",
            pygments_css=pygments_css(),
        )
        with output_file.open("w", encoding="utf-8") as f:
            f.write(rendered_html)
        Logger().log_key_value("Generated Test Documentation File: ", output_file)
