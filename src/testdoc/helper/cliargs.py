from dataclasses import dataclass, field
from typing import Any, List
from .toml_reader import TOMLReader
import os

@dataclass
class CommandLineArgumentsData:
    title: str = "Robot Framework - Test Documentation"
    name: str = None
    doc: str = None
    metadata: dict = None
    sourceprefix: str = None
    include: List[str] = field(default_factory=list)
    exclude: List[str] = field(default_factory=list)
    hide_tags: bool = False
    hide_test_doc: bool = False
    hide_suite_doc: bool = False
    hide_source: bool = False
    hide_keywords: bool = False
    config_file: str = None
    verbose_mode: bool = False
    suite_file: str = None
    style: str = None
    html_template: str = "v2"
    output_file: str = None
    colors: dict = None

class CommandLineArguments:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            
            cls.data = CommandLineArgumentsData()
        return cls._instance
    
    ###
    ### Load configuration file
    ###
    def load_from_config_file(self, file_path: str):
        config = TOMLReader()._read_toml(file_path)
        _is_pyproject = self._is_pyproject_config(file_path)
        if _is_pyproject:
            self._handle_pyproject_config(config)
        else:
            self._handle_custom_config(config)

    ###
    ### Read pyproject.toml
    ###
    def _handle_pyproject_config(self, config: dict[str, Any]):
        testdoc_config = config.get("tool", {}).get("testdoc", {})

        if "colors" in testdoc_config:
            self.data.colors = testdoc_config["colors"]

        if "metadata" in testdoc_config:
            if hasattr(self.data, "metadata"):
                setattr(self.data, "metadata", testdoc_config["metadata"])

        for key, value in testdoc_config.items():
            if key in ("colors", "metadata"):
                continue
            if hasattr(self.data, key):
                setattr(self.data, key, value)

    ###
    ### Read custom.toml
    ###
    def _handle_custom_config(self, config: dict[str, Any]):
        if "colors" in config:
            self.data.colors = config["colors"]

        for key, value in config.items():
            if hasattr(self.data, key):
                setattr(self.data, key, value)

    #####################################################################################

    def _is_pyproject_config(self, file_path) -> bool:
        return os.path.basename(file_path) == "pyproject.toml"
    
    #####################################################################################