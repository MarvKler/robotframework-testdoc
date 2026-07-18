# robotframework-testdoc

The new tool to generate test documentation pages for your Robot Framework project.

## GitHub Project

Visit the project at [GitHub - robotframework-testdoc](https://github.com/MarvKler/robotframework-testdoc)

## Documentation

Visit the official documentation for more details: [Documentation - robotframework-testdoc](https://marvkler.github.io/robotframework-testdoc/)

## VS Code Extension

Generate test documentation directly from the VS Code Explorer — no terminal required.  
Download the latest `.vsix` from [GitHub Releases](https://github.com/MarvKler/robotframework-testdoc/releases?q=VS+Code+Extension&expanded=true) and install it locally.

```bash
code --install-extension testdoc-vscode-<version>.vsix
```

See the [VS Code Extension documentation](https://marvkler.github.io/robotframework-testdoc/usage/vscode-extension.html) for details.

## Statistics

[![Release Pipeline](https://github.com/MarvKler/robotframework-testdoc/actions/workflows/release.yml/badge.svg)](https://github.com/MarvKler/robotframework-testdoc/actions/workflows/release.yml)  
[![PyPI - Version](https://img.shields.io/pypi/v/robotframework-testdoc.svg)](https://pypi.org/project/robotframework-testdoc)   
[![PyPI - Python Version](https://img.shields.io/pypi/pyversions/robotframework-testdoc.svg)](https://pypi.org/project/robotframework-testdoc)    
[![PyPI Downloads - Total](https://static.pepy.tech/badge/robotframework-testdoc)](https://pepy.tech/projects/robotframework-testdoc)   
[![PyPI Downloads - Monthly](https://static.pepy.tech/badge/robotframework-testdoc/month)](https://pepy.tech/projects/robotframework-testdoc)   

## Installation

Install the tool using the following command:
```shell
pip install robotframework-testdoc
```

## Usage

### Basic Usage
```shell
testdoc suite_directory output.html
# or
testdoc suite_file output.html
```

![General Usage](./docs/gifs/general_usage.gif)

### Extended Usage
```shell
testdoc [OPTIONS] suite_directory output.html
```

> [!TIP]
> **Included Help:** Visit the [CLI Documentation](https://marvkler.github.io/robotframework-testdoc/cli/cli/) for further arguments & details.

### Output Formats

By default testdoc generates an HTML file. Use `-f` / `--output-format` to choose a different format:

```shell
# HTML (default)
testdoc tests/ TestDocumentation.html

# JSON — machine-readable suite tree
testdoc -f json tests/ TestDocumentation.json

# PDF — release-ready export (overview + TOC + suites + test cases)
testdoc -f pdf tests/ TestDocumentation.pdf
```

Available values: `html` (default), `json`, `pdf`.

### Plugin Usage

You can use the testdoc tool also as plugin integration.  
You have two option to use it this way:
1. You can write your own HTML page as ``jinja2`` template, add this HTML template as CLI argument while generating the docs and you will get your own HTML style as documentation page.
2. You can use the ``mkdocs`` integration to define your own mkdcs template as CLI argument and the testdoc tool will internally take care of the mkdocs page generation.

For further details about the usage, please read the [official documentation](https://marvkler.github.io/robotframework-testdoc/usage).

### Custom PDF Template

You can provide your own Jinja2 template for PDF rendering:

```shell
testdoc -f pdf --custom-pdf-template path/to/pdf_template.html tests/ TestDocumentation.pdf
```

This works out of the box. No code changes are required.

Required template contract:

1. The template must contain a branch for `view == "overview"`.
2. The template must contain a branch for `view == "suite"`.
3. In the `overview` branch, these variables are available:
	 `title` (string), `generated_at` (string), `suite_count` (int), `test_count` (int).
4. In the `suite` branch, these variables are available:
	 `suite_name` (string), `tests` (list of dicts).
5. Each item in `tests` has:
	 `name` (string), `tags` (list of strings, can be empty).

Recommended usage pattern:

1. Start with the minimal template above.
2. Change only markup/styling first.
3. Keep variable names exactly as documented.
4. If a section is empty, always handle it with `{% if tests %}` / fallback text.

Notes:

1. Title page and table of contents are rendered by the PDF engine, not by the custom HTML template.
2. You can also set `custom_pdf_template` in your TOML config file.

#### Use customized Jinja2 HTML Template

![Custom Jinja Template](./docs/gifs/customjinja.gif)

#### Use internal Mkdocs Template

![Internal Mkdocs Template](./docs/gifs/mkdocs_internal_template.gif)

#### Use customized Mkdocs Template

![Custom Mkdocs Template](./docs/gifs/mkdocs_custom_template.gif)

## Examples

Visit the official documentation to find some [Examples](https://marvkler.github.io/robotframework-testdoc/usage/#examples).

## External Configuration File
The idea of the external configuration file is, having a central place for passing the known CMD arguments via file instead of CMD parameters.   
This will keep your CMD line call simple & clean.

For using this config file, just call the following command:
```shell
# Generate docu with options defined in TOML file
testdoc -c path/to/config.toml tests/ TestDocumentation.html
```

### pyproject.toml vs. custom toml file

Using the ``pyproject`` requires to define the ``testdoc`` sections with the prefix ``tool.``   
Example section start: ``[tool.testdoc]``

Using your own custom toml-file, does not require you to use the prefix. Here, you can just use ``[testdoc]`` as section header.


### Example Configuration File
```toml
[tool.testdoc]
title = "New title of HTML document"
name = "New name of root suite element"
doc = "New doc text of root suite element"
sourceprefix = "gitlab::https://gitlab.com/myrepo/repo_path"
include = ["TagA", "TagB"]
exclude = ["TagC"]
verbose_mode = false

[tool.testdoc.metadata]
Author = "Your-Name"
Version = "1.0.0"
Source = "AnySourceAsMetaData"
```

## Contribution & Development

See [Development.md](./DEVELOPMENT.md) for more information about contributing & developing this library.