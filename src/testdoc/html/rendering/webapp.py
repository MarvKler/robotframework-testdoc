from __future__ import annotations

import dataclasses
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from jinja2 import Environment, FileSystemLoader, select_autoescape

from ...parser.testcaseparser import TestCaseParser
from .jinja2_support.lexer_support import highlight_robot_in_pre

_TEMPLATE_DIR = Path(__file__).parent.parent / ".." / "management" / "templates"


def _serialize_test(management_test: Any) -> dict:
    test_case = dataclasses.asdict(management_test.test_case)
    step_lines = TestCaseParser()._keyword_parser(management_test.test_case.body) if management_test.test_case.body else []
    step_code = "\n".join(step_lines) if step_lines else ""
    return {
        "full_name": management_test.full_name,
        "latest_status": management_test.latest_status,
        "history": [dataclasses.asdict(entry) for entry in management_test.history],
        "test_case": test_case,
        "steps_html": highlight_robot_in_pre(step_code) if step_code else "",
    }


def _serialize_suite_metadata(management_suite: Any) -> dict:
    suite_dict = dataclasses.asdict(management_suite.suite)
    suite_dict.pop("tests", None)
    suite_dict.pop("suites", None)
    return suite_dict


def _serialize_suite(management_suite: Any) -> dict:
    return {
        "full_name": management_suite.full_name,
        "test_count": management_suite.test_count,
        "suite": _serialize_suite_metadata(management_suite),
        "tests": [_serialize_test(test) for test in management_suite.tests],
        "suites": [_serialize_suite(sub_suite) for sub_suite in management_suite.suites],
    }


class TestDocWebRenderer:
    """Render the shared static web application for documentation and management."""

    def render(self, management_suite: Any, output_dir: Path, show_history: bool = True) -> Path:
        return self._render(management_suite, output_dir, show_history)

    def _render(self, management_suite: Any, output_dir: Path, show_history: bool) -> Path:
        output_path = Path(output_dir)
        if output_path.suffix:
            if output_path.is_dir():
                shutil.rmtree(output_path)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            html_file = output_path
            asset_dir = output_path.parent
        else:
            if output_path.is_file():
                output_path.unlink()
            output_path.mkdir(parents=True, exist_ok=True)
            html_file = output_path / "index.html"
            asset_dir = output_path

        data = {
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "root": _serialize_suite(management_suite),
            "show_history": show_history,
        }
        data_json = json.dumps(data).replace("</", "<\\/")

        env = Environment(loader=FileSystemLoader(str(_TEMPLATE_DIR)), autoescape=select_autoescape(["html"]))
        template = env.get_template("index.html")
        index_html = template.render(data_json=data_json, show_history=show_history)

        html_file.write_text(index_html, encoding="utf-8")
        shutil.copyfile(_TEMPLATE_DIR / "styles.css", asset_dir / "styles.css")
        shutil.copyfile(_TEMPLATE_DIR / "app.js", asset_dir / "app.js")

        return html_file
