# CLI Arguments

## Supported Arguments

| Argument | Description | Additional Information | Mandatory |
| -------- | ----------- | ---------------------- | --------- |
| ``--title``, ``-t`` | Set a custom title for your webpage | - | :x: |
| ``--name``, ``-n`` | Set a custom name for the root suite object | - | :x: |
| ``--doc``, ``-d`` | Modify the documentation of the root suite object | - | :x: |
| ``--metadata``, ``-m`` | Modify the metadata of the root suite object | - | :x: |
| ``--sourceprefix``, ``-s`` | Define a prefix e.g. for gitlab to attach a link to your source code file | - | :x: |
| ``--custom-jinja-template`` | Define a custom jinja2 template from your local path | If not set, internal template is used | :x: |
| ``--mkdocs`` | Use mkdocs to generate the test documentation | If set, uses by default the internal mkdocs template - see ``--mkdocs-template-dir``. <br> If set, ``OUTPUT`` must be a directory path object instead of a file path object | :x: |
| ``--mkdocs-template-dir`` | Define a custom mkdocs template from your local path | - | :x: |
| ``--include``, ``-i`` | Define Robot Framework tags to include only specific tests | Can be used multiple times | :x: |
| ``--exclude``, ``-e`` | Define Robot Framework tags to exclude specific tests | Can be used multiple times | :x: |
| ``--configfile``, ``-c`` | Define a path to a ``.toml`` configuration file | - | :x: |
| ``--verbose``, ``-v`` | Print debug output | - | :x: |
| ``PATH`` | Define path to a suite directory or suite file | - | :white_check_mark: |
| ``OUTPUT`` | Define path to the output HTML file | Becomes directory path in combination with ``--mkdocs`` | :white_check_mark: |