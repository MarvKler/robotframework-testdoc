import os
from pathlib import Path
import shutil
import time
from click.testing import CliRunner
from testdoc.cli import main

# Baseline (fixed after a perf regression): ~90s locally for ~900 suites. CI runners are slower,
# so this leaves generous headroom while still catching regressions (previous bug: ~2658s).
MAX_DURATION_SECONDS = 240

def test_cli_cmd_mkdocs_performance():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "performance", "tests")
    output = os.path.join(parent_dir, "mkdocs_test_perf")
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()

    t0 = time.time()
    result = runner.invoke(main, ["--mkdocs", robot, output])
    duration = time.time() - t0

    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))
    assert duration < MAX_DURATION_SECONDS, f"mkdocs generation took {duration:.1f}s, expected < {MAX_DURATION_SECONDS}s"
