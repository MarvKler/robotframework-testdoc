# PDF Output Mode

Use `-f pdf` to generate a release-friendly PDF report.

## What the PDF contains

The built-in PDF mode generates:

1. A title page
2. A table of contents with internal links
3. An overview section with suite and test counters
4. One section/page start per test suite with test case list

## Basic command

```shell
testdoc -f pdf tests/ TestDocumentation.pdf
```

## Custom PDF template

You can replace the default PDF HTML template with your own Jinja2 template:

```shell
testdoc -f pdf --custom-pdf-template path/to/pdf_template.html tests/ TestDocumentation.pdf
```

This works out of the box.

## Mandatory template variables

Your template is rendered for two views: `overview` and `suite`.

### Variables for `view == "overview"`

| Variable | Type | Description |
| --- | --- | --- |
| `title` | `str` | Report title |
| `generated_at` | `str` | Generation date string |
| `suite_count` | `int` | Number of included `.robot` suites |
| `test_count` | `int` | Total number of test cases |

### Variables for `view == "suite"`

| Variable | Type | Description |
| --- | --- | --- |
| `suite_name` | `str` | Current suite name |
| `tests` | `list[dict]` | Test case collection for current suite |

Each item in `tests` contains:

| Key | Type | Description |
| --- | --- | --- |
| `name` | `str` | Test case name |
| `tags` | `list[str]` | Tags for that test case (can be empty) |

## Important behavior

1. The title page is rendered directly by the PDF renderer, not by the custom Jinja template.
2. The table of contents is rendered directly by the PDF renderer and includes clickable internal links.
3. Your custom template is used for `overview` and `suite` rendering only.

## Configure in TOML

You can also configure custom PDF template usage in config files:

```toml
[tool.testdoc]
output_format = "pdf"
custom_pdf_template = "path/to/pdf_template.html"
```
