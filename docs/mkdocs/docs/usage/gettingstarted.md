# Getting Started

This site provides very basic commands to get familiar with the tool & the CLI usage. For further details see the more advanced pages.

## Basic Usage - Jinja2

Run the following command for a very basic usage using ``jinja2``:
```shell
testdoc <path/to/test/directory> ./output/documentation.html
```

This command will use the internal ``jinja2`` default template to generate the HTML file.

## Basic Usage - Mkdocs

Run the following command for a very basic usage using ``mkdocs``:
```bash
testdoc --mkdocs <path/to/test/directory> ./output-dir/
```

This command will use the internal ``mkdocs`` default template to generate the HTML webpage.