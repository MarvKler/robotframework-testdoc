from robot.api.deco import keyword


@keyword
def MyKeyword(arg: str = "test"):
    """
    Keyword in my custom python keyword library.

    Second line in this docstring.
    """
    print(arg)