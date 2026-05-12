# :material-microsoft-visual-studio-code: VS Code Extension

The **testdoc VS Code Extension** brings test documentation generation directly into VS Code — no terminal required.  
Right-click any folder in the Explorer and generate HTML, JSON or MkDocs documentation in seconds.

## :material-cog: Requirements

- VS Code `^1.85.0`
- [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) (`ms-python.python`) installed and active
- `robotframework-testdoc` installed in the active Python environment:

```shell
pip install robotframework-testdoc
```

## :material-download: Installation

The extension is not published on the VS Code Marketplace. Download the latest `.vsix` from the [GitHub Releases](https://github.com/MarvKler/robotframework-testdoc/releases?q=VS+Code+Extension&expanded=true) page (look for releases tagged `vsce/v*`).

**Option A – VS Code UI:**

1. Open the Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Click the `...` menu → **Install from VSIX...**
3. Select the downloaded `.vsix` file

**Option B – Terminal:**

```bash
code --install-extension testdoc-vscode-<version>.vsix
```

**Option C - One-Line-Command**

In the description for the [VS Code Extension GitHub Release](https://github.com/MarvKler/robotframework-testdoc/releases?q=VS+Code+Extension&expanded=true) you can find a ``one-line-command`` which can be used for the download and installation.

Here is an example for Linux, but please visit the GitHub Releases Page to figure out the exact command for the latest available version:
**Linux / macOS:**
```bash
curl -L -o testdoc-vscode-{{ version }}.vsix https://github.com/MarvKler/robotframework-testdoc/releases/download/vsce%2Fv{{ version }}/testdoc-vscode-{{ version }}.vsix && code --install-extension testdoc-vscode-{{ version }}.vsix
```

## :material-test-tube: Usage

Right-click any folder in the **Explorer** panel that contains your `.robot` files:

| Command | Output |
|---|---|
| **testdoc: Generate HTML Documentation** | Self-contained `.html` file |
| **testdoc: Generate JSON Documentation** | Machine-readable `.json` suite tree |
| **testdoc: Generate MkDocs Output** | Full MkDocs project in a selected directory |

### HTML / JSON

1. Right-click a folder with `.robot` files
2. Select **testdoc: Generate HTML Documentation** or **testdoc: Generate JSON Documentation**
3. Choose a save location in the dialog that opens
4. A terminal executes `testdoc` and writes the file

### MkDocs

1. Right-click a folder with `.robot` files
2. Select **testdoc: Generate MkDocs Output**
3. Pick an output directory in the folder picker
4. A terminal executes `testdoc --mkdocs` and writes the MkDocs project

!!! info "Python Interpreter"
    The extension automatically uses the interpreter configured for the workspace via the Python extension.  
    Make sure `robotframework-testdoc` is installed in that interpreter.

## :material-wrench: Troubleshooting

**`No module named testdoc`**  
→ Open `Ctrl+Shift+P` → **Python: Select Interpreter** and select the environment where `robotframework-testdoc` is installed.

**Context menu commands do not appear**  
→ The right-click must be on a **folder**, not a file.
