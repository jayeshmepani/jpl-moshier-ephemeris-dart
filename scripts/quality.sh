#!/usr/bin/env bash
set -e

if [[ "$(uname -s)" == "Darwin" ]] && command -v xcodebuild >/dev/null 2>&1; then
  echo "Building iOS xcframework..."
  ./scripts/build_ios_xcframework.sh
fi

if [[ -n "${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}" ]]; then
  echo "Building Android JNI libraries..."
  ./scripts/build_android_libs.sh
fi

# Format check
echo "Running dart format..."
dart format --output=none --set-exit-if-changed .

# Analyze
echo "Running dart analyze..."
dart analyze --fatal-infos

# Tests
echo "Running flutter test..."
flutter test

# Packaging check
echo "Running publish dry-run..."
flutter pub publish --dry-run
