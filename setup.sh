#!/bin/bash
set -euo pipefail

# 1. Update package lists and install prerequisites
apt-get update
apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# 2. Clone the Flutter repository into /opt/flutter
git clone https://github.com/flutter/flutter.git /opt/flutter

# 3. Add Flutter (and its bundled Dart) to PATH
export PATH="/opt/flutter/bin:$PATH"

# 4. (Optional) Verify that flutter/dart is working
flutter --version
dart --version
