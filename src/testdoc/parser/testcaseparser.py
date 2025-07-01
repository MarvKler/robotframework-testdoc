from robot.api import TestSuite
from robot.running.model import Keyword, Body
from robot.errors import DataError
from ..helper.cliargs import CommandLineArguments
import textwrap

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
        """ Parse keywords and their child-items """
        _keyword_object = []
        for kw in test_body:
            _keyword_object.extend(self._handle_keyword_types(kw))

        _keyword_object = self._kw_post_processing(_keyword_object)

        # Fallback in case of no keywords
        if len(_keyword_object) == 0:
            return "No Keyword Calls in Test"
        return _keyword_object
        
    def _handle_keyword_types(self, kw: Keyword, indent: int = 0):
        """ Handle different keyword types """
        result = []
        kw_type = getattr(kw, 'type', None)

        _sd = "    " # classic rfw delimiter with 4 spaces
        _indent = _sd * indent

        # Classic keyword
        if kw_type == "KEYWORD" and getattr(kw, 'name', None):
            args = _sd.join(kw.args) if getattr(kw, 'args', None) else ""
            entry =  _indent + kw.name
            if args:
                entry += _sd + args
            wrapped = textwrap.wrap(entry, width=150, subsequent_indent=_indent + "..." + _sd)
            result.extend(wrapped)

        # VAR syntax
        elif kw_type == "VAR" and getattr(kw, 'name', None):
            value = _sd.join(kw.value) if getattr(kw, 'value', None) else ""
            result.append(f"{_indent}VAR    {kw.name} =    {value}")

        # IF/ELSE/ELSE IF
        elif kw_type == "IF/ELSE ROOT":
            for branch in getattr(kw, 'body', []):
                branch_type = getattr(branch, 'type', None)
                if branch_type == "IF":
                    header = f"{_indent}IF{_sd}{getattr(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE IF":
                    header = f"{_indent}ELSE IF{_sd}{getattr(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE":
                    header = f"{_indent}ELSE"
                else:
                    header = f"{_indent}{branch_type or ''}"
                if header:
                    result.append(header)
                for subkw in getattr(branch, 'body', []):
                    result.extend(self._handle_keyword_types(subkw, indent=indent+1))
            result.append(f"{_indent}END")

        # FOR loop
        elif kw_type == "FOR":
            header = f"{_indent}FOR"
            if hasattr(kw, 'assign') and kw.assign:
                header += f"    {'    '.join(kw.assign)}"
            if hasattr(kw, 'flavor') and kw.flavor:
                header += f"    {kw.flavor}"
            if hasattr(kw, 'values') and kw.values:
                header += f"    IN    {'    '.join(kw.values)}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent+1))
            result.append(f"{_indent}END")

        # WHILE loop
        elif kw_type == "WHILE":
            header = f"{_indent}WHILE"
            if hasattr(kw, 'condition') and kw.condition:
                header += f"    {kw.condition}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent+1))
            result.append(f"{_indent}END")

        # TRY/EXCEPT/FINALLY
        elif kw_type in ("TRY", "EXCEPT", "FINALLY"):
            header = f"{_indent}{kw_type}"
            if hasattr(kw, 'patterns') and kw.patterns:
                header += f"    {'    '.join(kw.patterns)}"
            if hasattr(kw, 'condition') and kw.condition:
                header += f"    {kw.condition}"
            result.append(header)
            if hasattr(kw, 'body'):
                for subkw in kw.body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent+1))
            if kw_type in ("EXCEPT", "FINALLY"):
                result.append(f"{_indent}END")            

        # BREAK, CONTINUE, RETURN, ERROR
        elif kw_type in ("BREAK", "CONTINUE", "RETURN", "ERROR"):
            entry = f"{_indent}{kw_type}"
            if hasattr(kw, 'values') and kw.values:
                entry += f"    {'    '.join(kw.values)}"
            result.append(entry)

        # Other types
        elif kw_type in ("COMMENT", "EMPTY"):
            pass

        # Unknown types
        elif hasattr(kw, 'body'):
            for subkw in kw.body:
                result.extend(self._handle_keyword_types(subkw))

        return result
    
    def _kw_post_processing(self, kw: list):
        """ Post-processing of generated keyword list to handle special cases """
        # TRY/EXCEPT/FINALLY 
        # post-process list for specific handling 
        for i in range(len(kw) - 1):
            _cur = str(kw[i]).replace(" ", "")
            _next = str(kw[i + 1]).replace(" ", "")
            if _cur == "END" and _next == "FINALLY":
                kw.pop(i)
                break
        return kw






