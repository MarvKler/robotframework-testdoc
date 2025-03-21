import click

from .testdoc import TestDoc
from .helper.cliargs import CommandLineArguments

@click.command()
@click.option(
    "-T",
    "--title", 
    required=False
)

@click.option(
    "-n",
    "--name", 
    required=False
)

@click.option(
    "-d",
    "--doc", 
    required=False
)

@click.option(
    "-m",
    "--metadata", 
    required=False
)

@click.option(
    "-g",
    "--set-tag", 
    required=False
)

@click.option(
    "-t",
    "--test", 
    required=False
)

@click.option(
    "-s",
    "--suite", 
    required=False
)

@click.option(
    "-i",
    "--include", 
    required=False
)

@click.option(
    "-e",
    "--exclude", 
    required=False
)

@click.option(
    "--show-tags",
    is_flag=True,
    required=False
)

@click.option(
    "--show-test-doc", 
    is_flag=True,
    required=False
)

@click.option(
    "--show-suite-doc", 
    is_flag=True,
    required=False
)

@click.option(
    "--show-source", 
    is_flag=True,
    required=False
)

@click.option(
    "--show-keywords", 
    is_flag=True,
    required=False
)

@click.option(
    "-c", 
    "--configfile", 
    is_flag=True,
    required=False
)

@click.option(
    "-v", 
    "--verbose", 
    is_flag=True, 
    default=False, 
    help="More precise debugging"
)

@click.argument(
    "-p",
    "--path",
)

@click.argument(
    "-o",
    "--output",
)
def main(
        path,
        output,
        title,
        name,
        include,
        exclude,
        show_tags,
        show_test_doc,
        show_suite_doc,
        show_source,
        show_keywords,
        configfile,
        verbose,
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
    args = CommandLineArguments().data
    args.suite_file = path
    args.output_file = output
    args.title = title
    args.name = name
    args.include = include
    args.exclude = exclude
    args.show_tags = show_tags
    args.show_test_doc = show_test_doc
    args.show_suite_doc = show_suite_doc
    args.show_source = show_source
    args.show_keywords = show_keywords
    args.config_file = configfile
    args.verbose_mode = verbose
    
    TestDoc().main()

    


if __name__ == "__main__":
    main()
