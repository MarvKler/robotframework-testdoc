import json
from pathlib import Path

import pygments.lexers as pyg_lexers
from pygments.formatters import HtmlFormatter

from testdoc.html.lexer.robotframework.lexer import RobotFrameworkLocalLexer
from testdoc.html.lexer.robotframework.styles import MyRobotStyle
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


def define_env(env):
    _register_custom_robot_lexer()

    data_file = Path(__file__).parent / "suites.json"
    env.variables["suites"] = json.loads(data_file.read_text(encoding="utf-8"))

    env.filters["format_test_body"] = TestCaseParser()._keyword_parser

    out = Path(__file__).parent / "docs" / "stylesheets" / "pygments-myrobot.css"
    out.parent.mkdir(parents=True, exist_ok=True)

    formatter = HtmlFormatter(style=MyRobotStyle, cssclass="highlight")
    css = formatter.get_style_defs(".md-typeset")  # prefix selector
    out.write_text(css, encoding="utf-8")
