from pygments.style import Style
from pygments.token import Comment, Keyword, Name, Number, Operator, Punctuation, String, Text


class MyRobotStyle(Style):
    """Dark-mode Robot Framework style (VS Code Dark+ palette)."""

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
        # Keyword name following [Setup] / [Teardown] / [Template] (tokenised as NAME by RF parser)
        Name: "#DCDCAA",
        # Variables
        Name.Variable: "#9CDCFE",
        Name.Variable.Instance: "#9CDCFE",
        # [Setup], [Teardown], [Tags], [Arguments], [Timeout], [Template] inside test/keyword bodies
        Name.Property: "bold #C586C0",
        # Setup, Teardown, Library, Resource, … entries in *** Settings *** section
        Name.Label: "bold #C586C0",
        # Built-in constants: ${EMPTY}, ${TRUE}, ${FALSE}, ${NONE}
        Name.Constant: "#569CD6",
        # Strings
        String: "#CE9178",
        # Numbers
        Number: "#B5CEA8",
    }


class MyRobotStyleLight(Style):
    """Light-mode Robot Framework style (VS Code Light+ palette)."""

    background_color = ""
    default_style = ""

    styles = {  # noqa: RUF012
        Text: "#1E1E1E",
        Punctuation: "#1E1E1E",
        Operator: "#1E1E1E",
        Comment: "italic #008000",
        Keyword.Namespace: "bold underline #0000FF",
        Keyword: "bold #AF00DB",
        # Test case names / user keywords
        Name.Function: "#795E26",
        # Backup in case of Class
        Name.Class: "#795E26",
        # Keyword name following [Setup] / [Teardown] / [Template] (tokenised as NAME by RF parser)
        Name: "#795E26",
        # Variables
        Name.Variable: "#001080",
        Name.Variable.Instance: "#001080",
        # [Setup], [Teardown], [Tags], [Arguments], [Timeout], [Template] inside test/keyword bodies
        Name.Property: "bold #AF00DB",
        # Setup, Teardown, Library, Resource, … entries in *** Settings *** section
        Name.Label: "bold #AF00DB",
        # Built-in constants: ${EMPTY}, ${TRUE}, ${FALSE}, ${NONE}
        Name.Constant: "#0000FF",
        # Strings
        String: "#A31515",
        # Numbers
        Number: "#098658",
    }
