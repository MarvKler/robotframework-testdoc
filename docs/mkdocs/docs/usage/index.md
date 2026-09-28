# Usage

This section provides details about the output modes and integrations available in ``robotframework-testdoc``.

The following output formats and site generators are currently supported:

1. [HTML via Jinja2](jinja2.md) (Default)
2. [Mkdocs](mkdocs.md)
3. [PDF Output](pdf.md)
4. [JSON and Markdown](output_formats.md)
5. [Management dashboard with result history](management.md)

!!! warning "Output modes"
    ``--custom-jinja-template`` and ``--mkdocs`` select different renderers and should not be used together. ``--custom-pdf-template`` is used with ``-f pdf``. The ``management`` command always creates its management dashboard and can additionally create the selected documentation output.

## Examples

See some examples how to use ``testdoc``:

```shell
# Generating docu without option (HTML default)
testdoc tests/ TestDocumentation.html

# Generating docu as JSON
testdoc -f json tests/ TestDocumentation.json

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

# Generating docu using the internal predefined mkdocs template
testdoc --mkdocs tests/ output-dir/

# Generating docu using a custom mkdocs template stored on your local system
testdoc --mkdocs --mkdocs-template-dir templates/my-mkdocs-template/ tests/ /output-dir/

# Generating a management dashboard and storing result history
testdoc management --report-file results/output.xml --database-file results/history.sqlite tests/ management-output/
```