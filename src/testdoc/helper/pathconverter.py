import os

from .cliargs import CommandLineArguments
from .logger import Logger

class PathConverter():

    def __init__(self):
        self.args = CommandLineArguments().data

    def path_convertion(self) -> str:
        
        suite_path = self.args.suite_file
        output_path = self.args.output_file
        config_path = self.args.config_file

        # Convert path to suite file / directory
        suite_path = PathConverter().conv_generic_path(path=suite_path)
        if ".robot" in suite_path:
            msg = f'Suite File: "{str(suite_path).split("/")[-1]}"'
        else:
            msg = f"Suite Directory: '{suite_path}'"

        # Convert path to output file
        output_path = PathConverter().conv_generic_path(path=output_path)

        # Convert path to config file
        if self.args.config_file:
            config_path = PathConverter().conv_generic_path(path=config_path)

        # Print to console
        if self.args.verbose_mode:
            Logger().Log("=== TestDoc  ===")
            Logger().LogKeyValue("Generating Test Documentation for: ", msg)
            Logger().LogKeyValue("Saving to output file: ", output_path)
            Logger().LogKeyValue("Using config file: ", config_path) if config_path else None

        return suite_path, output_path, config_path

    def conv_generic_path(self,
            path: str
        ) -> str:
        """
        Generate OS independent path.
        """
        abs_path = os.path.abspath(path)
        generic_path = os.path.normpath(abs_path)
        if os.name == "nt":
            generic_path = generic_path.replace("\\", "/")
        return generic_path