# Management Dashboard

The ``management`` command combines generated test documentation with execution results from Robot Framework. It creates a static dashboard for the current test repository and stores result history in a local SQLite database.

## Basic command

```shell
testdoc management \
  --report-file results/output.xml \
  --database-file results/testdoc-history.sqlite \
  tests/ management-output/
```

Required arguments:

| Argument | Description |
| --- | --- |
| ``PATH`` | One or more Robot Framework suite files or directories |
| ``OUTPUT`` | Directory for the generated dashboard and documentation |
| ``--report-file`` | Robot Framework ``output.xml`` from an execution |
| ``--database-file`` | SQLite file used to retain result history across runs |

The report must exist before the command is started. Reuse the same database path on every run to retain the history.

## Generated files

The command creates:

- ``index.html`` - the management dashboard
- ``styles.css`` and ``app.js`` - dashboard assets
- ``documentation/`` - the regular test documentation output
- ``testdoc-history.sqlite`` - when the database path points below the output directory, the persistent result database

The documentation inside ``documentation/`` follows the selected common output options. By default it is an HTML document. With ``--mkdocs`` it is a MkDocs site directory; with ``-f json`` or ``-f pdf`` the corresponding JSON or PDF documentation is generated.

## Dashboard views

The static dashboard contains three main views:

- **Dashboard** - overview metrics and the latest result distribution
- **Test Case Repository** - browse suites and test cases and inspect their documentation
- **Test Result History** - inspect the recorded trend for an individual test case

The repository and history views use the stable source-and-test identity from the parsed documentation and the Robot Framework report. A test without a matching execution result is shown with the ``UNKNOWN`` status until a run is recorded. Tests present in the documentation but absent from the report are stored as ``NOT_RUN`` for that run.

## Result history

Each invocation stores a new run unless the same report file has already been stored with the same content. Individual records contain:

- status, such as ``PASS`` or ``FAIL``
- message
- start time
- elapsed time
- run timestamp

The database is append-only for new runs. It is the source of truth for the history, so it should be kept between CI runs and backed up like other project result data.

## Filtering and output options

The management command supports the common generation options, including:

```shell
testdoc management \
  --include Smoke \
  --exclude LongRunning \
  --sourceprefix "https://github.com/example/project/blob/main/" \
  --report-file results/output.xml \
  --database-file results/history.sqlite \
  tests/ management-output/
```

Use ``--mkdocs`` and ``--mkdocs-template-dir`` to control the documentation copy, or ``-f json`` / ``-f pdf`` for another documentation format. The management dashboard itself remains a dependency-free static HTML application.

!!! note "Test identity"
    Result matching uses the normalized source path and Robot Framework's local test identifier. Changing the suite source path or test identity can prevent historical records from matching the new documentation entry.
