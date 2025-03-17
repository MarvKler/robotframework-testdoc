import os
import click

from .cliargs import CommandLineArguments

class PathConverter():

    def __init__(self):
        self.cli_args = CommandLineArguments()

    def path_convertion(self) -> str:

        # Read vars
        suite_path = self.cli_args.get_suite_file()
        output_path = self.cli_args.get_output_file()
        config_path = self.cli_args.get_config_file()

        # Convert path to suite file / directory
        suite_path = PathConverter().conv_generic_path(path=suite_path)
        if ".robot" in suite_path:
            msg = f"Suite File: '{str(suite_path).split("/")[-1]}'"
        else:
            msg = f"Suite Directory: '{suite_path}'"

        # Convert path to output file
        output_path = PathConverter().conv_generic_path(path=output_path)

        # Convert path to config file
        config_path = PathConverter().conv_generic_path(path=config_path)

        # Print to console
        if self.cli_args.get_verbose_mode():
            click.echo("=> Generating Test Documentation for:")
            click.echo(click.style(msg, fg="green"))
            click.echo("=> Saving to output file:")
            click.echo(click.style(f"'{output_path}'", fg="green"))
            click.echo("=> Using config file:")
            click.echo(click.style(f"'{config_path}'", fg="green"))

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