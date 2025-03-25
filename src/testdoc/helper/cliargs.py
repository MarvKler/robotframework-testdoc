from dataclasses import dataclass, field
from typing import List

@dataclass
class CommandLineArgumentsData:
    title: str = None
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
    output_file: str = None

class CommandLineArguments:
    _instance = None
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            
            cls.data = CommandLineArgumentsData()
        return cls._instance