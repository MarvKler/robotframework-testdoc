from __future__ import annotations

import sqlite3
from contextlib import closing
from datetime import datetime, timezone
from pathlib import Path

from .models import TestResultEntry
from .result_parser import TestResultRecord

_SCHEMA = """
CREATE TABLE IF NOT EXISTS runs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recorded_at TEXT NOT NULL,
    report_file TEXT
);

CREATE TABLE IF NOT EXISTS test_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id INTEGER NOT NULL REFERENCES runs(id),
    test_full_name TEXT NOT NULL,
    status TEXT NOT NULL,
    message TEXT,
    start_time TEXT,
    elapsed_time REAL NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_test_results_full_name ON test_results(test_full_name);
"""


class ResultDatabase:
    """SQLite-backed persistence for test execution history.

    This is the single source of truth for the result history - the caller must reuse the
    same database file across invocations to keep the history intact.
    """

    def __init__(self, database_file: str) -> None:
        self._database_file = Path(database_file)

    def initialize(self) -> None:
        self._database_file.parent.mkdir(parents=True, exist_ok=True)
        with closing(self._connect()) as conn, conn:
            conn.executescript(_SCHEMA)

    def store_run(self, report_file: str, records: list[TestResultRecord]) -> None:
        recorded_at = datetime.now(timezone.utc).isoformat()
        with closing(self._connect()) as conn, conn:
            cursor = conn.execute(
                "INSERT INTO runs (recorded_at, report_file) VALUES (?, ?)",
                (recorded_at, str(report_file)),
            )
            run_id = cursor.lastrowid
            conn.executemany(
                """
                INSERT INTO test_results (run_id, test_full_name, status, message, start_time, elapsed_time)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                [(run_id, record.full_name, record.status, record.message, record.start_time, record.elapsed_time) for record in records],
            )

    def get_history_by_test(self) -> dict[str, list[TestResultEntry]]:
        with closing(self._connect()) as conn:
            rows = conn.execute(
                """
                SELECT test_results.test_full_name AS test_full_name,
                       test_results.run_id AS run_id,
                       runs.recorded_at AS recorded_at,
                       test_results.status AS status,
                       test_results.message AS message,
                       test_results.start_time AS start_time,
                       test_results.elapsed_time AS elapsed_time
                FROM test_results
                JOIN runs ON runs.id = test_results.run_id
                ORDER BY test_results.run_id ASC
                """
            ).fetchall()

        history: dict[str, list[TestResultEntry]] = {}
        for row in rows:
            entry = TestResultEntry(
                run_id=row["run_id"],
                recorded_at=row["recorded_at"],
                status=row["status"],
                message=row["message"] or "",
                start_time=row["start_time"],
                elapsed_time=row["elapsed_time"],
            )
            history.setdefault(row["test_full_name"], []).append(entry)
        return history

    def _connect(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self._database_file)
        conn.row_factory = sqlite3.Row
        return conn
