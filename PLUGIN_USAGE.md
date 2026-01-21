# Using testdoc as Plugin / Using testdoc API

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

## CLI Arguments - Select Plugin

With the current implementation to can choose between using your customized Jinj2 HTML template or using your customized Mkdocs configuration.

> [!IMPORTANT]
> Both Plugins are mutually-exclusive and cannot be used in combination!

### Using custom Jinja2 template

If you want to use a custom ``jinja2`` template, please use the CLI argument ``custom-jinja-template`` and define the path to your local template file!

```shell
testdoc ... --custom-jinja-template /home/user/templates/mytemplate.html /path/to/suites /path/to/output/html/file.html
```

### Using Mkdocs Integration

#### Basic Usage

You have two options using the mkdocs integration:
1. Activate ``--mkdocs`` as plugin and use the pre-configured, internal ``mkdocs-template`` provided by ``testdoc``
2. Activate ``--mkdocs`` as plugin, define you local custom ``mkdocs-template`` via ``--mkdocs-template-dir <path-to-folder>`` - please read following section ``Mandatory Configuration Files``
```shell
# 1) Run this generic command to use & test the internal mkdocs default template
testdoc ... --mkdocs ./atest/ ./output

# OR

# 2) Run this command to use your custom mkdocs template
testdoc ... --mkdocs --mkdocs-template-dir /home/user/templates/mytemplate.html /path/to/suites ./output
```

Opening the generated mkdocs page:
```shell
# Afterwards you need to navigate to './output' and run the command to serve the mkdocs website:
cd ./output && mkdocs serve
```

> [!TIP]
> You also can navigate to './output/site/' and open the index.html in your browser to see the webpage.

#### Example

I have prepared an advanced example for the mkdocs integration which can be found here: [mkodcs-example](https://github.com/MarvKler/robotframework-testdoc/tree/main/examples/mkdocs/default)

#### Mandatory Configuration Files

> [!TIP]
> Recommendation: Use ``material`` as theme for better visualization. That's just a tip, you can use everything else as well.

Please create the following ``mandatory`` files for using the ``mkdocs`` integration in the given directory structure:
```
mkdocs_template_dir/
  mkdocs.yml          (mandatory)
  overrides/          (optional)
  docs/
    _partials/
      suite_page.md   (mandatory)
    index.md          (mandatory)
    stylesheets/
      extra.css       (optional)      
```

The ``mkdocs.yml`` must have at least the following config:
```yml
site_name: Robot Framework Test Documentation    # you can also your own site name
use_directory_urls: false

plugins:
  - search
  - macros:
      module_name: main

exclude_docs: |
  _partials/
  generated/_resolve_suite.md
```

The ``index.md`` is your landing page / home page which could have the following content - its fully customizable:
```md
# Robot Framework Test Documentation Generator

Please select any test suite from the side bar and see the documentation about each test case.
```

The ``suite_page.md`` defines how the test suites & test cases are visualized in the body (content area) of the HTML file.
This file could have the following config, but its fully customizable as well:
```md
# {{ suite.name }}

## Suite Documentation
{% if not suite.is_folder %}
{% for doc_line in (suite.doc or ["No documentation available for this suite"]) %}
{{ doc_line }}
{% endfor %}
{% else %}
Suite is a directory - no documentation available
{% endif %}

{% if suite.user_keywords %}
## Suite User Keywords
\```robotframework
*** Keywords ***
{{ suite.user_keywords | join('\n') }}
\```
{% endif %}

## Test Cases

Count of Tests: {{ suite.total_tests }}

{% if suite.tests | length > 0 %}
\```robotframework
*** Test Cases ***
{{ suite.tests | map(attribute='name') | join('\n') }}
\```
{% endif %}



{% if suite.tests | length > 0 %}
{% for test in (suite.tests or []) %}
## {{ test.name }}

### Documentation

{% for doc_line in (test.doc or ["No documentation available for this test case"]) %}
{{ doc_line }}
{% endfor %}

{% if test.tags | length > 0 %}
### Tags
{{ (test.tags or []) | join(', ') }}
{% endif %}


### Test Case Body
{% if test.keywords %}
\```robotframework
*** Test Cases ***
{{ test.name }}
    {{ test.keywords | join('\n    ') }}
\```
{% endif %}

{% endfor %}
{% endif %}
```

Here's an additional example for the ``mkdocs.yml`` to use ``material`` design with ``dark / light mode toggle button``:
```yml
site_name: Robot Framework Test Documentation
use_directory_urls: false
repo_url: https://github.com/MarvKler/robotframework-testdoc

theme:
  name: material
  logo: stylesheets/logo-white.png
  favicon: stylesheets/logo.png
  custom_dir: overrides
  features:
    - navigation.tabs
    - navigation.top
    - content.code.annotate
    - content.code.copy
    # - header.autohide
  palette:
    # Palette toggle for automatic mode
    - media: "(prefers-color-scheme)"
      primary: custom
      toggle:
        icon: material/brightness-auto
        name: Switch to light mode
    # Palette toggle for light mode
    - media: "(prefers-color-scheme: light)"
      primary: custom
      scheme: default
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    # Palette toggle for dark mode
    - media: "(prefers-color-scheme: dark)"
      primary: custom
      scheme: slate
      toggle:
        icon: material/brightness-4
        name: Switch to system preference

extra_css:
  - stylesheets/custom.css

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences

plugins:
  - search
  - macros:
      module_name: main

exclude_docs: |
  _partials/
  generated/_resolve_suite.md
```