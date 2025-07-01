from jinja2 import Environment, FileSystemLoader
import os

from ..html.themes.theme_config import ThemeConfig
from ..helper.cliargs import CommandLineArguments
from ..helper.datetimeconverter import DateTimeConverter
from ..helper.logger import Logger

class TestDocHtmlRendering():

    def __init__(self):
        self.args = CommandLineArguments().data
        self._html_templ_selection()

    def _html_templ_selection(self):
        """ Check which HTML template should selected - custom specific configuration """
        if self.args.html_template == "v1":
            self.HTML_TEMPLATE_VERSION = self.args.html_template
            self.HTML_TEMPLATE_NAME = "jinja_template_01.html"
            self.TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "html", "templates", self.HTML_TEMPLATE_VERSION)
        elif self.args.html_template == "v2":
            self.HTML_TEMPLATE_VERSION = self.args.html_template
            self.HTML_TEMPLATE_NAME = "jinja_template_03.html"
            self.TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "html", "templates", self.HTML_TEMPLATE_VERSION)
        else:
            raise ValueError(f"CLI Argument 'html_template' got value '{self.args.html_template}' - value not known!")         

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