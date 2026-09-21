from __future__ import annotations

import sqlite3
from contextlib import closing
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path

from .models import TestResultEntry
from .result_parser import TestResultRecord

_SCHEMA = """
CREATE TABLE IF NOT EXISTS runs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recorded_at TEXT NOT NULL,
    report_file TEXT,
    report_hash TEXT
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
            self._migrate_schema(conn)

    def _migrate_schema(self, conn: sqlite3.Connection) -> None:
        result_columns = {row[1] for row in conn.execute("PRAGMA table_info(test_results)")}
        if "test_key" not in result_columns:
            conn.execute("ALTER TABLE test_results ADD COLUMN test_key TEXT")
            conn.execute("UPDATE test_results SET test_key = test_full_name WHERE test_key IS NULL")

        run_columns = {row[1] for row in conn.execute("PRAGMA table_info(runs)")}
        if "report_hash" not in run_columns:
            conn.execute("ALTER TABLE runs ADD COLUMN report_hash TEXT")

    def store_run(self, report_file: str, records: list[TestResultRecord]) -> bool:
        recorded_at = datetime.now(timezone.utc).isoformat()
        report_hash = sha256(Path(report_file).read_bytes()).hexdigest()
        with closing(self._connect()) as conn, conn:
            duplicate = conn.execute(
                "SELECT 1 FROM runs WHERE report_file = ? AND report_hash = ? LIMIT 1",
                (str(report_file), report_hash),
            ).fetchone()
            if duplicate:
                return False
            self._insert_run(conn, report_file, report_hash, recorded_at, records)
        return True

    def _insert_run(
        self,
        conn: sqlite3.Connection,
        report_file: str,
        report_hash: str,
        recorded_at: str,
        records: list[TestResultRecord],
    ) -> None:
        cursor = conn.execute(
            "INSERT INTO runs (recorded_at, report_file, report_hash) VALUES (?, ?, ?)",
            (recorded_at, str(report_file), report_hash),
        )
        run_id = cursor.lastrowid
        conn.executemany(
            """
            INSERT INTO test_results (run_id, test_full_name, test_key, status, message, start_time, elapsed_time)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            [
                (run_id, record.full_name, record.test_key, record.status, record.message, record.start_time, record.elapsed_time)
                for record in records
            ],
        )

    def get_history_by_test(self) -> dict[str, list[TestResultEntry]]:
        with closing(self._connect()) as conn:
            rows = conn.execute(
                """
                SELECT COALESCE(test_results.test_key, test_results.test_full_name) AS test_key,
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
            entry = self._history_entry(row)
            history.setdefault(row["test_key"], []).append(entry)
        return history

    def _history_entry(self, row: sqlite3.Row) -> TestResultEntry:
        return TestResultEntry(
            run_id=row["run_id"],
            recorded_at=row["recorded_at"],
            status=row["status"],
            message=row["message"] or "",
            start_time=row["start_time"],
            elapsed_time=row["elapsed_time"],
        )

    def _connect(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self._database_file)
        conn.row_factory = sqlite3.Row
        return conn
