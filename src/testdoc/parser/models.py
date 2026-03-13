from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class CustomTestSuite:
    id: str
    name: str
    is_folder: bool
    source: str
    metadata: dict | None
    type: str

    doc: str | None = None
    custom_source: str | None = None
    test_count: int = 0
    tests: list[CustomTestCase] = field(default_factory=list)
    suites: list[CustomTestSuite] = field(default_factory=list)
    user_keywords: list[str] = field(default_factory=list)


@dataclass
class CustomTestCase:
    id: str
    name: str
    source: str
    body: list[CustomTestCaseBody]

    doc: str | None = None
    custom_source: str | None = None
    tags: list[str] | None = field(default_factory=list)
    setup: CustomTestCaseBody | None = None
    teardown: CustomTestCaseBody | None = None


@dataclass
class CustomTestCaseBody:
    id: str
    type: str
    name: str
    args: list | None = field(default_factory=list)
    flavor: str | None = ""
    value: list | None = field(default_factory=list)
    values: list | None = field(default_factory=list)
    condition: str | None = ""
    patterns: list | None = field(default_factory=list)
    assign: list | None = field(default_factory=list)
    body: list[CustomTestCaseBody] = field(default_factory=list)
