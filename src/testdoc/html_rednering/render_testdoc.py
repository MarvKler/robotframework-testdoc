from jinja2 import Environment, FileSystemLoader
import click
import os

from ..helper.datetime_converter import DateTimeConverter
from ..html.themes.theme_config import DEFAULT_THEME, ROBOT_THEME, DARK_THEME

class TestDocHtmlRendering():

    TEMPLATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "html", "templates")

    def render_testdoc(self,
            suites,
            output_file
        ):
        """Render das Jinja-Template mit den Test-Suiten"""
        env = Environment(loader=FileSystemLoader(self.TEMPLATE_DIR))
        template = env.get_template("jinja_template_01.html")  # Template-Datei laden

        rendered_html = template.render(
            suites=suites,
            generated_at=DateTimeConverter().get_generated_datetime(),
            colors=DEFAULT_THEME
        )

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(rendered_html)

        click.echo(click.style(f"===============================================", fg="green"))
        click.echo(click.style(f"=> Successfully generated test documentation here:\n=> {output_file}", fg="green"))
        click.echo(click.style(f"===============================================", fg="green"))
