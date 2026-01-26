import os
from pathlib import Path
import shutil
from click.testing import CliRunner
from testdoc.cli import main

def test_cli_cmd_mkdocs_performance():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "performance", "tests")
    output = os.path.join(parent_dir, "mkdocs_test_perf")
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()
    result = runner.invoke(main, ["--mkdocs", robot, output])
    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))
