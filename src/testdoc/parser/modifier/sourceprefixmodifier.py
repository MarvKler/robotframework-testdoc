import os
from abc import ABC, abstractmethod
from pathlib import Path
from typing import cast

from testdoc.parser.models import CustomTestCase, CustomTestSuite

from ...helper.cliargs import CommandLineArguments
from ...helper.logger import Logger

available_implementations = "gitlab, github"


########################################
# Interface
########################################
class SourceModifier(ABC):
    @abstractmethod
    def apply(self, suite_dict, prefix):
        pass


########################################
# Factory
########################################
class SourceModifierFactory:
    @staticmethod
    def get_modifier(prefix_type: str) -> SourceModifier:
        if prefix_type.lower() == "gitlab":
            return GitLabModifier()
        if prefix_type.lower() == "github":
            return GitHubModifier()
        # EXAMPLE Extension:
        # elif prefix_type.lower() == "github":
        #     return GitHubModifier()
        raise ValueError(f"No source modifier found for type '{prefix_type}' - actually available implementation are:\n{available_implementations}")


########################################
# Prefix Modifier - Implementation
########################################
class SourcePrefixModifier:
    GITLAB_CONNECTOR = "-/blob/main/"

    def __init__(self):
        self.args = CommandLineArguments()

    def _prefix_validation(self, prefix: str) -> list:
        if "::" not in prefix:
            raise ValueError("Missing source-prefix type - expected type in format like 'gitlab::source-prefix!'")
        prefix = self.args.sourceprefix.split("::")
        return prefix[0], prefix[1]

    def modify_source_prefix(self, suite_object: CustomTestSuite) -> CustomTestSuite:
        Logger().log_key_value("Using Prefix for Source: ", self.args.sourceprefix, "yellow") if self.args.verbose_mode else None
        prefix_type, prefix = self._prefix_validation(self.args.sourceprefix)
        modifier = SourceModifierFactory.get_modifier(prefix_type)
        modifier.apply(suite_object, prefix)
        return suite_object


########################################
# Low-Level Implementation for GitLab
########################################
class GitLabModifier:
    """
    Source Prefix Modifier for "GitLab" Projects.
    Expected CMD Line Arg: "gitlab::prefix"
    """

    def _get_git_root(self, path):
        path: Path = Path(path)
        current = path.resolve()
        while current != current.parent:
            if Path(current / ".git").is_dir():
                return current
            current = current.parent
        return None

    def _get_git_branch(self, git_root):
        head_file = Path(git_root / ".git" / "HEAD")
        if not head_file.is_fifo():
            return "main"
        with head_file.open() as f:
            content = f.read().strip()
            if content.startswith("ref:"):
                return content.replace("ref: refs/heads/", "")
        return "main"

    def _convert_to_gitlab_url(self, file_path, prefix):
        git_root = self._get_git_root(file_path)
        git_branch = self._get_git_branch(git_root)
        if not git_root:
            return "Unable to fetch GitLab URL!"
        rel_path = os.path.relpath(file_path, git_root).replace(os.sep, "/")
        return prefix.rstrip("/") + "/-/blob/" + git_branch + "/" + rel_path

    def apply(self, suite_dict: CustomTestSuite, prefix):
        try:
            suite_dict.custom_source = self._convert_to_gitlab_url(suite_dict.source, prefix)
        except Exception:
            suite_dict.custom_source = None

        for test in suite_dict.tests:
            test = cast(CustomTestCase, test)
            try:
                test.custom_source = self._convert_to_gitlab_url(test.source, prefix)
            except Exception:
                test.custom_source = None

        for suite in suite_dict.suites:
            self.apply(suite, prefix)


########################################
# Low-Level Implementation for GitHub
########################################
class GitHubModifier:
    """
    Source Prefix Modifier for "GitHub" Projects.
    Expected CMD Line Arg: "github::prefix"
    """

    def _get_git_root(self, path):
        path: Path = Path(path)
        current = path.resolve()
        while current != current.parent:
            if Path(current / ".git").is_dir():
                return current
            current = current.parent
        return None

    def _get_git_branch(self, git_root):
        head_file = Path(git_root / ".git" / "HEAD")
        if not head_file.is_file():
            return "main"
        with head_file.open() as f:
            content = f.read().strip()
            if content.startswith("ref:"):
                return content.replace("ref: refs/heads/", "")
        return "main"

    def _convert_to_github_url(self, file_path, prefix):
        git_root = self._get_git_root(file_path)
        git_branch = self._get_git_branch(git_root)
        if not git_root:
            return "Unable to fetch GitHub URL!"
        rel_path = os.path.relpath(file_path, git_root).replace(os.sep, "/")
        return prefix.rstrip("/") + "/blob/" + git_branch + "/" + rel_path

    def apply(self, suite_dict: CustomTestSuite, prefix):
        try:
            suite_dict.custom_source = self._convert_to_github_url(suite_dict.source, prefix)
        except Exception:
            suite_dict.custom_source = None

        for test in suite_dict.tests:
            test = cast(CustomTestCase, test)
            try:
                test.custom_source = self._convert_to_github_url(test.source, prefix)
            except Exception:
                test.custom_source = None

        for suite in suite_dict.suites:
            self.apply(suite, prefix)


########################################
# Low-Level Implementation for ...
# [FUTURE EXTENSIONS LIKE GITHUB]
########################################
