# Robot Framework TestDoc

## Statistics

[![Release Pipeline](https://github.com/MarvKler/robotframework-testdoc/actions/workflows/release.yml/badge.svg)](https://github.com/MarvKler/robotframework-testdoc/actions/workflows/release.yml)
[![PyPI Downloads - Total](https://static.pepy.tech/badge/robotframework-testdoc)](https://pepy.tech/projects/robotframework-testdoc)
[![PyPI Downloads - Monthly](https://static.pepy.tech/badge/robotframework-testdoc/month)](https://pepy.tech/projects/robotframework-testdoc)

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

## HTML Template Selection

You can choose between multiple HTML template for the design of your test documentation.    
These template can be configured via ``cli arguments`` or within a ``.toml configuration file`` with the parameter ``html_template (-ht / --html-template)``.

### Default Design

- v2

### Available HTML Templates

You can choose one of the following designs:
- v1
- v2

### Version 1

#### Visit Tests

![alt text](docs/html_v1_common.png)

### Version 2

#### Visit Tests on Root Suite Level

![alt text](docs/html_v2_root.png)

#### Visit Tests on Suite File Level

![alt text](docs/html_v2_suitefile.png)

## Theme Selection / Color Configuration

You can select between several themes (color configurations) for your HTML document to create!

> [!CAUTION]
> This is only possible via toml-configuration file, but not via cmd args directly!

### Default Themes

There are a few predefined default themes available that you can choose via the toml-configuration file OR cli.   
Therefore, please use the following syntax: for the toml file
```toml
[colors]
# Use the default theme
default = "default"
default = 0
# Use the default theme
default = "dark"
default = 1
# Use the default theme
default = "blue"
default = 2
# Use the default theme
default = "robot"
default = 3
```

For setting it via CLI, please use the following:
```shell
# Applying dark theme
testdoc ... -S dark PATH OUTPUT_FILE

# Applying blue theme
testdoc ... --style blue PATH OUTPUT_FILE
```

> [!TIP]
> You can select the default theme using either a string value or an integer value.

### Custom Themes

You can apply your own custom theme to modify the colors of the created HTML document.   
Use the following syntax & parameters in your toml-configuration file, to overwrite the predefined themes:
```toml
[colors]
background = "#000028"
inner_color = "#000028"
button_active_color = "#193966"
button_hover_color = "#193966"
border_color = "#CCCCCC"
text_color = "#CCCCCC"
title_color = "#00ffb9"
robot_icon = "#00ffb9"
```

> [!TIP]
> Please make sure to configure all available color values from this example — missing values may cause layout or rendering issues in the generated HTML document!

### Default Themes - Screenshot

#### Dark

![alt text](docs/style_dark.png)

#### Blue

![alt text](docs/style_blue.png)

#### Robot / Default

![alt text](docs/style_robot.png)