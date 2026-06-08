#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_NATIVE_ROOT="$ROOT_DIR/../../jpl-ephemeris"
NATIVE_ROOT="${1:-${JME_SOURCE_PATH:-$DEFAULT_NATIVE_ROOT}}"
FRAMEWORK_DIR="$ROOT_DIR/ios/Frameworks"
OUTPUT_DIR="$FRAMEWORK_DIR/Jme.xcframework"
BUILD_ROOT="${TMPDIR:-/tmp}/jme-ios-build"
DEVICE_BUILD="$BUILD_ROOT/device"
SIM_BUILD="$BUILD_ROOT/simulator"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild is required to build the iOS xcframework." >&2
  exit 1
fi

if [[ ! -d "$NATIVE_ROOT" ]]; then
  echo "Native source tree not found: $NATIVE_ROOT" >&2
  exit 1
fi

NATIVE_ROOT="$(cd "$NATIVE_ROOT" && pwd)"
HEADERS_DIR="$NATIVE_ROOT/include"

build_slice() {
  local sysroot="$1"
  local archs="$2"
  local build_dir="$3"

  cmake -S "$NATIVE_ROOT" -B "$build_dir" -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_SYSROOT="$sysroot" \
    -DCMAKE_OSX_ARCHITECTURES="$archs" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY="" \
    -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM="" \
    -DJME_BUILD_TESTS=OFF \
    -DJME_REQUIRE_CALCEPH=OFF

  cmake --build "$build_dir" --config Release
}

find_library_file() {
  local build_dir="$1"
  local library_path

  library_path="$(
    find "$build_dir" -type f \( -name 'libjme*.a' -o -name 'libjme*.dylib' \) \
      | sort \
      | head -n 1
  )"

  if [[ -z "$library_path" ]]; then
    echo "Unable to locate built jme library in $build_dir" >&2
    exit 1
  fi

  printf '%s\n' "$library_path"
}

rm -rf "$DEVICE_BUILD" "$SIM_BUILD" "$OUTPUT_DIR"
mkdir -p "$FRAMEWORK_DIR"

build_slice "iphoneos" "arm64" "$DEVICE_BUILD"
build_slice "iphonesimulator" "arm64 x86_64" "$SIM_BUILD"

DEVICE_LIB="$(find_library_file "$DEVICE_BUILD")"
SIM_LIB="$(find_library_file "$SIM_BUILD")"

xcodebuild -create-xcframework \
  -library "$DEVICE_LIB" -headers "$HEADERS_DIR" \
  -library "$SIM_LIB" -headers "$HEADERS_DIR" \
  -output "$OUTPUT_DIR"

echo "Generated $OUTPUT_DIR"
