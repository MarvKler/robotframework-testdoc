from pathlib import Path

from robot.running import TestSuiteBuilder as RobotSuiteBuilder

from testdoc.parser.testcaseparser import TestCaseParser
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


def test_control_flow_keywords_are_parsed_and_formatted_from_real_suite():
    """Integration check: FOR/IF/ELSE/WHILE/TRY/EXCEPT/FINALLY parsed from a real .robot file."""
    suite_path = Path(__file__).parent.parent / "testdata" / "acceptance" / "testcases" / "component_a" / "control_flow.robot"
    suite = RobotSuiteBuilder(process_curdir=False).build(str(suite_path))

    parsed_suite = RobotSuiteParser().get_customized_suite_model(suite)
    test = _find_test_by_name(parsed_suite, "Control Flow Demo")
    assert test is not None

    formatted = TestCaseParser()._keyword_parser(test.body)
    formatted_text = "\n".join(formatted)

    for expected in ("FOR", "IF", "ELSE IF", "ELSE", "WHILE", "TRY", "EXCEPT", "FINALLY", "END"):
        assert expected in formatted_text, f"Expected '{expected}' in formatted body:\n{formatted_text}"


def test_handle_keyword_types_break_and_continue():
    body = [
        {"type": "BREAK"},
        {"type": "CONTINUE"},
    ]
    formatted = TestCaseParser()._keyword_parser(body)
    assert formatted == ["BREAK", "CONTINUE"]


def test_handle_keyword_types_return_with_values():
    body = [{"type": "RETURN", "values": ["${result}"]}]
    formatted = TestCaseParser()._keyword_parser(body)
    assert formatted == ["RETURN    ${result}"]


def test_handle_keyword_types_error():
    body = [{"type": "ERROR", "values": ["Something went wrong"]}]
    formatted = TestCaseParser()._keyword_parser(body)
    assert formatted == ["ERROR    Something went wrong"]


def test_handle_keyword_types_var():
    body = [{"type": "VAR", "name": "${x}", "value": ["1"]}]
    formatted = TestCaseParser()._keyword_parser(body)
    assert formatted == ["VAR    ${x} =    1"]


def test_handle_keyword_types_unknown_type_falls_back_to_its_body():
    """Unknown/未 mapped block types (e.g. future RF syntax) should still surface their nested keywords."""
    body = [
        {
            "type": "SOME_FUTURE_BLOCK",
            "body": [{"type": "KEYWORD", "name": "Log", "args": ["nested"]}],
        }
    ]
    formatted = TestCaseParser()._keyword_parser(body)
    assert formatted == ["Log    nested"]


def test_kw_post_processing_drops_redundant_end_before_finally():
    # TRY/EXCEPT/FINALLY blocks are sibling entries, each carrying their own nested body.
    body = [
        {"type": "TRY", "body": [{"type": "KEYWORD", "name": "Log", "args": ["try body"]}]},
        {"type": "EXCEPT", "patterns": ["Some Error"], "body": [{"type": "KEYWORD", "name": "Log", "args": ["handled"]}]},
        {"type": "FINALLY", "body": [{"type": "KEYWORD", "name": "Log", "args": ["cleanup"]}]},
    ]
    formatted = TestCaseParser()._keyword_parser(body)
    # EXCEPT and FINALLY each auto-append an END; the redundant one right before FINALLY must be dropped.
    formatted_text = "\n".join(formatted)
    assert formatted_text.count("END") == 1


def test_keyword_parser_returns_fallback_for_empty_body():
    assert TestCaseParser()._keyword_parser([]) == ["No Keyword Calls in Test"]
