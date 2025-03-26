# Robot Framework TestDoc

## Installation

Install the tool using the following command:
```shell
pip install robotframework-testdoc
```

> [!IMPORTANT]
> Preconditions: Python & Pip Installation.

## Usage

### Basic Usage
```shell
testdoc suite_directory output.html
# or
testdoc suite_file output.html
```

### Extended Usage
```shell
testdoc [OPTIONS] suite_directory output.html
```

> [!TIP]
> **Included Help:** Please execute ``testdoc --help`` for further details about the commandline arguments or see the examples below.

## Examples

Below you can find some example of using the testdoc library.  

> [!TIP]
> Of course, you can combine all of them!

```shell
# Generating docu without option
testdoc tests/ TestDocumentation.html

# Generating docu with new title, new root suite name, new root suite documentation text & new metadata
testdoc -t "Robot Framework Test Automation" -n "System Tests" -d "Root Suite Documentation" -m "Root Suite Metadata" tests/ TestDocumentation.html

# Generating docu with source prefix to navigate directly to its gitlab file path
testdoc -s "https://gitlab.com/myrepository" tests/ TestDocumentation.html

# Generating docu only with specific mentioned tags to include & exclude 
testdoc -i ManagementUI -e LongTime tests/ TestDocumentation.html

# Generating docu only with multiple specific mentioned tags to include
testdoc -i ManagementUI -i MQTT tests/ TestDocumentation.html

# Generating docu only with new metadata for root suite object
testdoc -m Version=0.1.1-dev -m Tester=RobotExpert tests/ TestDocumentation.html

# Generating docu - hide tags information
testdoc --hide-tags tests/ TestDocumentation.html

# Generating docu - hide test case documentation texts
testdoc --hide-test-doc tests/ TestDocumentation.html

# Generating docu - hide test suite documentation texts
testdoc --hide-suite-doc tests/ TestDocumentation.html

# Generating docu - hide source information
testdoc --hide-source tests/ TestDocumentation.html

# Generating docu - hide keyword information (keyword calls in tests)
testdoc --hide-keywords tests/ TestDocumentation.html
```

## Robot Framework Tags
The commandline arguments ``include`` & ``exclude`` have more or less the same functionality like in the known ``robot ...`` command.     
You can decide to weither include and / or exclude specific test cases into the test documentation.

## External Configuration File
The idea of the external configuration file is, having a central place for passing the known CMD arguments via file instead of CMD parameters.   
This will keep your CMD line call simple & clean.

For using this config file, just call the following command:
```shell
# Generate docu with options defined in TOML file
testdoc -c path/to/config.toml tests/ TestDocumentation.html
```
