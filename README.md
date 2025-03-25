# Robot Framework TestDoc

## Installation

Install the tool using the following command:
```shell
pip install robotframework-libdoc
```

## Usage

Basic Usage:
```shell
testdoc suite_directory output.html
# or
testdoc suite_file output.html
```

Extended Usage:
```shell
testdoc [OPTIONS] suite_directory output.html
```

Please execute ``testdoc --help`` for further details about the commandline arguements.

## Examples

```shell
# Generating docu without option
testdoc tests/ TestDocumentation.html
# Generating docu with multiple options
testdoc -t "Robot Framework Test Automation" -n "System Tests" -d "Root Suite Documentation" -m "Root Suite Metadata" tests/ TestDocumentation.html
# Generating docu with source prefix to navigate directly to its gitlab file path
testdoc -s "https://gitlab.com/myrepository" tests/ TestDocumentation.html
```

## Best-Practices

TBD