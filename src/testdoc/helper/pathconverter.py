import os

from .cliargs import CommandLineArguments
from .logger import Logger

class PathConverter():

    def __init__(self):
        self.args = CommandLineArguments()

    def path_convertion(self) -> str:
        output_path = self.args.output_file
        output_path = PathConverter().conv_generic_path(path=output_path)
        
        # Print to console
        if self.args.verbose_mode:
            Logger().LogKeyValue("Saving to output file: ", output_path)
        return output_path

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