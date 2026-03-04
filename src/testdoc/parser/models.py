from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from robot.model.metadata import Metadata
from robot.running.model import Body


@dataclass
class CustomTestCase:
    id: str
    name: str
    source: Path
    body: Body

    doc: str | None = None
    custom_source: str | None = None
    tags: list[str] = field(default_factory=list)


@dataclass
class CustomTestSuite:
    id: str
    name: str
    is_folder: bool
    source: Path
    metadata: Metadata | None
    type: str

    doc: str | None = None
    custom_source: str | None = None
    test_count: int = 0
    tests: list[CustomTestCase] = field(default_factory=list)
    suites: list[CustomTestSuite] = field(default_factory=list)
    user_keywords: list[str] = field(default_factory=list)  # oder eigenes Model