# Usage

This section will provide you details about using different static site generator in combination with ``robotframework-testdoc``.

The following site generators are currently supported:

1. [Jinja2](jinja2.md) (Default)
2. [Mkdocs](mkdocs.md)

!!! warning "Plugin Usage is Mutual Exclusive"
    The CLI arguments for the plugins are mutually exclusive - you cannot combine them or use them in the same command. 

    Means: you can either use the argument to attach an external jinja2 template or the argument to use internal / external mkdocs templates!

## Examples

See some examples how to use ``testdoc``:

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

# Generating docu using the internal predefined mkdocs template
testdoc --mkdocs tests/ output-dir/

# Generating docu using a custom mkdocs template stored on your local system
testdoc --mkdocs --mkdocs-template-dir templates/my-mkdocs-template/ tests/ /output-dir/
```