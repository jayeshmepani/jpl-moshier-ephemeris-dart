#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_NATIVE_ROOT="$ROOT_DIR/../../jpl-ephemeris"
NATIVE_ROOT="${1:-${JME_SOURCE_PATH:-$DEFAULT_NATIVE_ROOT}}"
ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}"
OUTPUT_ROOT="$ROOT_DIR/android/src/main/jniLibs"
BUILD_ROOT="${TMPDIR:-/tmp}/jme-android-build"
ANDROID_API_LEVEL="${ANDROID_API_LEVEL:-21}"

if [[ -z "$ANDROID_NDK_ROOT" ]]; then
  echo "ANDROID_NDK_ROOT or ANDROID_NDK_HOME must be set." >&2
  exit 1
fi

if [[ ! -d "$ANDROID_NDK_ROOT" ]]; then
  echo "Android NDK directory not found: $ANDROID_NDK_ROOT" >&2
  exit 1
fi

if [[ ! -d "$NATIVE_ROOT" ]]; then
  echo "Native source tree not found: $NATIVE_ROOT" >&2
  exit 1
fi

NATIVE_ROOT="$(cd "$NATIVE_ROOT" && pwd)"

build_abi() {
  local abi="$1"
  local build_dir="$BUILD_ROOT/$abi"
  local output_dir="$OUTPUT_ROOT/$abi"
  local lib_path

  rm -rf "$build_dir" "$output_dir"
  mkdir -p "$output_dir"

  cmake -S "$NATIVE_ROOT" -B "$build_dir" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$abi" \
    -DANDROID_PLATFORM="android-$ANDROID_API_LEVEL" \
    -DCMAKE_BUILD_TYPE=Release \
    -DJME_BUILD_TESTS=OFF \
    -DJME_REQUIRE_CALCEPH=OFF

  cmake --build "$build_dir" --parallel

  lib_path="$(
    find "$build_dir" -type f -name 'libjme.so' | sort | head -n 1
  )"

  if [[ -z "$lib_path" ]]; then
    echo "Unable to locate libjme.so for ABI $abi" >&2
    exit 1
  fi

  cp "$lib_path" "$output_dir/libjme.so"
}

build_abi "arm64-v8a"
build_abi "x86_64"

echo "Generated Android JNI libraries under $OUTPUT_ROOT"
