#!/usr/bin/env bash

set -euo pipefail

trap 'echo "Error: Flutter and Dart installation failed." >&2' ERR

ARCHIVE="flutter_sdk.tar.xz"
SDK_DIR="/workspace/flutter_sdk"

if [[ ! -f "${ARCHIVE}" ]]; then
  echo "Error: ${ARCHIVE} not found in $(pwd)." >&2
  exit 1
fi

mkdir -p "${SDK_DIR}"
tar -xf "${ARCHIVE}" -C "${SDK_DIR}"

export PATH="${SDK_DIR}/bin:${SDK_DIR}/bin/cache/dart-sdk/bin:${PATH}"

which flutter
which dart
flutter --version
dart --version

echo "Flutter and Dart installation succeeded."

