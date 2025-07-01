from jinja2 import Environment, FileSystemLoader
from pathlib import Path
import os

from ..html.themes.theme_config import ThemeConfig
from ..helper.cliargs import CommandLineArguments, TOMLReader
from ..helper.datetimeconverter import DateTimeConverter
from ..helper.logger import Logger

class TestDocHtmlRendering():

    HTML_TEMPLATE_VERSION = "2.0"
    HTML_TEMPLATE_NAME = "jinja_template_03.html"
    TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "html", "templates", HTML_TEMPLATE_VERSION)
    
    def __init__(self):
        self.args = CommandLineArguments().data

    def render_testdoc(self,
            suites,
            output_file
        ):
        env = Environment(loader=FileSystemLoader(self.TEMPLATE_DIR))
        template = env.get_template(self.HTML_TEMPLATE_NAME)

        rendered_html = template.render(
            suites=suites,
            generated_at=DateTimeConverter().get_generated_datetime(),
            title=self.args.title,
            colors=ThemeConfig().theme(),
            contact_mail = "marvinklerx20@gmail.com"
        )
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(rendered_html)
        Logger().LogKeyValue("Generated Test Documentation File: ", output_file)