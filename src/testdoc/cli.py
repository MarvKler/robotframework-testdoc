import click

from .testdoc import TestDoc
from .helper.cli_args import CommandLineArguments

@click.command()
@click.option("-p", "--path", required=True)
@click.option("-o", "--output", required=True)
@click.option("-c", "--configfile", required=True)
@click.option("-v", "--verbose", is_flag=True, default=False, help="More precise debugging")
def main(
      path,
      output,
      configfile,
      verbose
    ):
    """
    ...
    """
    color = "green"
    click.echo(click.style("""
████████╗███████╗███████╗████████╗██████╗ ███████╗███████╗
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██   ██╗██   ██║██╔════╝
   ██║   █████╗  ███████╗   ██║   ██   ██║██   ██║██║     
   ██║   ██╔══╝  ╚════██║   ██║   ██   ██║██   ██║██║       
   ██║   ███████╗███████║   ██║   ██████╔╝███████║███████╗
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝  
      """, fg=color)
    )

    # Save args into singleton method
    cli_args = CommandLineArguments()
    cli_args.set_suite_file(path)
    cli_args.set_output_file(output)
    cli_args.set_config_file(configfile)
    cli_args.set_verbose_mode(verbose)

    TestDoc().main()

    


if __name__ == "__main__":
    main()
