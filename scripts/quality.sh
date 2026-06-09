#!/usr/bin/env bash
set -e

if [[ "$(uname -s)" == "Darwin" ]] && command -v xcodebuild >/dev/null 2>&1 && [[ -n "${VCPKG_ROOT:-${VCPKG_INSTALLATION_ROOT:-}}" ]]; then
  echo "Building iOS xcframework..."
  ./scripts/build_ios_xcframework.sh
fi

if [[ -n "${VCPKG_ROOT:-${VCPKG_INSTALLATION_ROOT:-}}" ]] && [[ -n "${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}" ]]; then
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
publish_output="$(mktemp)"
if flutter pub publish --dry-run >"$publish_output" 2>&1; then
  cat "$publish_output"
else
  cat "$publish_output"
  if grep -q 'checked-in files are modified in git' "$publish_output"; then
    echo "Publish dry-run reported a dirty git worktree. Commit the packaged binaries, then rerun the dry-run before publishing."
  else
    rm -f "$publish_output"
    exit 1
  fi
fi
rm -f "$publish_output"
