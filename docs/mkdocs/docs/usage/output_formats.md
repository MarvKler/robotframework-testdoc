# Output Formats

Use the `-f` / `--output-format` option to control which file format ``testdoc`` generates.  
The flag is compatible with all other options (tag filters, source prefix, title, …).

| Value | Description |
| ----- | ----------- |
| ``html`` | Interactive HTML page (default) |
| ``json`` | Machine-readable JSON of the full suite tree |
| ``md`` | One AI-friendly Markdown document containing the complete suite tree |
| ``pdf`` | PDF report with title page, contents and suite sections |

---

## HTML (default)

HTML is the default and requires no explicit flag.

```shell
testdoc tests/ TestDocumentation.html
# equivalent:
testdoc -f html tests/ TestDocumentation.html
```

See the [Jinja2 page](jinja2.md) for details about customising the HTML template.

---

## JSON

The JSON output serialises the complete parsed suite tree — the very same data model that is also used by the MkDocs renderer — into a single ``.json`` file.  
This makes the output easy to consume in dashboards, CI quality gates, or any custom tooling without having to parse Robot Framework files yourself.

```shell
testdoc -f json tests/ TestDocumentation.json
```

**Example output structure:**

```json
{
  "id": "s1",
  "name": "Testcases",
  "is_folder": true,
  "source": "/path/to/tests",
  "metadata": null,
  "type": "directory",
  "doc": null,
  "test_count": 17,
  "tests": [],
  "suites": [
    {
      "name": "Component A",
      "tests": [ ... ],
      ...
    }
  ],
  "user_keywords": []
}
```

You can also set ``output_format = "json"`` in your TOML configuration file:

```toml
[tool.testdoc]
output_format = "json"
```

## Markdown

Markdown output creates one consolidated document with suite and test headings, documentation, metadata, tags, source paths, fixtures and Robot Framework test bodies. It is suitable for code review, search and providing a complete test overview as context to an AI system.

```shell
testdoc -f md tests/ TestDocumentation.md
```

The format can also be selected through TOML:

```toml
[tool.testdoc]
output_format = "md"
```

---

## Combining with other options

The output format flag works with the full set of ``testdoc`` options:

```shell
# JSON with tag filter and custom title
testdoc -f json -t "Nightly Suite" -i Regression tests/ nightly.json

# JSON with source prefix
testdoc -f json -s "github::https://github.com/myorg/myrepo" tests/ docs.json
```

## TOML configuration

All common generation options can be supplied through a TOML file. A ``pyproject.toml`` uses the ``[tool.testdoc]`` table; a standalone TOML file uses the options at its root.

```toml
[tool.testdoc]
title = "Nightly Test Documentation"
output_format = "json"
include = ["Regression"]
sourceprefix = "https://github.com/example/project/blob/main/"
```

Use it with ``--configfile``:

```shell
testdoc --configfile pyproject.toml tests/ documentation.json
```
