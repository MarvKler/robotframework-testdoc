import os

from robot.api import  TestSuite

from ...helper.cliargs import CommandLineArguments
from ...helper.logger import Logger

class SourcePrefixModifier():
    
    GITLAB_CONNECTOR = "-/blob/main/"
    
    def __init__(self):
        self.args = CommandLineArguments().data
    
    def _modify(self, suite: TestSuite, prefix: str):
        prefix_type, prefix = self._prefix_validation(prefix)
        if "gitlab" in prefix_type:
            SourcePrefixGitLab()._apply_gitlab_source_to_suite(suite, prefix)
        else:
            raise ValueError(f"No matching source-prefix modifier found for: {prefix_type} with prefix: {prefix}")

    def _prefix_validation(self, prefix: str) -> list:
        if "::" not in prefix:
            raise ValueError("Missing source-prefix type - expected type in format like 'gitlab::source-prefix!'")
        prefix = self.args.sourceprefix.split("::")
        return prefix[0], prefix[1]
    
    def modify_source_prefix(self, suite_object: TestSuite) -> TestSuite:
        Logger().LogKeyValue("Using Prefix for Source: ", self.args.sourceprefix, "yellow") if self.args.verbose_mode else None
        for suite in suite_object:
            self._modify(suite, self.args.sourceprefix)
        return suite_object
    
class SourcePrefixGitLab():
    """
    Source Prefix Modifier for "GitLab" Projects.
    Expected CMD Line Arg: "gitlab::prefix"
    """
    def _get_git_root(self, path):
        current = os.path.abspath(path)
        while current != os.path.dirname(current):
            if os.path.isdir(os.path.join(current, ".git")):
                return current
            current = os.path.dirname(current)
        return None
    
    def _get_git_branch(self, git_root):
        head_file = os.path.join(git_root, ".git", "HEAD")
        if not os.path.isfile(head_file):
            return "main"
        with open(head_file, "r") as f:
            content = f.read().strip()
            if content.startswith("ref:"):
                return content.split("/")[-1]
        return "main"

    def _convert_to_gitlab_url(self, file_path, prefix):
        git_root = self._get_git_root(file_path)
        git_branch = self._get_git_branch(git_root)
        if not git_root:
            return "GitLink error"
        rel_path = os.path.relpath(file_path, git_root).replace(os.sep, "/")
        return prefix.rstrip("/") + "/-/blob/" + git_branch + "/" + rel_path

    def _apply_gitlab_source_to_suite(self, suite_dict, prefix):
        try:
            suite_dict["source"] = self._convert_to_gitlab_url(suite_dict["source"], prefix)
        except:
            suite_dict["source"] = "GitLink error"

        for test in suite_dict.get("tests", []):
            try:
                test["source"] = self._convert_to_gitlab_url(test["source"], prefix)
            except:
                test["source"] = "GitLink error"

        for sub_suite in suite_dict.get("sub_suites", []):
            self._apply_gitlab_source_to_suite(sub_suite, prefix)
