from pathlib import Path

from .cliargs import CommandLineArguments
from .logger import Logger


class PathConverter:
    def __init__(self):
        self.args = CommandLineArguments()

    def path_convertion(self) -> str:
        output_path = self.args.output_file
        output_path = PathConverter().conv_generic_path(path=output_path)

        # Print to console
        if self.args.verbose_mode:
            Logger().log_key_value("Saving to output file: ", output_path)
        return output_path

    def conv_generic_path(self, path: Path) -> Path:
        """
        Generate OS independent path.
        """
        abs_path = Path(path).resolve()
        return Path(abs_path.as_posix())
