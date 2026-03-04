import json
from pathlib import Path

from testdoc.parser.testcaseparser import TestCaseParser


def define_env(env):
    data_file = Path(__file__).parent / "suites.json"
    env.variables["suites"] = json.loads(data_file.read_text(encoding="utf-8"))

    env.filters["format_test_body"] = TestCaseParser()._keyword_parser
