from pygments.style import Style
from pygments.token import Comment, Keyword, Name, Number, Operator, Punctuation, String, Text


class MyRobotStyle(Style):
    background_color = ""
    default_style = ""

    styles = {  # noqa: RUF012
        Text: "#D4D4D4",
        Punctuation: "#D4D4D4",
        Operator: "#D4D4D4",
        Comment: "italic #6A9955",
        Keyword.Namespace: "bold underline #4FC1FF",
        Keyword: "bold #C586C0",
        # Test case names / user keywords
        Name.Function: "#DCDCAA",
        # Backup in case of Class
        Name.Class: "#DCDCAA",
        # Variables
        Name.Variable: "#9CDCFE",
        Name.Variable.Instance: "#9CDCFE",
        # Strings
        String: "#CE9178",
        # Numbers
        Number: "#B5CEA8",
    }
