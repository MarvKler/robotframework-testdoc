from pathlib import Path

from robot.running import TestSuiteBuilder as RobotSuiteBuilder

from testdoc.parser.testsuiteparser import RobotSuiteParser


def _find_test_by_name(suite, test_name: str):
    for test in suite.tests:
        if test.name == test_name:
            return test
    for child in suite.suites:
        found = _find_test_by_name(child, test_name)
        if found:
            return found
    return None


def test_keyword_documentation_is_resolved_for_library_keyword():
    suite_path = Path(__file__).parent.parent / "testdata" / "acceptance" / "testcases" / "component_a" / "suite_a.robot"
    suite = RobotSuiteBuilder(process_curdir=False).build(str(suite_path))

    parsed_suite = RobotSuiteParser().get_customized_suite_model(suite)

    test = _find_test_by_name(parsed_suite, "Suite A - TC-001 - ${SUITE_VAR}")
    assert test is not None

    log_keyword = next((item for item in test.body if item.type == "KEYWORD" and item.name == "Log"), None)
    assert log_keyword is not None
    assert log_keyword.keyword_owner == "BuiltIn"
    assert log_keyword.keyword_doc is not None
    assert "Logs the given message" in log_keyword.keyword_doc


def test_keyword_documentation_is_resolved_for_local_user_keyword():
    suite_path = Path(__file__).parent.parent / "testdata" / "acceptance" / "testcases" / "component_a" / "suite_a.robot"
    suite = RobotSuiteBuilder(process_curdir=False).build(str(suite_path))

    parsed_suite = RobotSuiteParser().get_customized_suite_model(suite)

    test = _find_test_by_name(parsed_suite, "Suite A - TC-001 - ${SUITE_VAR}")
    assert test is not None

    user_keyword = next((item for item in test.body if item.type == "KEYWORD" and item.name == "Suite A - User Keyword A"), None)
    assert user_keyword is not None
    assert user_keyword.keyword_doc is not None
    assert "docs" in user_keyword.keyword_doc


def test_keyword_documentation_is_resolved_for_test_setup():
    suite_path = Path(__file__).parent.parent / "testdata" / "acceptance" / "testcases" / "component_a" / "suite_a.robot"
    suite = RobotSuiteBuilder(process_curdir=False).build(str(suite_path))

    parsed_suite = RobotSuiteParser().get_customized_suite_model(suite)

    test = _find_test_by_name(parsed_suite, "Suite A - TC-001 - ${SUITE_VAR}")
    assert test is not None
    assert test.setup is not None
    assert test.setup.keyword_owner == "BuiltIn"
    assert test.setup.keyword_doc is not None
    assert "Logs the given message" in test.setup.keyword_doc


def test_keyword_documentation_is_resolved_for_aliased_python_library_keyword():
    suite_path = Path(__file__).parent.parent / "testdata" / "acceptance" / "testcases" / "component_a" / "suite_a.robot"
    suite = RobotSuiteBuilder(process_curdir=False).build(str(suite_path))

    parsed_suite = RobotSuiteParser().get_customized_suite_model(suite)

    test = _find_test_by_name(parsed_suite, "Suite A - Custom Python Library")
    assert test is not None

    custom_keyword = next((item for item in test.body if item.type == "KEYWORD" and item.name == "MyLib.My Keyword"), None)
    assert custom_keyword is not None
    assert custom_keyword.keyword_owner == "MyLib"
    assert custom_keyword.keyword_doc is not None
    assert "Keyword in my custom python keyword library." in custom_keyword.keyword_doc
