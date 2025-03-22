from jinja2 import Environment, FileSystemLoader
import os

from ..helper.cliargs import CommandLineArguments
from ..helper.datetimeconverter import DateTimeConverter
from ..helper.logger import Logger
from ..html.themes.theme_config import DEFAULT_THEME, ROBOT_THEME, DARK_THEME, CUSTOM_THEME_01

class TestDocHtmlRendering():

    TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "html", "templates")
    
    def __init__(self):
        self.DOC_TITLE = CommandLineArguments().data.title

    def render_testdoc(self,
            suites,
            output_file
        ):
        env = Environment(loader=FileSystemLoader(self.TEMPLATE_DIR))
        template = env.get_template("jinja_template_01.html")
        # template = env.get_template("jinja_template_02.html")

        rendered_html = template.render(
            suites=suites,
            generated_at=DateTimeConverter().get_generated_datetime(),
            title=self.DOC_TITLE,
            # colors=DEFAULT_THEME
            colors=CUSTOM_THEME_01
        )
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(rendered_html)
        Logger().LogKeyValue("Generated Test Documentation File: ", output_file)