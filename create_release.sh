#!/usr/bin/env bash
set -e

# Script takes one argument: e.g. 0.1.0 or 1.0.0
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <new_version>"
  exit 1
fi

NEW_VERSION="$1"
FILE="src/testdoc/__about__.py"

echo "🔧 Updating version to '${NEW_VERSION}' in '${FILE}'"

# Example: __version__ = "0.0.6"  →  __version__ = "0.0.7"
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -E "s/^(__version__ *= *\")[^\"]+/\1${NEW_VERSION}/" "$FILE"
else
    sed -i.bak -E "s/^(__version__\s*=\s*\")[^\"]+\"/\1${NEW_VERSION}\"/" "$FILE"
fi

rm -f "${FILE}.bak"

git checkout main
git add "$FILE"
git commit -m "Bump version to ${NEW_VERSION}"
git push origin HEAD

git tag -a "v${NEW_VERSION}" -m "Release v${NEW_VERSION}"
git push origin "v${NEW_VERSION}"

echo "✅ Version bumped to '${NEW_VERSION}', committed and tagged. PyPi Release is going to be created... 🚀"
