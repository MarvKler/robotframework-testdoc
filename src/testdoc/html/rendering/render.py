from pathlib import Path
from jinja2 import Environment, FileSystemLoader

from ...parser.models import SuiteInfoModel

from ...html.themes.theme_config import ThemeConfig
from ...helper.cliargs import CommandLineArguments
from ...helper.datetimeconverter import DateTimeConverter
from ...helper.logger import Logger

class TestDocHtmlRendering():

    def __init__(self):
        self.args = CommandLineArguments()

    def _get_jinja_template_path(self) -> Path:
        """ Check which HTML template should selected - custom specific configuration """
        if self.args.custom_jinja_template:
            return Path(self.args.custom_jinja_template).expanduser().resolve()
        elif self.args.html_template == "v1":
            return Path(__file__).resolve().parent / ".." / "templates" / self.args.html_template / "jinja_template_01.html"
        elif self.args.html_template == "v2":
            return Path(__file__).resolve().parent / ".." / "templates" / self.args.html_template / "jinja_template_03.html"
        else:
            raise ValueError(f"CLI Argument 'html_template' got value '{self.args.html_template}' - value not known!")

    def render_testdoc(self,
            suites: list[SuiteInfoModel],
            output_file
        ):
        jinja_template_file = self._get_jinja_template_path()

        env = Environment(loader=FileSystemLoader(jinja_template_file.parent))
        template = env.get_template(jinja_template_file.name)

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