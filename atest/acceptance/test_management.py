from datetime import timedelta
from pathlib import Path
from types import SimpleNamespace

from testdoc.management.database import ResultDatabase
from testdoc.management.mapper import ManagementMapper
from testdoc.management.models import TestResultEntry as ResultEntry
from testdoc.management.result_parser import _ResultCollector
from testdoc.management.result_parser import TestResultRecord as ResultRecord
from testdoc.management.webapp import ManagementWebRenderer
from testdoc.parser.models import CustomTestCase, CustomTestSuite


def _test_case(test_id: str = "s1-s1-t1", name: str = "Original Test") -> CustomTestCase:
    return CustomTestCase(id=test_id, name=name, source="tests/example.robot", body=[])


def _suite(test_case: CustomTestCase) -> CustomTestSuite:
    return CustomTestSuite(
        id="s1",
        name="Renamed Root",
        is_folder=False,
        source="tests/example.robot",
        metadata={},
        type="suite",
        tests=[test_case],
    )


def test_mapper_uses_stable_source_and_test_id_key():
    test_case = _test_case()
    suite = _suite(test_case)
    history = {
        f"{Path('tests/example.robot').resolve()}::t1": [
            ResultEntry(
                run_id=1,
                recorded_at="2026-01-01T00:00:00+00:00",
                status="PASS",
                message="",
                start_time=None,
                elapsed_time=0.1,
            )
        ]
    }

    mapped = ManagementMapper().build(suite, history)

    assert mapped.tests[0].latest_status == "PASS"


def test_database_does_not_store_identical_report_twice(tmp_path):
    report_file = tmp_path / "output.xml"
    report_file.write_text("same report", encoding="utf-8")
    database = ResultDatabase(str(tmp_path / "history.db"))
    record = ResultRecord(
        full_name="Root.Test",
        test_key="/tmp/example.robot::t1",
        status="PASS",
        message="",
        start_time=None,
        elapsed_time=0.1,
    )

    database.initialize()

    assert database.store_run(str(report_file), [record]) is True
    assert database.store_run(str(report_file), [record]) is False
    assert len(database.get_history_by_test()[record.test_key]) == 1


def test_result_collector_reads_current_timing_attributes():
    test = SimpleNamespace(
        longname="Root.Test",
        source="tests/example.robot",
        id="s1-t1",
        status="PASS",
        message="",
        start_time="2026-01-01 00:00:00",
        elapsed_time=timedelta(seconds=1.5),
    )

    collector = _ResultCollector()
    collector.visit_test(test)

    assert collector.records[0].start_time == "2026-01-01 00:00:00"
    assert collector.records[0].elapsed_time == 1.5


def test_result_collector_reads_legacy_timing_attributes():
    test = SimpleNamespace(
        longname="Root.Test",
        source="tests/example.robot",
        id="s1-t1",
        status="PASS",
        message="",
        starttime="2026-01-01 00:00:00",
        elapsedtime=1500,
    )

    collector = _ResultCollector()
    collector.visit_test(test)

    assert collector.records[0].start_time == "2026-01-01 00:00:00"
    assert collector.records[0].elapsed_time == 1.5


def test_web_renderer_can_render_documentation_without_result_history(tmp_path):
    output_file = ManagementWebRenderer().render_documentation(_suite(_test_case()), tmp_path / "documentation")

    html = output_file.read_text(encoding="utf-8")

    assert output_file.name == "index.html"
    assert 'data-page="repository"' in html
    assert 'data-page="history"' not in html
    assert '"show_history": false' in html
