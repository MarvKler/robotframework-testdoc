from ...helper.cliargs import CommandLineArguments
from .themes import DEFAULT_THEME, ROBOT_THEME, DARK_THEME, BLUE_THEME

class ThemeConfig():
    
    def __init__(self):
        self.args = CommandLineArguments().data

    def theme(self):
        _theme = self.args.colors
        if _theme:
            if "default" in _theme:
                return self._get_predefined_theme(_theme.get("default"))    
            return _theme
        return DARK_THEME
    
    def _get_predefined_theme(self, theme: str):
        theme = theme.strip()
        if theme == "default" or theme == 0:
            return DEFAULT_THEME
        if theme == "dark" or theme == 1:
            return DARK_THEME
        if theme == "robot" or theme == 2:
            return ROBOT_THEME
        if theme == "blue" or theme == 3:
            return BLUE_THEME
        