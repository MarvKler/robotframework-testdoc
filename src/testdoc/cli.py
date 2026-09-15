from pathlib import Path

import click

from .helper.cliargs import CommandLineArguments
from .helper.toml_reader import TOMLReader
from .testdoc import TestDoc

CONTEXT_SETTINGS = {"help_option_names": ["-h", "--help"]}

ENTRYPOINT_MSG = """
████████╗███████╗███████╗████████╗██████╗ ███████╗███████╗
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██   ██╗██   ██║██╔════╝
   ██║   █████╗  ███████╗   ██║   ██   ██║██   ██║██║
   ██║   ██╔══╝  ╚════██║   ██║   ██   ██║██   ██║██║
   ██║   ███████╗███████║   ██║   ██████╔╝███████║███████╗
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═════╝ ╚══════╝ ╚═════╝
      """


class DefaultCommandGroup(click.Group):
    """Group that falls back to `default_command` when the first arg is not a known subcommand.

    This keeps the legacy `testdoc PATH OUTPUT [OPTIONS]` invocation working unchanged.
    """

    def __init__(self, *args, default_command=None, **kwargs):
        self.default_command = default_command
        super().__init__(*args, **kwargs)

    def parse_args(self, ctx, args):
        # Options for the default command (e.g. "-f pdf tests/ out.pdf") must not be
        # swallowed by the group's own option parsing - inject the default command name
        # unless the first token is already a known subcommand or a group-level flag.
        if self.default_command is not None and args and args[0] not in self.commands and args[0] not in ("-h", "--help", "--version"):
            args = [self.default_command, *args]
        return super().parse_args(ctx, args)

    def resolve_command(self, ctx, args):
        try:
            return super().resolve_command(ctx, args)
        except click.UsageError:
            if self.default_command is None:
                raise
            return super().resolve_command(ctx, [self.default_command, *args])


def common_options(f):
    """Shared options/arguments used by both the default `generate` command and `management`."""
    f = click.argument("OUTPUT")(f)
    f = click.argument("PATH", nargs=-1, required=True)(f)
    f = click.option("-c", "--configfile", required=False, help="Optional .toml configuration file (includes all cmd-args)")(f)
    f = click.option(
        "-f",
        "--output-format",
        type=click.Choice(["html", "json", "pdf"], case_sensitive=False),
        default="html",
        show_default=True,
        help="Output format for the test documentation",
    )(f)
    f = click.option("-e", "--exclude", multiple=True, required=False, help="Exclude test cases with given tags")(f)
    f = click.option("-i", "--include", multiple=True, required=False, help="Include test cases with given tags")(f)
    f = click.option(
        "--mkdocs-template-dir",
        required=False,
        help=("Path to your customized mkdocs template - if not defined, internal default mkdocs template is used!"),
    )(f)
    f = click.option(
        "--mkdocs",
        is_flag=True,
        required=False,
        help=("If given, testdoc will render the test documentation as mkdocs object. <OUTPUT> argument must be a path object - not file!"),
    )(f)
    f = click.option(
        "--custom-pdf-template",
        required=False,
        help="Define your own Jinja2 HTML template for PDF overview/suite pages",
    )(f)
    f = click.option("--custom-jinja-template", required=False, help="Define your own Jinja2 HTML template for your own customized visualization")(f)
    f = click.option(
        "-s",
        "--sourceprefix",
        required=False,
        help=("Set a prefix used for Test Suite / Test Suite Source Information, e.g. GitLab Prefix Path to navigate directly to your repository!"),
    )(f)
    f = click.option("-m", "--metadata", multiple=True, required=False, help="Modify the metadata of the root suite element")(f)
    f = click.option("-d", "--doc", required=False, help="Modify the documentation of the root suite element")(f)
    f = click.option("-n", "--name", required=False, help="Modify the name of the root suite element")(f)
    f = click.option("-t", "--title", required=False, help="Modify the title of the test documentation page")(f)
    f = click.option("-v", "--verbose", is_flag=True, required=False, help="More precise debugging into shell")(f)
    return f  # noqa: RET504


