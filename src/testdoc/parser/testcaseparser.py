import textwrap
from typing import Any

from robot.api import TestSuite
from robot.running.model import Body

from ..helper.cliargs import CommandLineArguments
from .models import CustomTestCase, CustomTestCaseBody, CustomTestSuite


class TestCaseParser:
    def __init__(self) -> None:
        self.args = CommandLineArguments()

    def parse_test(self, suite: TestSuite, suite_info: CustomTestSuite) -> CustomTestSuite:

        for test in suite.tests:
            test_info: CustomTestCase = CustomTestCase(
                id=test.id,
                name=test.name,
                doc=test.doc,
                tags=list(test.tags) if test.tags else None,
                source=str(test.source),
                body=self.test_body_parser(test.body),
            )
            suite_info.tests.append(test_info)
        return suite_info

    def test_body_parser(self, body: Body) -> list[CustomTestCaseBody]:

        result = []
        for item in body:
            body_item = CustomTestCaseBody(
                id=item.id,
                type=item.type,
                name=item.name if hasattr(item, "name") else item.type,
                args=item.args if hasattr(item, "args") else None,
                value=item.value if hasattr(item, "value") else None,
                values=item.values if hasattr(item, "values") else None,
                condition=item.condition if hasattr(item, "condition") else None,
                assign=item.assign if hasattr(item, "assign") else None,
                flavor=item.flavor if hasattr(item, "flavor") else None,
                patterns=item.patterns if hasattr(item, "patterns") else None,
            )

            if hasattr(item, "body") and item.body:
                body_item.body = self.test_body_parser(item.body)

            result.append(body_item)

        return result

    def _keyword_parser(self, test_body: list[CustomTestCaseBody] | list[dict]):
        """Parse keywords and their child-items"""
        _keyword_object = []
        for kw in test_body:
            _keyword_object.extend(self._handle_keyword_types(kw))

        _keyword_object = self._kw_post_processing(_keyword_object)

        # Fallback in case of no keywords
        if len(_keyword_object) == 0:
            return ["No Keyword Calls in Test"]
        return _keyword_object

    def _handle_keyword_types(self, kw: CustomTestCaseBody | dict, indent: int = 0):  # noqa
        """Handle different keyword types"""
        result = []
        kw_type = self._get_value(kw, "type", None)

        _sd = "    "  # classic rfw delimiter with 4 spaces
        _indent = _sd * indent

        # Classic keyword
        if kw_type == "KEYWORD" and self._get_value(kw, "name", None):
            args = _sd.join(self._get_value(kw, "args", [])) if self._get_value(kw, "args", None) else ""
            entry = _indent + self._get_value(kw, "name", "")
            if args:
                entry += _sd + args
            wrapped = textwrap.wrap(entry, width=200, subsequent_indent=_indent + "..." + _sd)
            result.extend(wrapped)

        # VAR syntax
        elif kw_type == "VAR" and self._get_value(kw, "name", None):
            value = _sd.join(self._get_value(kw, "value", [])) if self._get_value(kw, "value", None) else ""
            result.append(f"{_indent}VAR    {self._get_value(kw, 'name', '')} =    {value}")

        # IF/ELSE/ELSE IF
        elif kw_type == "IF/ELSE ROOT":
            for branch in self._get_value(kw, "body", []):
                branch_type = self._get_value(branch, "type", None)
                if branch_type == "IF":
                    header = f"{_indent}IF{_sd}{self._get_value(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE IF":
                    header = f"{_indent}ELSE IF{_sd}{self._get_value(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE":
                    header = f"{_indent}ELSE"
                else:
                    header = f"{_indent}{branch_type or ''}"
                if header:
                    result.append(header)
                for subkw in self._get_value(branch, "body", []):
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # FOR loop
        elif kw_type == "FOR":
            header = f"{_indent}FOR"
            assign = self._get_value(kw, "assign", [])
            if self._get_value(kw, "assign") and assign:
                header += f"    {'    '.join(assign)}"
            flavor = self._get_value(kw, "flavor", "")
            if self._get_value(kw, "flavor") and flavor:
                header += f"    {flavor}"
            else:
                header += "    IN"
            values = self._get_value(kw, "values", [])
            if self._get_value(kw, "values") and values:
                header += f"    {'    '.join(values)}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # GROUP loop
        elif kw_type == "GROUP":
            header = f"{_indent}GROUP"
            name = self._get_value(kw, "name", "")
            if name != "":
                header += f"{_sd}{name}"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # WHILE loop
        elif kw_type == "WHILE":
            header = f"{_indent}WHILE"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # TRY/EXCEPT/FINALLY
        elif kw_type in ("TRY", "EXCEPT", "FINALLY"):
            header = f"{_indent}{kw_type}"
            patterns = self._get_value(kw, "patterns", [])
            if self._get_value(kw, "patterns") and patterns:
                header += f"    {'    '.join(patterns)}"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            if kw_type in ("EXCEPT", "FINALLY"):
                result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # BREAK, CONTINUE, RETURN, ERROR
        elif kw_type in ("BREAK", "CONTINUE", "RETURN", "ERROR"):
            entry = f"{_indent}{kw_type}"
            values = self._get_value(kw, "values", [])
            if self._get_value(kw, "values") and values:
                entry += f"    {_sd.join(values)}"
            result.append(entry)

        # Unknown types
        elif self._get_value(kw, "body"):
            body = self._get_value(kw, "body", [])
            for subkw in body:
                result.extend(self._handle_keyword_types(subkw))

        return result

    def _kw_post_processing(self, kw: list):
        """Post-processing of generated keyword list to handle special cases"""
        # TRY/EXCEPT/FINALLY
        # post-process list for specific handling
        for i in range(len(kw) - 1):
            _cur = str(kw[i]).replace(" ", "")
            _next = str(kw[i + 1]).replace(" ", "")
            if _cur == "END" and _next == "FINALLY":
                kw.pop(i)
                break
        return kw

    def _get_value(self, obj: CustomTestCaseBody | dict, key: str, default=None) -> Any:
        """
        TBD
        """
        if isinstance(obj, dict):
            return obj.get(key, default)
        return getattr(obj, key, default)
