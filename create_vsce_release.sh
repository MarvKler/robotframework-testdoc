#!/usr/bin/env bash
set -e

# Script takes one argument: e.g. 0.1.0 or 1.0.0
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <new_version>"
  exit 1
fi

NEW_VERSION="$1"
FILE="vscode-extension/package.json"

echo "🔧 Updating version to '${NEW_VERSION}' in '${FILE}'"

if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -E "s/(\"version\": \")[^\"]*/\1${NEW_VERSION}/" "$FILE"
else
    sed -i.bak -E "s/(\"version\": \")[^\"]*/\1${NEW_VERSION}/" "$FILE"
fi

rm -f "${FILE}.bak"

git add "$FILE"
git commit -m "Bump VS Code extension version to ${NEW_VERSION}"
git push origin HEAD

git tag -a "vsce/v${NEW_VERSION}" -m "VS Code Extension Release v${NEW_VERSION}"
git push origin "vsce/v${NEW_VERSION}"

echo "✅ VS Code extension version bumped to '${NEW_VERSION}', committed and tagged. VSIX Release is going to be created... 🚀"
