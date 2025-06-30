from robot.api import TestSuite
from robot.running.model import Keyword, Body
from robot.errors import DataError
from ..helper.cliargs import CommandLineArguments

class TestCaseParser():

    def __init__(self):
        self.args = CommandLineArguments().data

    def parse_test(self,
            suite: TestSuite,
            suite_info: dict
        ) -> dict:

        for test in suite.tests:
            test_info = {
                "name": test.name,
                "doc": "<br>".join(line.replace("\\n","") for line in test.doc.splitlines() 
                                   if line.strip()) if test.doc else "No Test Case Documentation Available", 
                "tags": test.tags if test.tags else "No Tags Configured",
                "source": str(test.source),
                "keywords": self._keyword_parser(test.body)
            }
            suite_info["tests"].append(test_info)
        return suite_info
        
    # Consider tags via officially provided robot api
    def consider_tags(self, suite: TestSuite) -> TestSuite:
        try: 
            if len(self.args.include) > 0:
                suite.configure(include_tags=self.args.include) 
            if len(self.args.exclude) > 0:
                suite.configure(exclude_tags=self.args.exclude)
            return suite
        except DataError as e:
            raise DataError(e.message)
        
    def _keyword_parser(self, test_body: Body):
        _keyword_object = []
        for kw in test_body:
            _keyword_object.extend(self._handle_keyword_types(kw))

        # Fallback in case of no keywords
        if len(_keyword_object) == 0:
            return "No Keyword Calls in Test"
        return _keyword_object
        
    def _handle_keyword_types(self, kw: Keyword):
        result = []
        kw_type = getattr(kw, 'type', None)

        _sd = "    " # classic rfw delimiter with 4 spaces

        # Klassisches Keyword
        if kw_type == "KEYWORD" and getattr(kw, 'name', None):
            args = _sd.join(kw.args) if getattr(kw, 'args', None) else ""
            entry = kw.name
            if args:
                entry += _sd + args
            result.append(entry)

        # Variablenzuweisung
        elif kw_type == "VAR" and getattr(kw, 'name', None):
            value = _sd.join(kw.value) if getattr(kw, 'value', None) else ""
            result.append(f"VAR    {kw.name} =    {value}")

        # IF/ELSE/ELSE IF
        elif kw_type and ("IF" in kw_type or "ELSE" in kw_type):
            for branch in getattr(kw, 'body', []):
                branch_type = getattr(branch, 'type', None)
                if branch_type == "IF":
                    header = f"IF {getattr(branch, 'condition', '')}".strip()
                elif branch_type == "ELSE IF":
                    header = f"ELSE IF {getattr(branch, 'condition', '')}".strip()
                elif branch_type == "ELSE":
                    header = "ELSE"
                else:
                    header = branch_type or ""
                if header:
                    result.append(header)
                for subkw in getattr(branch, 'body', []):
                    result.extend(self._handle_keyword_types(subkw))
            result.append("END")

        # FOR-Schleife
        elif kw_type == "FOR":
            header = "FOR"
            if hasattr(kw, 'variables') and kw.variables:
                header += f"    {'    '.join(kw.variables)}"
            if hasattr(kw, 'flavor') and kw.flavor:
                header += f"    {kw.flavor}"
            if hasattr(kw, 'values') and kw.values:
                header += f"    IN    {'    '.join(kw.values)}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw))
            result.append("END")

        # WHILE-Schleife
        elif kw_type == "WHILE":
            header = "WHILE"
            if hasattr(kw, 'condition') and kw.condition:
                header += f"    {kw.condition}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw))
            result.append("END")

        # TRY/EXCEPT/FINALLY
        elif kw_type in ("TRY", "EXCEPT", "FINALLY"):
            header = kw_type
            if hasattr(kw, 'patterns') and kw.patterns:
                header += f"    {'    '.join(kw.patterns)}"
            if hasattr(kw, 'condition') and kw.condition:
                header += f"    {kw.condition}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw))

        # BREAK, CONTINUE, RETURN, ERROR
        elif kw_type in ("BREAK", "CONTINUE", "RETURN", "ERROR"):
            entry = kw_type
            if hasattr(kw, 'values') and kw.values:
                entry += f"    {'    '.join(kw.values)}"
            result.append(entry)

        # Sonstige Typen (z.B. COMMENT, EMPTY)
        elif kw_type in ("COMMENT", "EMPTY"):
            pass  # Optional: ausgeben, wenn gewünscht

        # Unbekannter Typ mit Body (rekursiv)
        elif hasattr(kw, 'body'):
            for subkw in kw.body:
                result.extend(self._handle_keyword_types(subkw))

        return result






