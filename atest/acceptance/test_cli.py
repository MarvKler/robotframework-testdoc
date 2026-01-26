import os
from pathlib import Path
import shutil
from click.testing import CliRunner
from testdoc.cli import main

def test_cli_help():
    runner = CliRunner()
    result = runner.invoke(main, ["--help"])
    assert result.exit_code == 0
    assert "Usage" in result.output
    assert "Welcome" in result.output

def test_cli_cmd():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_classic.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output_classic.html" in result.output
    assert os.path.exists(output)

def test_cli_cmd_mkdocs():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "mkdocs_test")
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()
    result = runner.invoke(main, ["--mkdocs", robot, output])
    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))

def test_cli_cmd_github_prefix():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "github::https://github.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "github::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_gitlab_prefix():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "gitlab::https://gitlab.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "gitlab::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_mkdocs_custom_template():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "mkdocs_test_custom")
    templ_dir = Path(__file__).parent.parent.parent / "src" / "testdoc" / "html" / "templates" / "mkdocs_default"
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()
    result = runner.invoke(main, ["--mkdocs", "--mkdocs-template-dir", templ_dir, robot, output])
    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))


def test_cli_cmd_verbose():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output, "-v"])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output.html" in result.output
    assert "Saving" in result.output
    assert os.path.exists(output)
