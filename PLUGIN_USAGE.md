# Using testdoc as a plugin

## Internal Suite / Test Objects

The testdoc tool provides a plugin API for you which exposes the internal suite / test objects that you require in your HTML templates.

Internally, an object called ``suites`` exists in the rendering functions that contains the complete test suite object from your given path with all required meta data.
In a ``jinja2`` te,plate, you can call this object, which is iterable, to find all suite & test meta data like documentation, keyword calls, overall count of tests, etc...

### Generic

The following two objects, which are part of the ``suites`` object, are basically just replicating the given directory structure as Robot Framework suite & test case objects with further metadata which you can find in the model descriptions.

### SuiteInfoModel Object

The ``suites`` object actually is a list of ``SuiteInfoModel`` elements.
The ``SuiteInfoModel`` element has the following metadata:
```python
    id: str
    filename: str
    name: str
    doc: list[str] | None
    is_folder: bool
    num_tests: int
    source: str
    total_tests: int = 0
    tests: list[TestInfoModel] = []
    user_keywords: list | None = None
    sub_suites: list[SuiteInfoModel] = []
    metadata: list[str] | None
```

As you know how Robot Framework works, you know that a suite can contain further sub suites and those are defined in the metadata element called ``sub_suites`` which is also a list of ``SuiteInfoModel`` elements. You can iterate over this element which replicates your directory suite structure of Robot Framework.

### TestInfoModel Object

Within the ``SuiteInfoModel`` object, you can find a element of type ``TestInfoModel``. If the given suite contains at least one RF test case, this list will have at least one child element of type ``TestInfoModel``.
The ``TestInfoModel`` object has the following metadata:
```python
    name: str
    doc: list[str] | None
    tags: list | None
    source: str
    keywords: list[str] | list
```

In your custom HTML template you can iterate over this list of tests to get all available tests of the related suite with all mentioned meta data.

## CLI Arguments

### Using Custom Jinja2 template

If you want to use a custom ``jinja2`` templatem, please use the CLI argument ``custom-jinja-template`` and define the path to your local template file!

```shell
testdoc ... --custom-jinja-template /home/user/templates/mytemplate.html /path/to/suites /path/to/output/html/file.html
```

### Using Mkdocs Integration

TBD


```
user_template/
  mkdocs.yml
  docs/
    index.md
    stylesheets/extra.css   (optional)
    overrides/              (optional, theme overrides)
```