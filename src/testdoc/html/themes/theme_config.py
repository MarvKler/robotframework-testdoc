from ...helper.cliargs import CommandLineArguments
from .themes import DEFAULT_THEME, ROBOT_THEME, DARK_THEME, BLUE_THEME, ROBOT_THEME_DARK, GREEN_THEME

import os
import tomli

class ThemeConfig():
    
    default_config = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "default.toml")
    
    def __init__(self):
        self.args = CommandLineArguments()
        with open(self.default_config, "rb") as file:
            self.config = tomli.load(file)

    #######################################################################################################

    def theme(self):
        _cli_style = self.args.style
        if _cli_style:
            return self._get_predefined_theme(_cli_style)
        _toml_theme = self.args.colors
        if _toml_theme:
            if "default" in _toml_theme:
                return self._get_predefined_theme(_toml_theme.get("default"))    
            return _toml_theme
        return self._get_predefined_theme(self.config["default"]["theme"])
    
    #######################################################################################################
    
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
        if theme == "robot_dark" or theme == 4:
            return ROBOT_THEME_DARK
        if theme == "green" or theme == 5:
            return GREEN_THEME
        