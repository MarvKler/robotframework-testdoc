from pathlib import Path
import textwrap
from typing import cast
from jinja2 import Environment, FileSystemLoader

from robot import running
from robot.model import BodyItem

from testdoc.parser.testcaseparser import TestCaseParser
from testdoc.parser.testsuiteparser import RobotSuiteParser

from ...helper.cliargs import CommandLineArguments
from ...helper.datetimeconverter import DateTimeConverter
from ...helper.logger import Logger

class JinjaIntegration:

    def __init__(self):
        self.args = CommandLineArguments()

    def _get_jinja_template_path(self) -> Path:
        """ Check which HTML template should selected - custom specific configuration """
        if self.args.custom_jinja_template:
            return Path(self.args.custom_jinja_template).expanduser().resolve()
        else:
            return Path(__file__).resolve().parent / ".." / "templates" / "jinja_html_default" / "jinja_template.html"

    def render_jinja2_page(self,
            suites: running.TestSuite,
            output_file
        ):

        jinja_template_file = self._get_jinja_template_path()

        env = Environment(loader=FileSystemLoader(jinja_template_file.parent))

        env.filters['format_test_body'] = TestCaseParser()._keyword_parser
        env.filters['get_user_keywords'] = RobotSuiteParser().get_suite_user_keywords

        template = env.get_template(jinja_template_file.name)

        rendered_html = template.render(
            suites=suites,
            generated_at=DateTimeConverter().get_generated_datetime(),
            title=self.args.title,
            contact_mail = "marvinklerx20@gmail.com"
        )
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(rendered_html)
        Logger().LogKeyValue("Generated Test Documentation File: ", output_file)


    ###
    ### filters
    ###

    def format_body_elements(self, body_object, indent: int = 0) -> str:
        
        lines = []
        _sd = "    " # classic rfw delimiter with 4 spaces
        _indent = _sd * indent

        for item in body_object:

            if item.type == "KEYWORD" and getattr(item, "name", None):
                args = _sd.join(item.args) if getattr(item, 'args', None) else ""
                entry =  _indent + item.name
                if args:
                    entry += _sd + args
                wrapped = textwrap.wrap(entry, width=150, subsequent_indent=_indent + "..." + _sd)
                lines.extend(wrapped)

            if item.type == "GROUP":
                header = f"{_indent}GROUP"
                if not item.name == "":
                    header += f"{_sd}{item.name}"
                if hasattr(item, 'condition') and item.condition:
                    header += f"    {item.condition}"
                lines.append(header)
                if hasattr(item, 'body'):
                    for subkw in item.body:
                        lines.extend(self.format_body_elements(subkw, indent=indent+1))
                lines.append(
                    f"{_indent}END\n" if indent == 0 else f"{_indent}END"
                )        
        return "".join(lines)
    