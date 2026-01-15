from pydantic import BaseModel

class SuiteInfoModel(BaseModel):
    id: str
    filename: str
    name: str
    doc: str | None
    is_folder: bool
    num_tests: int
    source: str
    total_tests: int = 0
    tests: list = []
    user_keywords: list = []
    sub_suites: list = []
    metadata: str | None
