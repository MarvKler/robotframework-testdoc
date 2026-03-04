import re
from pathlib import Path
from typing import ClassVar

from pygments.lexer import Lexer
from pygments.token import Token, _TokenType
from robot.parsing import get_tokens


def get_robot_token_from_file(file: Path):
    return list(get_tokens(file))


HEADER_MATCHER = re.compile(r"\s*\*+ ?(test cases?|tasks?|keywords?|settings?|variables?|comments?) ?\**", re.IGNORECASE)

CONTROL_WORDS = {
    "IF",
    "ELSE IF",
    "ELSE",
    "END",
    "FOR",
    "WHILE",
    "TRY",
    "EXCEPT",
    "FINALLY",
    "RETURN",
    "BREAK",
    "CONTINUE",
    "GROUP",  # dein Spezialfall
}


def get_robot_token(text):
    stripped = text.lstrip("\n")
    if HEADER_MATCHER.match(stripped):
        yield from get_tokens(stripped)
    else:
        marker_len = 20
        new_line_start = " " * marker_len
        if "\n" in text:
            text = f"\n{new_line_start}".join(text.split("\n"))
        suite_str = f"*** Test Cases ***\nFake Test\n{new_line_start}{text}"
        for token in list(get_tokens(suite_str))[6:]:
            if token.type in ["SEPARATOR", "EOL"] and token.col_offset == 0 and token.end_col_offset >= marker_len:
                if token.end_col_offset == marker_len:
                    continue
                token.value = token.value[marker_len:]
                token.col_offset = 0
                token.lineno = token.lineno - 2
            else:
                token.col_offset = token.col_offset - marker_len
                token.lineno = token.lineno - 2
            yield token


def get_variable_token(token_list):
    for token in token_list:
        if len(token.value) == 0:
            continue
        try:
            var_tokens = list(token.tokenize_variables())
        except Exception:
            var_tokens = [token]
        yield from var_tokens


class RobotFrameworkLocalLexer(Lexer):
    name = "RobotFramework"
    url = "http://robotframework.org"
    aliases: ClassVar[list[str]] = ["robotframework"]
    filenames: ClassVar[list[str]] = ["*.robot", "*.resource"]
    mimetypes: ClassVar[list[str]] = ["text/x-robotframework"]

    ROBOT_TO_PYGMENTS: ClassVar[dict[str, _TokenType]] = {
        "HEADER": Token.Keyword.Namespace,
        "DEFINITION": Token.Name.Class,
        "SETTING HEADER": Token.Keyword.Namespace,
        "VARIABLE HEADER": Token.Keyword.Namespace,
        "TESTCASE HEADER": Token.Keyword.Namespace,
        "TASK HEADER": Token.Keyword.Namespace,
        "KEYWORD HEADER": Token.Keyword.Namespace,
        "COMMENT HEADER": Token.Keyword.Namespace,
        "TESTCASE NAME": Token.Name.Class,
        "KEYWORD NAME": Token.Name.Class,
        "DOCUMENTATION": Token.Name.Label,
        "SUITE SETUP": Token.Name.Label,
        "SUITE TEARDOWN": Token.Name.Label,
        "METADATA": Token.Name.Label,
        "TEST SETUP": Token.Name.Label,
        "TEST TEARDOWN": Token.Name.Label,
        "TEST TEMPLATE": Token.Name.Label,
        "TEST TIMEOUT": Token.Name.Label,
        "FORCE TAGS": Token.Name.Label,
        "DEFAULT TAGS": Token.Name.Label,
        "KEYWORD TAGS": Token.Name.Label,
        "LIBRARY": Token.Name.Label,
        "RESOURCE": Token.Name.Label,
        "VARIABLES": Token.Name.Label,
        "SETUP": Token.Name.Property,
        "TEARDOWN": Token.Name.Property,
        "TEMPLATE": Token.Name.Property,
        "TIMEOUT": Token.Name.Property,
        "TAGS": Token.Name.Property,
        "ARGUMENTS": Token.Name.Property,
        "RETURN_SETTING": Token.Name.Property,
        "NAME": Token.Name,
        "VARIABLE": Token.Name.Variable.Instance,
        "ARGUMENT": Token.String,
        "ASSIGN": Token.Name.Variable,
        "KEYWORD": Token.Name.Function,
        "WITH NAME": Token.Keyword,
        "FOR": Token.Keyword,
        "FOR SEPARATOR": Token.Keyword,
        "END": Token.Keyword,
        "IF": Token.Keyword,
        "INLINE IF": Token.Keyword,
        "ELSE IF": Token.Keyword,
        "ELSE": Token.Keyword,
        "TRY": Token.Keyword,
        "EXCEPT": Token.Keyword,
        "FINALLY": Token.Keyword,
        "AS": Token.Keyword,
        "WHILE": Token.Keyword,
        "RETURN STATEMENT": Token.Keyword,
        "CONTINUE": Token.Keyword,
        "BREAK": Token.Keyword,
        "OPTION": Token.Keyword,
        "VAR": Token.Keyword,
        "SEPARATOR": Token.Punctuation,
        "COMMENT": Token.Comment,
        "CONTINUATION": Token.Operator,
        "CONFIG": Token.Punctuation,
        "EOL": Token.Punctuation,
        "EOS": Token.Punctuation,
        "ERROR": Token.Error,
        "FATAL ERROR": Token.Error,
    }

    def __init__(self, **options):
        options["tabsize"] = 2
        options["encoding"] = "UTF-8"
        Lexer.__init__(self, **options)

    def get_tokens_unprocessed(self, text):
        token_list = get_robot_token(text)
        index = 0
        for v_token in get_variable_token(token_list):
            yield index, self.to_pygments_token_type(v_token), v_token.value
            index += len(v_token.value)

    def get_pygments_token(self, token):
        for v_token in get_variable_token(token):
            yield self.to_pygments_token_type(v_token), v_token.value

    def to_pygments_token_type(self, token):
        v = (token.value or "").strip()
        if v and v.upper() in CONTROL_WORDS:
            return Token.Keyword

        if token.type == "VARIABLE":
            if re.match(r"[$&@%]\{(EMPTY|TRUE|FALSE|NONE)}", token.value, re.IGNORECASE):
                return Token.Name.Constant
            if re.match(r"\$\{\d+}", token.value):
                return Token.Name.Constant

        if token.type == "KEYWORD":
            return Token.Name.Function

        return self.ROBOT_TO_PYGMENTS.get(token.type, Token.Generic.Error)


__all__ = ["RobotFrameworkLocalLexer"]
