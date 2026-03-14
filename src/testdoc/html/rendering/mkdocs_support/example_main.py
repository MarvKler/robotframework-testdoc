import json
from pathlib import Path

import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

from testdoc.html.lexer.robotframework.lexer import RobotFrameworkLocalLexer
from testdoc.html.lexer.robotframework.styles import MyRobotStyle, MyRobotStyleLight
from testdoc.parser.testcaseparser import TestCaseParser


def _register_custom_robot_lexer():
    _ = RobotFrameworkLocalLexer

    # NOTE: private API access:
    # ruff might warn with SLF001 depending on config; then add `# noqa: SLF001` on the lines.
    pyg_lexers._mapping.LEXERS["RobotFrameworkLexer"] = (
        "testdoc.html.lexer.robotframework.lexer",
        "RobotFramework",
        ("robotframework",),
        ("*.robot", "*.resource"),
        ("text/x-robotframework",),
    )
    pyg_lexers._lexer_cache.clear()


def _generate_pygments_css() -> str:
    """Generate Pygments CSS scoped per color scheme so light and dark mode each get correct colors."""
    dark_prefix = '[data-md-color-scheme="slate"] .md-typeset .highlight'
    light_prefix = '[data-md-color-scheme="default"] .md-typeset .highlight'

    dark_css = HtmlFormatter(style=MyRobotStyle, cssclass="highlight").get_style_defs(dark_prefix)
    light_css = HtmlFormatter(style=MyRobotStyleLight, cssclass="highlight").get_style_defs(light_prefix)

    return f"/* Robot Framework Pygments - light mode */\n{light_css}\n\n/* Robot Framework Pygments - dark mode */\n{dark_css}\n"


def define_env(env):
    _register_custom_robot_lexer()

    data_file = Path(__file__).parent / "suites.json"
    env.variables["suites"] = json.loads(data_file.read_text(encoding="utf-8"))

    env.filters["format_test_body"] = TestCaseParser()._keyword_parser

    out = Path(__file__).parent / "docs" / "stylesheets" / "pygments-myrobot.css"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(_generate_pygments_css(), encoding="utf-8")
