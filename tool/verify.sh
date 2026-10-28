#!/usr/bin/env bash
set -euo pipefail

dart format --output=none --set-exit-if-changed .
dart run build_runner build
git diff --exit-code -- lib/core/database/app_database.g.dart
flutter analyze --fatal-infos
flutter test --coverage
./tool/check_coverage.sh
./tool/secret_scan.sh
flutter build apk --debug
