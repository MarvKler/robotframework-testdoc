# Development

## Python Package Release Creation

### Precondition

- You are required to have an account for **[PyPi](https://pypi.org/)**.
- Additionally, check that you have required permissions for the projects at ``PyPi & GitHub``!
- Check that all pipeline-checks did pass, your code changes are ready and everything is already merged to the main branch!
- Your local git configuration must work - check your authentication!

### *Preferred* - Using Shell Script for Release Creation

In the ``root directory`` of this repository you will find a script called ``create_release.sh``.
When executing this script, it expects exactly one argument: the new name of the release / tag.
Here you need to provide always the syntax ``X.X.X``, e.g. ``0.1.9``, ``0.5.0`` or ``1.0.0``.

> [!TIP]
> Please use following versioning to create ``alpha``, ``beta`` or ``releasecandidate`` release at ``PyPi``!    
> Example:
> ```bash
> ./create_release.sh 1.0.0a1    # alpha
> ./create_release.sh 1.0.0b2    # beta
> ./create_release.sh 1.0.0rc1   # release candidate
> ```

The script will do two things automatically for you:
1. Updating the version string in the **[\_\_about\_\_.py](src/testdoc/__about__.py)**
2. Creating & Pushing a new tag to GitHub.

Execute the following command to create a new release:
```bash
cd <project-root-directory>
./create_release.sh 1.0.0
```

After executing the script, three pipeline jobs are getting triggered automatically:
1. First job creates a new ``Release`` in github with the name of the created ``Tag``.
2. Second job uploads the new wheel package to ``PyPi`` with the ``__version__`` from the ``__about__.py`` file.
3. Third job generates a new keyword documentation via ``libdoc`` on the main branch, but pushes it to the ``gh_pages`` where it is available as public ``GitHub Page``.

### *Backup* - Manual Version Bump & Tag Creation

If the preferred way using the ``create_release.sh`` script does not work, you can also manually create a new release.
Therefore, execute the following steps.

#### 1. Increase Version

Open the file **[\_\_about\_\_.py](src/testdoc/__about__.py)** and increase the version (``0.0.5 = major.minor.path``) before building & uploading the new python wheel package!

The new version **must be unique** & **not already existing** in ``PyPi`` & ``GitHub Releases``!!!

Commit & push the changed version into the ``main`` branch of the repository.

#### 2. Create new Tag

Now, create a new tag from the main branch with the syntax ``vX.X.X`` -> example: ``v1.0.5``.

Use the following commands to create & push the tag:
```
git tag v0.0.5
git push origin v0.0.5
```

#### 2.1. Creating GitHub Release & Deploy Wheel Package to PyPi

After pushing the new tag, three pipeline jobs are getting triggered automatically:
1. First job creates a new ``Release`` in github with the name of the created ``Tag``.
2. Second job uploads the new wheel package to ``PyPi`` with the ``__version__`` from the ``__about__.py`` file.
3. Third job generates a new keyword documentation via ``libdoc`` on the main branch, but pushes it to the ``gh_pages`` where it is available as public ``GitHub Page``.

---

## VS Code Extension Release

The VS Code extension is released **independently** from the Python package via a separate tag prefix (`vsce/v*`), so it does not trigger any PyPI pipelines.

### Precondition

- The extension code in `vscode-extension/` is ready to be released.
- Your local git configuration must work — check your authentication!

### *Preferred* - Using Shell Script for VSIX Release

In the ``root directory`` of this repository you will find a script called ``create_vsce_release.sh``.
It expects exactly one argument: the new version in the syntax ``X.X.X``.

Execute the following command to create a new VSIX release:
```bash
cd <project-root-directory>
./create_vsce_release.sh 0.2.0
```

The script will automatically:
1. Update `"version"` in **[vscode-extension/package.json](vscode-extension/package.json)**
2. Commit & push the version bump to the current branch
3. Create & push the tag `vsce/v0.2.0` to GitHub

After pushing the tag, the pipeline job **Release VS Code Extension** is triggered automatically:
1. Builds the `.vsix` file via `vsce`
2. Creates a new GitHub Release tagged `vsce/v0.2.0` with the `.vsix` as downloadable asset and an installation guide

> [!NOTE]
> The script works from any branch — not only `main`.

### *Backup* - Manual VSIX Release

If the script does not work, follow these steps manually:

#### 1. Update version in package.json

Open **[vscode-extension/package.json](vscode-extension/package.json)** and update the `"version"` field, e.g. `"0.2.0"`.

Commit & push the change:
```bash
git add vscode-extension/package.json
git commit -m "Bump VS Code extension version to 0.2.0"
git push origin HEAD
```

#### 2. Create & push the tag

```bash
git tag -a "vsce/v0.2.0" -m "VS Code Extension Release v0.2.0"
git push origin "vsce/v0.2.0"
```

The GitHub Action will then build and publish the release automatically.

---

## Installing Dev Dependencies

Contributing to this project & working with it locally, requires you to install some ``dev dependencies`` - use the following command in the project root directory:
```
pip install -e .[dev]
```

Afterwards, the library gets installed in ``editable mode`` & you will have a ``dev dependencies`` installed.

## Hatch

You will need the python package tool ``hatch`` for several operations in this repository.
Hatch can be used to execute the linter, the tests or to build a wheel package.

Use the following command:
```shell
pip install hatch
```

### Ececute Linting Checks via ruff

```shell
hatch run dev:lint
```

### Execute Acceptance Tests via PyTest

```shell
hatch run dev:atest
```