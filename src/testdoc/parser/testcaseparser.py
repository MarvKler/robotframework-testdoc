from robot.api import TestSuite

class TestCaseParser():

    def parse_test(self,
            suite: TestSuite,
            suite_info: dict
        ) -> dict:

        for test in suite.tests:
            test_info = {
                "name": test.name,
                "doc": "<br>".join([line for line in test.doc.split("\n") if line.strip()]) if test.doc else "No test documentation available - please add!", 
                "tags": test.tags if test.tags else [],
                "source": str(test.source),
                "keywords": [kw.name for kw in test.body if hasattr(kw, 'name')]
            }
            suite_info["tests"].append(test_info)
        return suite_info