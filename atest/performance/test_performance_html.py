import os
from pathlib import Path
import time
from click.testing import CliRunner
from testdoc.cli import main

# Baseline: ~10s locally for ~900 suites (classic single-file HTML, no mkdocs build involved).
MAX_DURATION_SECONDS = 60

def test_cli_cmd_html_performance():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "performance", "tests")
    output = os.path.join(parent_dir, "testdoc_output_perf.html")
    runner = CliRunner()

    t0 = time.time()
    result = runner.invoke(main, [robot, output])
    duration = time.time() - t0

    assert result.exit_code == 0, result.output
    assert "Generated" in result.output
    assert os.path.exists(output)
    assert duration < MAX_DURATION_SECONDS, f"HTML generation took {duration:.1f}s, expected < {MAX_DURATION_SECONDS}s"
