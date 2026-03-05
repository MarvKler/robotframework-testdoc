# API Description

## General

The ``robotframework-testdoc`` tool provides an external API which can be used to create custom ``jinja`` / ``mkdocs`` templates. Therefore, you need to know which objects / elements the testdoc tool provides which you can use as placeholder (variable) in your template files.

!!! info "Initial Architecture Draft"
    Initially, i wanted to use the original Robot Framework Suite Model which gets generated after running the Suite Visitor. Unfortunately, using this model doesnt allow you to add custom key objects into each suite model. Testdoc requires some special keys, which are not part of the core model & therefore i have created my own models based on the original models.

Basically, the testdoc tool provides a ``suites`` object, which is actually a customized ``TestSuite`` model. This suite can have X sub-suites which can also have sub-suites. In the end, any suite object should have test objects. The test object is also a customized ``TestCase`` model based on the original model.

## Models

### Test Suite Model

The ``suites`` object actually is a ``CustomTestSuite`` object.

The ``CustomTestSuite`` element has the following metadata:
```python
@dataclass
class CustomTestSuite:
    id: str
    name: str
    is_folder: bool    # customized helper key
    source: str
    metadata: dict | None
    type: str

    doc: str | None = None
    custom_source: str | None = None    # customized helper key
    test_count: int = 0
    tests: list[CustomTestCase] = field(default_factory=list)    # contains tests
    suites: list[CustomTestSuite] = field(default_factory=list)    # contains sub-suites
    user_keywords: list[str] = field(default_factory=list)    # customized helper key

```

### Test Case Model

Within the ``CustomTestSuite`` object, you can find a element of type ``CustomTestCase``. If the given suite contains at least one RF test case, this list will have at least one child element of type ``CustomTestCase``.

The ``CustomTestCase`` object has the following metadata:
```python
@dataclass
class CustomTestCase:
    id: str
    name: str
    source: str
    body: list[CustomTestCaseBody]

    doc: str | None = None
    custom_source: str | None = None    # customized helper key
    tags: list[str] = field(default_factory=list)
```

### Test Case Body Model

Within the ``CustomTestCaseBody`` object, you can find the required metadata to visualize any body item supported by Robot Framework.

E.g. Groups, For, If, While, etc. do have different values as arguments that are required for the visualization.

The ``TestInfoModel`` object has the following metadata:
```python
@dataclass
class CustomTestCaseBody:
    id: str
    type: str
    name: str
    args: list = field(default_factory=list)
    flavor: str = ''
    value: list = field(default_factory=list)
    values: list = field(default_factory=list)
    condition: str = ''
    patterns: list = field(default_factory=list)
    assign: list = field(default_factory=list)
    body: list[CustomTestCaseBody] = field(default_factory=list)
```

## Helper Functions - Jinja2 Filters

Testdoc provides helper functions, better said Jinja2 filters for Jinja2 HTML & Mkdocs Templates.

### Keyword Parser - Format Test Case Body

This filter formats the test case body object with indentation, arguments, etc. for a better visualization.

Its registered as ``format_test_body`` in both templates and can be used in combination with the pipe character ("|")

!!! tip ""
    This filter is recommended to use if you create your own HTML templates!