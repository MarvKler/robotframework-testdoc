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
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir, "test_cli.robot")
    output = os.path.join(current_dir, "output_classic.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output_classic.html" in result.output
    assert os.path.exists(output)

def test_cli_cmd_big_suite():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir)
    output = os.path.join(current_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output_big.html" in result.output
    assert os.path.exists(output)

def test_cli_cmd_mkdocs():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir)
    output = os.path.join(current_dir, "mkdocs_test")
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
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir)
    output = os.path.join(current_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "github::https://github.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "github::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_gitlab_prefix():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir)
    output = os.path.join(current_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "gitlab::https://gitlab.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "gitlab::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_mkdocs_custom_template():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir)
    output = os.path.join(current_dir, "mkdocs_test_custom")
    templ_dir = Path(__file__).parent.parent / "examples" / "mkdocs" / "default"
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
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir, "test_cli.robot")
    output = os.path.join(current_dir, "output.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output, "-v"])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output.html" in result.output
    assert "Saving" in result.output
    assert os.path.exists(output)
