const vscode = require('vscode');
const path = require('path');

/**
 * Resolves the Python executable path from the active ms-python interpreter.
 * Falls back to 'python3' if the Python extension is not available.
 * @param {vscode.Uri} resourceUri  A URI within the target workspace folder.
 * @returns {Promise<string>}
 */
async function getPythonPath(resourceUri) {
  const pythonExt = vscode.extensions.getExtension('ms-python.python');
  if (pythonExt) {
    if (!pythonExt.isActive) {
      await pythonExt.activate();
    }
    // The Python extension exposes the active interpreter path via its public API.
    const execDetails = pythonExt.exports?.settings?.getExecutionDetails?.(resourceUri);
    const execCommand = execDetails?.execCommand;
    if (Array.isArray(execCommand) && execCommand.length > 0) {
      return execCommand[0];
    }
  }
  return 'python3';
}

/**
 * Runs testdoc via `<python> -m testdoc` in a dedicated terminal.
 * @param {vscode.Uri} folderUri   The folder selected in the Explorer.
 * @param {'html'|'json'} format   Output format.
 */
async function runTestdoc(folderUri, format) {
  const folderPath = folderUri.fsPath;
  const ext = format === 'json' ? 'json' : 'html';
  const folderName = path.basename(folderPath);

  const now = new Date();
  const pad = (n) => String(n).padStart(2, '0');
  const timestamp = `${pad(now.getDate())}${pad(now.getMonth() + 1)}${pad(now.getFullYear() % 100)}${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;

  // Ask user where to save the output file.
  const defaultUri = vscode.Uri.file(path.join(folderPath, `test_documentation_${timestamp}.${ext}`));
  const saveUri = await vscode.window.showSaveDialog({
    defaultUri,
    filters: format === 'json'
      ? { 'JSON': ['json'] }
      : { 'HTML': ['html'] },
    title: `Save TestDoc ${format.toUpperCase()} output`,
  });

  if (!saveUri) {
    return; // User cancelled
  }

  const outputPath = saveUri.fsPath;
  const pythonPath = await getPythonPath(folderUri);

  const terminal = vscode.window.createTerminal({
    name: `testdoc (${folderName})`,
    cwd: path.dirname(folderPath),
  });
  terminal.show();
  terminal.sendText(`"${pythonPath}" -m testdoc -f ${format} "${folderPath}" "${outputPath}"`);
}

/**
 * Runs testdoc in MkDocs mode. Output must be a directory, not a file.
 * @param {vscode.Uri} folderUri   The folder selected in the Explorer.
 */
async function runTestdocMkdocs(folderUri) {
  const folderPath = folderUri.fsPath;
  const folderName = path.basename(folderPath);

  // Ask user to pick (or create) an output directory.
  const outputUris = await vscode.window.showOpenDialog({
    defaultUri: vscode.Uri.file(path.dirname(folderPath)),
    canSelectFiles: false,
    canSelectFolders: true,
    canSelectMany: false,
    openLabel: 'Select Output Directory',
    title: 'testdoc: Select MkDocs output directory',
  });

  if (!outputUris || outputUris.length === 0) {
    return; // User cancelled
  }

  const outputPath = outputUris[0].fsPath;
  const pythonPath = await getPythonPath(folderUri);

  const terminal = vscode.window.createTerminal({
    name: `testdoc mkdocs (${folderName})`,
    cwd: path.dirname(folderPath),
  });
  terminal.show();
  terminal.sendText(`"${pythonPath}" -m testdoc --mkdocs "${folderPath}" "${outputPath}"`);
}

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand('testdoc.generateHtml', (uri) => runTestdoc(uri, 'html')),
    vscode.commands.registerCommand('testdoc.generateJson', (uri) => runTestdoc(uri, 'json')),
    vscode.commands.registerCommand('testdoc.generateMkdocs', (uri) => runTestdocMkdocs(uri)),
  );
}

function deactivate() {}

module.exports = { activate, deactivate };
