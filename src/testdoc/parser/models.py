from pydantic import BaseModel

class SuiteInfoModel(BaseModel):
    id: str
    filename: str
    name: str
    doc: list[str] | None
    is_folder: bool
    num_tests: int
    source: str
    total_tests: int = 0
    tests: list = []
    user_keywords: list | None = None
    sub_suites: list = []
    metadata: list[str] | None

class TestInfoModel(BaseModel):
    name: str
    doc: list[str] | None
    tags: list | None
    source: str
    keywords: list[str] | list