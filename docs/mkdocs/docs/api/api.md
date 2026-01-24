# API Description

## General

The ``robotframework-testdoc`` tool provides an external API which can be used to create custom ``jinja`` / ``mkdocs`` templates. Therefore, you need to know which objects / elements the testdoc tool provides which you can use as placeholder (variable) in your template files.

Basically, the testdoc tool provides a ``suites`` object, which is actually a list of suites & sub-suites. Within every suite & sub-suite object, you will have some metadata, but also an object called ``tests`` which takes a list of test cases. Please see the following model descriptions for more information.

## Test Suite Model

The ``suites`` object actually is a list of ``SuiteInfoModel`` elements.

The ``SuiteInfoModel`` element has the following metadata:
```python
from pydantic import BaseModel

class SuiteInfoModel(BaseModel):
    id: str
    filename: str
    name: str
    doc: list[str] | None
    is_folder: bool
    num_tests: int
    source: str
    total_tests: int
    tests: list[TestInfoModel]
    user_keywords: list | None
    sub_suites: list[SuiteInfoModel]
    metadata: list[str] | None
```

## Test Case Model

Within the ``SuiteInfoModel`` object, you can find a element of type ``TestInfoModel``. If the given suite contains at least one RF test case, this list will have at least one child element of type ``TestInfoModel``.

The ``TestInfoModel`` object has the following metadata:
```python
from pydantic import BaseModel

class TestInfoModel(BaseModel):
    name: str
    doc: list[str] | None
    tags: list | None
    source: str
    keywords: list[str] | list
```

## Example

Here you can see an example of the suites object, that takes one parent directory, two robot framework suite files and a total of three test cases:

```py
suites = {
    id: id_a
    filename: dir_a
    name: DirA
    doc: None
    is_folder: true
    num_tests: 0
    source: <local-path>
    total_tests: 3
    tests: []
    user_keywords: None
    sub_suites: [
        {
            id: id_b
            filename: file_b
            name: FileB
            doc: ["List of Suite Documentation Lines"]
            is_folder: false
            num_tests: 2
            source: <local-path>
            total_tests: 2
            tests: [
                {
                    name: TestA
                    doc: ["List of Test Documentation Lines"]
                    tags: []
                    source: <local-path>
                    keywords: ["KeywordCallA", "KeywordCallB"]
                },
                {
                    name: TestB
                    doc: ["List of Test Documentation Lines"]
                    tags: []
                    source: <local-path>
                    keywords: ["KeywordCallA", "KeywordCallB", "KeywordCallC"]
                }
            ]
            user_keywords: ["UserKeywordA"]
            sub_suites: []
            metadata: None
        },
        {
            id: id_c
            filename: file_c
            name: FileC
            doc: ["List of Suite Documentation Lines"]
            is_folder: false
            num_tests: 1
            source: <local-path>
            total_tests: 1
            tests: [
                {
                    name: TestC
                    doc: ["List of Test Documentation Lines"]
                    tags: []
                    source: <local-path>
                    keywords: ["KeywordCallA", "KeywordCallB", "KeywordCallC"]
                }
            ]
            user_keywords: None
            sub_suites: []
            metadata: None
        }
    ]
    metadata: None
}
```