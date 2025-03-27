from robot.api import TestSuite
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
                "keywords": [kw.name for kw in test.body if hasattr(kw, 'name')] or "No Keyword Calls in Test"
            }
            suite_info["tests"].append(test_info)
        return suite_info
        
    # Consider tags via officially provided robot api
    def consider_tags(self, suite: TestSuite) -> TestSuite:
        if len(self.args.include) > 0:
            suite.configure(include_tags=self.args.include) 
        if len(self.args.exclude) > 0:
            suite.configure(exclude_tags=self.args.exclude)
        return suite