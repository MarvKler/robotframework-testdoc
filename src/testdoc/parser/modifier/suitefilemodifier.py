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
        self._modify_root_suite_name()
        self._modify_root_suite_doc()
        self._modify_root_suite_metadata()
        self._modify_tags()
        self._modify_test_doc()
        self._modify_suite_doc()
        self._modify_keywords()
        self._modify_source()
        return self.suite
    
    #############################################################################################################################
    
    def _modify_root_suite_name(self):
        if not self.args.name:
            return
        Logger().LogKeyValue("Modified Name of Root Suite: ", self.args.name, "yellow") if self.args.verbose_mode else None
        self.suite[0]["name"] = self.args.name
    
    #############################################################################################################################
        
    def _modify_root_suite_doc(self):
        if not self.args.doc:
            return
        Logger().LogKeyValue("Modified Doc of Root Suite: ", self.args.name, "yellow") if self.args.verbose_mode else None
        self.suite[0]["doc"] = self.args.doc
    
    #############################################################################################################################
        
    def _modify_root_suite_metadata(self):
        if not self.args.metadata:
            return
        Logger().LogKeyValue("Modified Metadata of Root Suite: ", self.args.metadata, "yellow") if self.args.verbose_mode else None
        formatted_metadata = "<br>".join([f"{k}: {v}" for k, v in self.args.metadata.items()])
        self.suite[0]["metadata"] = formatted_metadata
    
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