from __future__ import annotations

from pathlib import Path

from ..parser.models import CustomTestCase


def _source_key(source: str | None) -> str:
    if not source:
        return ""
    return str(Path(source).resolve())


def _local_test_id(test_id: str | None) -> str:
    if not test_id:
        return ""
    return test_id.rsplit("-", 1)[-1]


def documentation_test_key(test: CustomTestCase) -> str:
    return f"{_source_key(test.source)}::{_local_test_id(test.id)}"


def result_test_key(source: str | None, test_id: str | None) -> str:
    return f"{_source_key(source)}::{_local_test_id(test_id)}"
