import os
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
    output = os.path.join(current_dir, "output.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output.html" in result.output
    assert os.path.exists(output)


def test_cli_cmd_verbose():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    robot = os.path.join(current_dir, "test_cli.robot")
    output = os.path.join(current_dir, "output.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output, "-v"])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output.html" in result.output
    assert "test_cli.robot" in result.output
    assert os.path.exists(output)
