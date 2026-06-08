#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_NATIVE_ROOT="$ROOT_DIR/../../jpl-ephemeris"
NATIVE_ROOT="${1:-${JME_SOURCE_PATH:-$DEFAULT_NATIVE_ROOT}}"
VCPKG_ROOT="${VCPKG_ROOT:-${VCPKG_INSTALLATION_ROOT:-}}"
VCPKG_EXE="${VCPKG_EXE:-$VCPKG_ROOT/vcpkg}"
FRAMEWORK_DIR="$ROOT_DIR/ios/Frameworks"
JME_OUTPUT_DIR="$FRAMEWORK_DIR/Jme.xcframework"
CALCEPH_OUTPUT_DIR="$FRAMEWORK_DIR/Calceph.xcframework"
BUILD_ROOT="${TMPDIR:-/tmp}/jme-ios-build"
OVERLAY_TRIPLETS="$ROOT_DIR/vcpkg-triplets"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "xcodebuild is required to build the iOS xcframework." >&2
  exit 1
fi

if [[ -z "$VCPKG_ROOT" ]]; then
  echo "VCPKG_ROOT or VCPKG_INSTALLATION_ROOT must be set." >&2
  exit 1
fi

if [[ ! -x "$VCPKG_EXE" ]]; then
  echo "vcpkg executable not found: $VCPKG_EXE" >&2
  exit 1
fi

if [[ ! -d "$NATIVE_ROOT" ]]; then
  echo "Native source tree not found: $NATIVE_ROOT" >&2
  exit 1
fi

NATIVE_ROOT="$(cd "$NATIVE_ROOT" && pwd)"
JME_HEADERS_DIR="$NATIVE_ROOT/include"

install_calceph() {
  local triplet="$1"
  "$VCPKG_EXE" install "calceph:$triplet"
}

configure_and_build() {
  local triplet="$1"
  local build_dir="$2"

  cmake -S "$NATIVE_ROOT" -B "$build_dir" -G Xcode \
    -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
    -DVCPKG_TARGET_TRIPLET="$triplet" \
    -DVCPKG_OVERLAY_TRIPLETS="$OVERLAY_TRIPLETS" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY="" \
    -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM="" \
    -DJME_BUILD_TESTS=OFF \
    -DJME_REQUIRE_CALCEPH=ON

  cmake --build "$build_dir" --config Release
}

find_built_library() {
  local root="$1"
  local pattern="$2"
  local path

  path="$(
    find "$root" -type f -name "$pattern" | sort | head -n 1
  )"

  if [[ -z "$path" ]]; then
    echo "Unable to locate $pattern in $root" >&2
    exit 1
  fi

  printf '%s\n' "$path"
}

build_slice() {
  local triplet="$1"
  local name="$2"
  local build_dir="$BUILD_ROOT/$name"

  rm -rf "$build_dir"
  install_calceph "$triplet"
  configure_and_build "$triplet" "$build_dir"
}

merge_simulator_libs() {
  local output_path="$1"
  local arm64_path="$2"
  local x64_path="$3"

  rm -f "$output_path"
  lipo -create "$arm64_path" "$x64_path" -output "$output_path"
}

build_slice "arm64-ios" "device"
build_slice "arm64-ios-simulator" "sim-arm64"
build_slice "x64-ios-simulator" "sim-x64"

rm -rf "$JME_OUTPUT_DIR" "$CALCEPH_OUTPUT_DIR"
mkdir -p "$FRAMEWORK_DIR" "$BUILD_ROOT/universal"

DEVICE_JME_LIB="$(find_built_library "$BUILD_ROOT/device" 'libjme*.a')"
SIM_ARM64_JME_LIB="$(find_built_library "$BUILD_ROOT/sim-arm64" 'libjme*.a')"
SIM_X64_JME_LIB="$(find_built_library "$BUILD_ROOT/sim-x64" 'libjme*.a')"
SIM_UNIVERSAL_JME_LIB="$BUILD_ROOT/universal/libjme-simulator.a"
merge_simulator_libs "$SIM_UNIVERSAL_JME_LIB" "$SIM_ARM64_JME_LIB" "$SIM_X64_JME_LIB"

DEVICE_CALCEPH_LIB="$(find_built_library "$VCPKG_ROOT/installed/arm64-ios/lib" 'libcalceph*.dylib')"
SIM_ARM64_CALCEPH_LIB="$(find_built_library "$VCPKG_ROOT/installed/arm64-ios-simulator/lib" 'libcalceph*.dylib')"
SIM_X64_CALCEPH_LIB="$(find_built_library "$VCPKG_ROOT/installed/x64-ios-simulator/lib" 'libcalceph*.dylib')"
SIM_UNIVERSAL_CALCEPH_LIB="$BUILD_ROOT/universal/libcalceph-simulator.dylib"
merge_simulator_libs "$SIM_UNIVERSAL_CALCEPH_LIB" "$SIM_ARM64_CALCEPH_LIB" "$SIM_X64_CALCEPH_LIB"

CALCEPH_HEADERS_DIR="$VCPKG_ROOT/installed/arm64-ios/include"

xcodebuild -create-xcframework \
  -library "$DEVICE_JME_LIB" -headers "$JME_HEADERS_DIR" \
  -library "$SIM_UNIVERSAL_JME_LIB" -headers "$JME_HEADERS_DIR" \
  -output "$JME_OUTPUT_DIR"

xcodebuild -create-xcframework \
  -library "$DEVICE_CALCEPH_LIB" -headers "$CALCEPH_HEADERS_DIR" \
  -library "$SIM_UNIVERSAL_CALCEPH_LIB" -headers "$CALCEPH_HEADERS_DIR" \
  -output "$CALCEPH_OUTPUT_DIR"

echo "Generated $JME_OUTPUT_DIR"
echo "Generated $CALCEPH_OUTPUT_DIR"
