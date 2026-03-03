import click

from .testdoc import TestDoc
from .helper.cliargs import CommandLineArguments

CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])
@click.command(context_settings=CONTEXT_SETTINGS)
@click.option("-t","--title",       required=False, help="Modify the title of the test documentation page")
@click.option("-n","--name",        required=False, help="Modify the name of the root suite element")
@click.option("-d","--doc",         required=False, help="Modify the documentation of the root suite element")
@click.option("-m","--metadata",    multiple=True, required=False, help="Modify the metadata of the root suite element")
@click.option("-s","--sourceprefix",required=False, help=(
    "Set a prefix used for Test Suite / Test Suite Source Information, e.g. GitLab Prefix Path to navigate directly to your repository!"
))
@click.option("--custom-jinja-template", required=False, help="Define your own Jinja2 HTML template for your own customized visualization")
@click.option("--mkdocs",           is_flag=True, required=False, help=(
    "If given, testdoc will render the test documentation as mkdocs object. <OUTPUT> argument must be a path object - not file!"
))
@click.option("--mkdocs-template-dir",  required=False, help=(
    "Path to your customized mkdocs template - if not defined, internal default mkdocs template is used!"
))
@click.option("-i","--include",     multiple=True, required=False, help="Include test cases with given tags")
@click.option("-e","--exclude",     multiple=True, required=False, help="Exclude test cases with given tags")
@click.option("-c", "--configfile", required=False, help="Optional .toml configuration file (includes all cmd-args)")
@click.option("-v", "--verbose",    is_flag=True, required=False, help="More precise debugging into shell")
@click.version_option(package_name='robotframework-testdoc')
@click.argument("PATH", nargs=-1, required=True)
@click.argument("OUTPUT")
def main(
        title,
        name,
        doc,
        metadata,
        sourceprefix,
        custom_jinja_template,
        mkdocs,
        mkdocs_template_dir,
        include,
        exclude,
        configfile,
        verbose,
        path,
        output,
    ):
    """Welcome to robotframework-testdoc - the new test documentation generator for your Robot Framework tests!

# Basic Usage:
$ testdoc tests/ TestDocumentation.html

See more in the README.md of the GitHub Project: https://github.com/MarvKler/robotframework-testdoc/blob/main/README.md
    """
    color = "green"
    entrypoint_msg = """
████████╗███████╗███████╗████████╗██████╗ ███████╗███████╗
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██   ██╗██   ██║██╔════╝
   ██║   █████╗  ███████╗   ██║   ██   ██║██   ██║██║     
   ██║   ██╔══╝  ╚════██║   ██║   ██   ██║██   ██║██║       
   ██║   ███████╗███████║   ██║   ██████╔╝███████║███████╗
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝  
      """
    click.echo(click.style(entrypoint_msg, fg=color)
    )

    args_to_set = dict(
        title=title,
        name=name,
        doc=doc,
        metadata=dict(item.split("=", 1) for item in metadata) if metadata else None,
        sourceprefix=sourceprefix,
        custom_jinja_template=custom_jinja_template,
        mkdocs_usage=mkdocs,
        mkdocs_template_dir=mkdocs_template_dir,
        include=list(include),
        exclude=list(exclude),
        config_file=configfile,
        verbose_mode=verbose,
        suite_file=list(path),
        output_file=output,
    )

    # Expose CLI args
    args_to_set = {k: v for k, v in args_to_set.items() if v is not None}
    CommandLineArguments().set_args(**args_to_set)

    # Read & expose TOML args
    if configfile:
        from .helper.toml_reader import TOMLReader
        TOMLReader().load_from_config_file(configfile)

    TestDoc().main()

if __name__ == "__main__":
    main()
