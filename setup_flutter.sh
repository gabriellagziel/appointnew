#!/usr/bin/env bash
set -euo pipefail

trap 'echo "Error: Flutter and Dart installation failed." >&2' ERR

SDK_ARCHIVE="flutter_sdk.tar.xz"
TARGET_DIR="/workspace/flutter_sdk"

if [[ ! -f "$SDK_ARCHIVE" ]]; then
  echo "Error: $SDK_ARCHIVE not found in $(pwd)" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"

# Extract the SDK archive
 tar -xJf "$SDK_ARCHIVE" -C "$TARGET_DIR" --strip-components=1

# Update PATH for flutter and dart
export PATH="$TARGET_DIR/bin:$TARGET_DIR/bin/cache/dart-sdk/bin:$PATH"

# Verify flutter and dart commands
which flutter
echo "flutter path: $(which flutter)"
which dart
echo "dart path: $(which dart)"

flutter --version
dart --version

echo "Flutter and Dart installation succeeded."