def _collect_common_args(  # noqa
    title,
    name,
    doc,
    metadata,
    sourceprefix,
    custom_jinja_template,
    custom_pdf_template,
    mkdocs,
    mkdocs_template_dir,
    include,
    exclude,
    output_format,
    configfile,
    verbose,
    path,
    output,
):
    return {
        "title": title,
        "name": name,
        "doc": doc,
        "metadata": dict(item.split("=", 1) for item in metadata) if metadata else None,
        "sourceprefix": sourceprefix,
        "custom_jinja_template": custom_jinja_template,
        "custom_pdf_template": custom_pdf_template,
        "mkdocs_usage": mkdocs,
        "mkdocs_template_dir": mkdocs_template_dir,
        "include": list(include),
        "exclude": list(exclude),
        "output_format": output_format,
        "config_file": configfile,
        "verbose_mode": verbose,
        "suite_file": list(path),
        "output_file": output,
    }


def _run_testdoc(args_to_set: dict, configfile):
    # Expose CLI args
    args_to_set = {k: v for k, v in args_to_set.items() if v is not None}
    CommandLineArguments().set_args(**args_to_set)

    # Read & expose TOML args
    if configfile:
        TOMLReader().load_from_config_file(Path(configfile))

    TestDoc().main()


@click.group(cls=DefaultCommandGroup, default_command="generate", context_settings=CONTEXT_SETTINGS)
@click.version_option(package_name="robotframework-testdoc")
def main():
    """Welcome to robotframework-testdoc - the new test documentation generator for your Robot Framework tests!

    # Basic Usage:
    $ testdoc tests/ TestDocumentation.html

    See more in the README.md of the GitHub Project: https://github.com/MarvKler/robotframework-testdoc/blob/main/README.md
    """


@main.command("generate")
@common_options
def generate(  # noqa
    title,
    name,
    doc,
    metadata,
    sourceprefix,
    custom_jinja_template,
    custom_pdf_template,
    mkdocs,
    mkdocs_template_dir,
    include,
    exclude,
    output_format,
    configfile,
    verbose,
    path,
    output,
):
    """Generate the test documentation (default command, e.g. `testdoc tests/ TestDocumentation.html`)."""
    click.echo(click.style(ENTRYPOINT_MSG, fg="green"))

    args_to_set = _collect_common_args(
        title,
        name,
        doc,
        metadata,
        sourceprefix,
        custom_jinja_template,
        custom_pdf_template,
        mkdocs,
        mkdocs_template_dir,
        include,
        exclude,
        output_format,
        configfile,
        verbose,
        path,
        output,
    )
    _run_testdoc(args_to_set, configfile)


@main.command("management")
@common_options
@click.option("--report-file", required=True, help="Path to the Robot Framework output.xml to include in the management report")
@click.option("--database-file", required=True, help="Path to the database file used to store the management results")
def management(  # noqa
    title,
    name,
    doc,
    metadata,
    sourceprefix,
    custom_jinja_template,
    custom_pdf_template,
    mkdocs,
    mkdocs_template_dir,
    include,
    exclude,
    output_format,
    configfile,
    verbose,
    path,
    output,
    report_file,
    database_file,
):
    """Generate the test documentation and additionally process management data from a Robot Framework run."""
    click.echo(click.style(ENTRYPOINT_MSG, fg="green"))

    args_to_set = _collect_common_args(
        title,
        name,
        doc,
        metadata,
        sourceprefix,
        custom_jinja_template,
        custom_pdf_template,
        mkdocs,
        mkdocs_template_dir,
        include,
        exclude,
        output_format,
        configfile,
        verbose,
        path,
        output,
    )
    args_to_set["report_file"] = report_file
    args_to_set["database_file"] = database_file
    _run_testdoc(args_to_set, configfile)

    # TODO: implement management-specific logic (parse report_file / persist into database_file)


if __name__ == "__main__":
    main()
