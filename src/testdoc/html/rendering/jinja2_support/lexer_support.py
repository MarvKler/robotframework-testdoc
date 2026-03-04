from __future__ import annotations

from functools import lru_cache

from pygments import highlight
from pygments.formatters import HtmlFormatter

from testdoc.html.lexer.robotframework.lexer import RobotFrameworkLocalLexer
from testdoc.html.lexer.robotframework.styles import MyRobotStyle


@lru_cache(maxsize=1)
def _fmt_nowrap() -> HtmlFormatter:
    return HtmlFormatter(style=MyRobotStyle, nowrap=True)


def highlight_robot_in_pre(code: str) -> str:
    lexer = RobotFrameworkLocalLexer()
    inner = highlight(code, lexer, _fmt_nowrap())
    return f'<pre class="robotframework"><code>{inner}</code></pre>'


@lru_cache(maxsize=1)
def pygments_css() -> str:
    # Prefix, damit es nur in rf-code wirkt:
    return HtmlFormatter(style=MyRobotStyle).get_style_defs(".robotframework")
