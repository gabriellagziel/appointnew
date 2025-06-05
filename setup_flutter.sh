#!/bin/bash

# Setup script to install Flutter SDK from a local archive in offline mode.
# 1. Verify that flutter_sdk.tar.xz archive exists at /workspace.
# 2. Extract the archive to /workspace/flutter_sdk.
# 3. Add Flutter and Dart binaries to PATH.
# 4. Verify installation by checking locations and versions.

# Fail on error
set -e

ARCHIVE_PATH="/workspace/flutter_sdk.tar.xz"
SDK_DIR="/workspace/flutter_sdk"

# Step 1: check for archive
if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "ERROR: לא נמצא flutter_sdk.tar.xz ב-/workspace. יש להעלות את הארכיון לריפוזיטורי." >&2
  exit 1
fi

# Step 2: extract the SDK
mkdir -p "$SDK_DIR"
tar -xJf "$ARCHIVE_PATH" -C "$SDK_DIR" --strip-components=1

# Step 3: update PATH
export PATH="$SDK_DIR/bin:$PATH"

# Step 4: verify installation

echo "מיקום flutter:"
which flutter || { echo "flutter לא נמצא ב-PATH" >&2; exit 1; }

echo "מיקום dart:"
which dart || { echo "dart לא נמצא ב-PATH" >&2; exit 1; }

echo "גרסת flutter:"
flutter --version || { echo "שגיאה בהרצת flutter --version" >&2; exit 1; }

echo "גרסת dart:"
dart --version || { echo "שגיאה בהרצת dart --version" >&2; exit 1; }

# Step 5: return to workspace directory and run basic checks
cd /workspace
which flutter
which dart
flutter --version
dart --version

# Step 6: success message
echo "התקנת Flutter ו-Dart הושלמה בהצלחה בסביבת CodeX."

