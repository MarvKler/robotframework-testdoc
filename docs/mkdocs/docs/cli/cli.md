# CLI Arguments

## Supported Arguments

!!! warning "Incompatible with Mkdocs & External Jinja2 Templates"
    Initially, all of the following CLI arguments have been introduced for using internal & predefined jinja2 templates.
    
    Nowadays, the tool supports also custom jinja2, as well as internal / external mkdocs templates. Therefore, most of the CLI arguments are most probably not compatible and won't have any effect during the documentation creation. In the worst case an error gets raised in your CLI.

    Validating all CLI arguments with the current feature implementation will be a future task - unless this is not done, please be careful when using arguments with custom jinja2 & mkdocs templates.

    !!! success "Internal Jinja2 Template"
        When using the internal jinja2 template, you should be able to use all available CLI arguments!

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
| ``--hide-tags`` | Hide the tags in the HTML page | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--hide-test-doc`` | Hide the test documentation in the HTML page | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--hide-suite-doc`` | Hide the suite documentation in the HTML page | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--hide-source`` | Hide the source in the HTML page | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--hide-keywords`` | Hide the test case keyword calls in the HTML page | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--style``, ``-S`` | Define a specific style for a different color theme | Most probably not working in combination with ``--mkdocs`` | :x: |
| ``--html-template``, ``-ht`` | - | :warning: deprecated - do not use it anymore! | :x: |
| ``--configfile``, ``-c`` | Define a path to a ``.toml`` configuration file | - | :x: |
| ``--verbose``, ``-v`` | Print debug output | - | :x: |
| ``PATH`` | Define path to a suite directory or suite file | - | :white_check_mark: |
| ``OUTPUT`` | Define path to the output HTML file | Becomes directory path in combination with ``--mkdocs`` | :white_check_mark: |