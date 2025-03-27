from robot.api import TestSuite

from ...helper.cliargs import CommandLineArguments
from ...helper.logger import Logger
from .sourceprefixmodifier import SourcePrefixModifier

class SuiteFileModifier():
    
    def __init__(self):
        self.args = CommandLineArguments().data
        self.suite = None
        
    #############################################################################################################################
        
    def run(self, suite_object: TestSuite = None):
        if not suite_object:
            raise KeyError(f"[{self.__class__}] - Error - Suite Object must not be None!")
        self.suite = suite_object
        
        # Modify generic params / hide some params
        self._modify_tags()
        self._modify_test_doc()
        self._modify_suite_doc()
        self._modify_keywords()
        self._modify_source()
        return self.suite
    
    #############################################################################################################################

    # Modify name, doc & metadata via officially provided robot api
    def _modify_root_suite_details(self, suite: TestSuite):
        if self.args.name:
            suite.configure(name=self.args.name)
        if self.args.doc:
            suite.configure(doc=self.args.doc)
        if self.args.metadata:
            suite.configure(metadata=self.args.metadata)
        return suite
    
    #############################################################################################################################
    
    def _modify_tags(self):
        if not self.args.hide_tags:
            return
        Logger().LogKeyValue("Removed Info from Test Documentation: ", "Tags", "red") if self.args.verbose_mode else None
        self._remove_suite_object_parameter(self.suite, "tags", "test")
    
    #############################################################################################################################
    
    def _modify_test_doc(self):
        if not self.args.hide_test_doc:
            return
        Logger().LogKeyValue("Removed Info from Test Documentation: ", "Test Doc", "red") if self.args.verbose_mode else None
        self._remove_suite_object_parameter(self.suite, "doc", "test")
    
    #############################################################################################################################
    
    def _modify_suite_doc(self):
        if not self.args.hide_suite_doc:
            return
        Logger().LogKeyValue("Removed Info from Test Documentation: ", "Suite Doc", "red") if self.args.verbose_mode else None
        self._remove_suite_object_parameter(self.suite, "doc", "suite")
    
    #############################################################################################################################
    
    def _modify_keywords(self):
        if not self.args.hide_keywords:
            return
        Logger().LogKeyValue("Removed Info from Test Documentation: ", "Keywod Calls", "red") if self.args.verbose_mode else None
        self._remove_suite_object_parameter(self.suite, "keywords", "test")
    
    #############################################################################################################################
    
    def _modify_source(self):
        if self.args.hide_source:
            Logger().LogKeyValue("Removed Info from Test Documentation: ", "Test Suite / Case Source", "red") if self.args.verbose_mode else None
            self._remove_suite_object_parameter(self.suite, "source", "both")
            return
        
        # Modify the source path for the test documentation
        if self.args.sourceprefix:
            self.suite = SourcePrefixModifier().modify_source_prefix(self.suite)

    #############################################################################################################################
    #############################################################################################################################
    #############################################################################################################################
    
    def _remove_suite_object_parameter(self, suites: list, field: str, target: str = "test"):
        """Remove a specific key from the test suite or test case object"""
        for suite in suites:
            if target in ("suite", "both"):
                suite[field] = None
            if target in ("test", "both"):
                for test in suite.get("tests", []):
                    test[field] = None
            if "sub_suites" in suite:
                self._remove_suite_object_parameter(suite["sub_suites"], field, target)
                
    #############################################################################################################################                