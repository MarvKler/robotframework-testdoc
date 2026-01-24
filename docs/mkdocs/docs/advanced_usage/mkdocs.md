# Create a Custom Mkdocs Template

This page explains how you can create your own mkdocs template to be compatible with testdoc.

The created template is just an example to explain how to create custom template - feel free to start with a completely fresh template for your own customization!

!!! tip "Example Directory"
    In this example we will create our template in directory: ``/home/user/template/``

## Create Mandatory Files

Please create the following structure in your local file path & create at least the empty files:

```
/home/user/template/
  mkdocs.yml          (mandatory)
  docs/
    stylesheets/
      custom.css      (optional)
    _partials/
      suite_page.md   (mandatory)
    index.md          (mandatory)
```

## Configuration - mkdocs.yml

Copy the following content into your local ``mkdocs.yml``:

??? example "mkdocs.yml"
    ```yml
    site_name: Robot Framework Test Documentation
    use_directory_urls: false

    theme:
      name: material
      custom_dir: overrides
      features:
        - navigation.tabs
        - navigation.top
        - content.code.annotate
        - content.code.copy
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

## Configuration - index.md

The ``index.md`` is your landing page & can have any content - for now, please use the following:

??? example "index.md"
    ```md
    # Robot Framework Test Documentation Generator

    Please select any test suite from the side bar and see the documentation about each test case.
    ```

## Configuration - suite_page.md

!!! tip "Visit the Internal Template"
    Take a look at the internal mkdocs template which is provided by testdoc - this template does always have the latest development state and may differ from this documentation page.

    You can use the internal template as a starting point to create your own template.
    
    Here you can found the template: [Internal Mkdocs Template](https://github.com/MarvKler/robotframework-testdoc/blob/main/src/testdoc/html/templates/mkdocs_default/docs/_partials/suite_page.md?plain=1)


The ``suite_page.md`` contains the template to visualize all the suite directory / suite file elements as mkdocs page - please use the following example:

??? example "suite_page.md"

    !!! danger "Attention"
        After copy & paste the following content into your local ``suite_page.md`` you must replace the \ character in all escaped code blocks "\\```"!

    ```md
    {% if suite.is_folder %}

    # 📁 {{ suite.name }}

    !!! tip ""
        📊 **{{ suite.total_tests }} Test Cases in all Sub-Suites**

    **Available Sub-Suites:**
    \```
    {{ suite.sub_suites | map(attribute='name') | join('\n') }}
    \```

    {% else %}

    # {{ suite.name }}

    !!! tip ""
        📊 **{{ suite.num_tests }} Test Cases in Current Suite**

    !!! info "📝 Suite Documentation"
        {% for doc_line in (suite.doc or ["No documentation available for this suite"]) %}
        {{ doc_line }}
        {% endfor %}

    {% if suite.user_keywords %}
    🔑 **Available Suite User Keyword:**
    \```robotframework
    *** Keywords ***
    {{ suite.user_keywords | join('\n') }}
    \```
    {% endif %}

    ## Test Case Overview

    {% if suite.tests | length > 0 %}
    **All Test Cases in Suite:**
    \```robotframework
    *** Settings ***
    Name    {{ suite.name }}

    *** Test Cases ***
    {{ suite.tests | map(attribute='name') | join('\n') }}
    \```


    ## Test Case Details

    {% for test in (suite.tests or []) %}

    ---

    ### {{ test.name }}

    !!! abstract "**Documentation:**"
        {% for doc_line in (test.doc or ["No documentation available for this test case"]) %}
        {{ doc_line }}
        {% endfor %}

    !!! tip "Tags"
        {% if test.tags and ((test.tags | default([])) | length > 0) %}
        {{ (test.tags or []) | join(', ') }}
        {% endif %}

    {% if test.keywords %}
    **Test Case Body:**
    \```robotframework
    *** Test Cases ***
    {{ test.name }}
        {{ test.keywords | join('\n    ') }}
    \```
    {% endif %}

    {% endfor %}

    {% endif %}

    {% endif %}
    ```

## Configuration - custom.css

Define your own style:

??? example "custom.css"
    ```css
    .md-typeset {
      font-size: 16px !important;
      line-height: 1.0;
    }

    /* Optional: Sidebar/Nav */
    .md-nav {
      font-size: 16px !important;
    }

    :root {
      --md-primary-fg-color: #000028;
    }

    /* Light mode (scheme: default) */
    [data-md-color-scheme="default"] {
      --md-primary-fg-color: #000028;
      --md-accent-fg-color: #000028;
    }

    /* Dark mode (scheme: slate) */
    [data-md-color-scheme="slate"] {
      --md-primary-fg-color: #00c0b5;
      --md-accent-fg-color: #00c0b5;
    }
    ```

## Generate Test Documenation

Run the following command to generate the test documentation via ``testdoc`` using the previous created mkdocs template:
```shell
testdoc --mkdocs --mkdocs-template-dir /home/user/template/ testcases/ /home/user/outputdirectory/
```

## Open Test Documentation

In this example we will host the webpage locally:

```
cd /home/user/outputdirectory/testdoc_output
mkdocs serve
```

Go to your browser & open: ``http://localhost:8000`` (the port may be different - check your CLI output!)