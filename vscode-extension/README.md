# testdoc – VS Code Extension

Generate Robot Framework test documentation directly from the VS Code Explorer — no terminal required.

## Requirements

- **VS Code** `^1.85.0`
- **Python extension** (`ms-python.python`) installed and configured
- **robotframework-testdoc** installed in your active Python environment:
  ```bash
  pip install robotframework-testdoc
  ```

## Installation

This extension is not published on the VS Code Marketplace.  
Download the latest `.vsix` file from the [GitHub Releases](https://github.com/MarvKler/robotframework-testdoc/releases) page and install it locally.

**Option A – VS Code UI:**
1. Open the Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Click the `...` menu → **Install from VSIX...**
3. Select the downloaded `.vsix` file

**Option B – Terminal:**
```bash
code --install-extension testdoc-vscode-<version>.vsix
```

## Build VSIX Locally

You can build the extension package (`.vsix`) on your machine.

### Prerequisites

- Node.js (LTS recommended)
- npm

### Steps

1. Open a terminal in the extension folder:
  ```bash
  cd vscode-extension
  ```
2. Install dependencies:
  ```bash
  npm install
  ```
3. Build the `.vsix` package:
  ```bash
  npx @vscode/vsce package
  ```
4. The generated file will be in the same folder, for example:
  ```
  testdoc-vscode-0.1.7.vsix
  ```

### Install the locally built package

```bash
code --install-extension testdoc-vscode-<version>.vsix
```

If you want a new package version, update `version` in `vscode-extension/package.json` before running the package command.

## Usage

Right-click any folder in the Explorer and choose one of the available commands:

| Command | Description |
|---|---|
| **testdoc: Generate HTML Documentation** | Generates a self-contained `.html` test documentation file |
| **testdoc: Generate JSON Documentation** | Generates a machine-readable `.json` suite tree |
| **testdoc: Generate PDF Documentation** | Generates a release-friendly `.pdf` report |
| **testdoc: Generate MkDocs Output** | Generates a full MkDocs project into a selected output directory |

### HTML / JSON / PDF

1. Right-click a folder containing your `.robot` files
2. Select **testdoc: Generate HTML Documentation**, **testdoc: Generate JSON Documentation**, or **testdoc: Generate PDF Documentation**
3. A save dialog opens — choose the output file location and name
4. A terminal runs `testdoc` and the file is written to the chosen location

### MkDocs

1. Right-click a folder containing your `.robot` files
2. Select **testdoc: Generate MkDocs Output**
3. A folder picker opens — select an **empty or new** output directory
4. A terminal runs `testdoc --mkdocs` and the MkDocs project is written to the selected directory

> The extension automatically uses the Python interpreter configured for the workspace via the **Python extension**.  
> Make sure `robotframework-testdoc` is installed in that interpreter.

## Troubleshooting

**`python: command not found` / `testdoc: No module named testdoc`**  
→ Select the correct Python interpreter via `Ctrl+Shift+P` → **Python: Select Interpreter** and ensure `robotframework-testdoc` is installed there.

**The context menu commands do not appear**  
→ Right-click must be on a **folder**, not a file.

## Related Links

- [robotframework-testdoc on PyPI](https://pypi.org/project/robotframework-testdoc)
- [Official Documentation](https://marvkler.github.io/robotframework-testdoc/)
- [GitHub Repository](https://github.com/MarvKler/robotframework-testdoc)
