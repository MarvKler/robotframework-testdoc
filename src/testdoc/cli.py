import click
import os

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
@click.option("-i","--include",     multiple=True, required=False, help="Include test cases with given tags")
@click.option("-e","--exclude",     multiple=True, required=False, help="Exclude test cases with given tags")
@click.option("--hide-tags",        is_flag=True, required=False, help="If given, test case tags are hidden")
@click.option("--hide-test-doc",    is_flag=True,required=False, help="If given, test documentation is hidden")
@click.option("--hide-suite-doc",   is_flag=True, required=False, help="If given, suite documentation is hidden")
@click.option("--hide-source",      is_flag=True, required=False, help="If given, test suite/ test case source is hidden")
@click.option("--hide-keywords",    is_flag=True, required=False, help="If given, keyword calls in test cases are hidden")
@click.option("-S", "--style", required=False, help="Choose a predefined default style theme - 'default', 'robot', 'dark' or 'blue' ")
@click.option("-ht","--html-template", required=False, help="Select the HTML template - possible values: 'v1', 'v2'")
@click.option("-c", "--configfile", required=False, help="Optional .toml configuration file (includes all cmd-args)")
@click.option("-v", "--verbose",    is_flag=True, required=False, help="More precise debugging into shell")
@click.version_option(package_name='robotframework-testdoc')
@click.argument("PATH")
@click.argument("OUTPUT")
def main(
        title,
        name,
        doc,
        metadata,
        sourceprefix,
        include,
        exclude,
        hide_tags,
        hide_test_doc,
        hide_suite_doc,
        hide_source,
        hide_keywords,
        style,
        html_template,
        configfile,
        verbose,
        path,
        output,
    ):
    """
    Welcome to robotframework-testdoc - the new test documentation generator for your Robot Framework tests!
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

    args_instance = CommandLineArguments()
    if configfile:
        if os.path.exists(configfile):
            args_instance.load_from_config_file(configfile)
        else:
            click.echo(click.style(f"⚠️ Config File not found: {configfile}", fg="yellow"))

    args = args_instance.data
    cli_params = {
        "title": title or None,
        "name": name or None,
        "doc": doc or None,
        "metadata": dict(item.split("=", 1) for item in metadata) if metadata else None,
        "sourceprefix": sourceprefix,
        "include": list(include) if include else None,
        "exclude": list(exclude) if exclude else None,
        "hide_tags": hide_tags or None,
        "hide_test_doc": hide_test_doc or None,
        "hide_suite_doc": hide_suite_doc or None,
        "hide_source": hide_source or None,
        "hide_keywords": hide_keywords or None,
        "verbose_mode": verbose or None,
        "style": style or None,
        "html_template": html_template or None,
        "config_file": configfile or None,
    }
    args.suite_file = path
    args.output_file = output

    for key, value in cli_params.items():
        if value is not None:
            setattr(args, key, value)    
    TestDoc().main()

if __name__ == "__main__":
    main()
