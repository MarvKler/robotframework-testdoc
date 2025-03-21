from dataclasses import dataclass, field
from typing import List, Optional

@dataclass
class CommandLineArgumentsData:
    title: str = ""
    name: str = ""
    include: List[str] = field(default_factory=list)
    exclude: List[str] = field(default_factory=list)
    suite_file: Optional[str] = None
    output_file: Optional[str] = None
    show_tags: bool = True
    show_test_doc: bool = True
    show_suite_doc: bool = True
    show_source: bool = True
    show_keywords: bool = True

    config_file: Optional[str] = None
    verbose_mode: Optional[bool] = None

class CommandLineArguments:
    _instance = None  # Singleton-Instanz

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            
            cls.data = CommandLineArgumentsData()
        return cls._instance