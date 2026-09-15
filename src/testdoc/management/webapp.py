from __future__ import annotations

import dataclasses
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path

from jinja2 import Environment, FileSystemLoader, select_autoescape

from .models import ManagementSuite, ManagementTestCase

_TEMPLATE_DIR = Path(__file__).parent / "templates"


def _serialize_test(management_test: ManagementTestCase) -> dict:
    return {
        "full_name": management_test.full_name,
        "latest_status": management_test.latest_status,
        "history": [dataclasses.asdict(entry) for entry in management_test.history],
        "test_case": dataclasses.asdict(management_test.test_case),
    }


def _serialize_suite(management_suite: ManagementSuite) -> dict:
    suite_dict = dataclasses.asdict(management_suite.suite)
    # Nested raw tests/suites are already represented via the management tests/suites below.
    suite_dict.pop("tests", None)
    suite_dict.pop("suites", None)

    return {
        "full_name": management_suite.full_name,
        "test_count": management_suite.test_count,
        "suite": suite_dict,
        "tests": [_serialize_test(test) for test in management_suite.tests],
        "suites": [_serialize_suite(sub_suite) for sub_suite in management_suite.suites],
    }


class ManagementWebRenderer:
    """Renders the management dashboard as a static, dependency-free HTML/CSS/JS web app."""

    def render(self, management_suite: ManagementSuite, output_dir: Path) -> Path:
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        data = {
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "root": _serialize_suite(management_suite),
        }
        # Escape "</" so the embedded JSON cannot break out of the <script> tag it lives in.
        data_json = json.dumps(data).replace("</", "<\\/")

        env = Environment(loader=FileSystemLoader(str(_TEMPLATE_DIR)), autoescape=select_autoescape(["html"]))
        template = env.get_template("index.html")
        index_html = template.render(data_json=data_json)

        (output_dir / "index.html").write_text(index_html, encoding="utf-8")
        shutil.copyfile(_TEMPLATE_DIR / "styles.css", output_dir / "styles.css")
        shutil.copyfile(_TEMPLATE_DIR / "app.js", output_dir / "app.js")

        return output_dir / "index.html"
