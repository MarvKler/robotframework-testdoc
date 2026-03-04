# robotframework-testdoc

The new tool to generate test documentation pages for your Robot Framework project.

## GitHub Project

Visit the project at [GitHub - robotframework-testdoc](https://github.com/MarvKler/robotframework-testdoc)

## Documentation

Visit the official documentation for more details: [Documentation - robotframework-testdoc](https://marvkler.github.io/robotframework-testdoc/)

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

### Plugin Usage

You can use the testdoc tool also as plugin integration.  
You have two option to use it this way:
1. You can write your own HTML page as ``jinja2`` template, add this HTML template as CLI argument while generating the docs and you will get your own HTML style as documentation page.
2. You can use the ``mkdocs`` integration to define your own mkdcs template as CLI argument and the testdoc tool will internally take care of the mkdocs page generation.

For further details about the usage, please read the [official documentation](https://marvkler.github.io/robotframework-testdoc/usage).

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