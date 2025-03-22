import click

from .testdoc import TestDoc
from .helper.cliargs import CommandLineArguments

@click.command()
@click.option("-t","--title",       required=False, help="Modify the title of the test documentation")
@click.option("-n","--name",        required=False, help="Modify the name of the root suite element")
@click.option("-d","--doc",         required=False, help="Modify the documentation of the root suite element")
@click.option("-m","--metadata",    multiple=True, required=False, help="Modify the metadata of the root suite element")
@click.option("-s","--sourceprefix",required=False, help="Set a prefix used for Test Suite / Test Suite Source Information, e.g. GitLab Prefix Path to navigate directly to your repository!")
@click.option("-i","--include",     multiple=True, required=False, help="Include only test cases with given tags")
@click.option("-e","--exclude",     multiple=True, required=False, help="Exclude test cases with given tags")
@click.option("--hide-tags",        is_flag=True, required=False, help="If given, related tags for each test case are hidden")
@click.option("--hide-test-doc",    is_flag=True,required=False, help="If given, test documentation is hidden")
@click.option("--hide-suite-doc",   is_flag=True, required=False, help="If given, suite documentation is hidden")
@click.option("--hide-source",      is_flag=True, required=False, help="If given, test suite/case source is hidden")
@click.option("--hide-keywords",    is_flag=True, required=False, help="If given, keyword calls are hidden")
@click.option("-c", "--configfile", is_flag=True, required=False, help="Optional configuration file (includes all cmd-args)")
@click.option("-v", "--verbose",    is_flag=True, required=False, help="More precise debugging")
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
        configfile,
        verbose,
        path,
        output,
    ):
    """
    Welcome to robotframework-testdoc - the new test documentation generator for your Robot Framework tests!
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
    args.title = title
    args.name = name
    args.doc = doc
    args.metadata = dict(item.split("=", 1) for item in metadata)
    args.sourceprefix = sourceprefix
    args.include = list(include)
    args.exclude = list(exclude)
    args.hide_tags = hide_tags
    args.hide_test_doc = hide_test_doc
    args.hide_suite_doc = hide_suite_doc
    args.hide_source = hide_source
    args.hide_keywords = hide_keywords
    args.config_file = configfile
    args.verbose_mode = verbose
    args.suite_file = path
    args.output_file = output
    
    TestDoc().main()

if __name__ == "__main__":
    main()
