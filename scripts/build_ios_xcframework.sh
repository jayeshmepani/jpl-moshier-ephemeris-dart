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
OVERLAY_PORTS="$ROOT_DIR/ports"

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
export VCPKG_OVERLAY_TRIPLETS="$OVERLAY_TRIPLETS"
export VCPKG_OVERLAY_PORTS="$OVERLAY_PORTS"

install_calceph() {
  local triplet="$1"
  "$VCPKG_EXE" install "calceph:$triplet"
}

find_calceph_library() {
  local triplet="$1"
  local lib_dir="$VCPKG_ROOT/installed/$triplet/lib"
  local path

  for pattern in 'libcalceph.a' 'libcalceph.dylib' 'libcalceph.*.dylib'; do
    path="$(find "$lib_dir" -maxdepth 1 -type f -name "$pattern" | sort | head -n 1)"
    if [[ -n "$path" ]]; then
      printf '%s\n' "$path"
      return 0
    fi
  done

  echo "Unable to locate CALCEPH library in $lib_dir" >&2
  exit 1
}

write_calceph_config() {
  local triplet="$1"
  local config_dir="$2"
  local include_dir="$VCPKG_ROOT/installed/$triplet/include"
  local lib_path
  local lib_type

  lib_path="$(find_calceph_library "$triplet")"
  lib_type="STATIC"
  if [[ "$lib_path" == *.dylib ]]; then
    lib_type="SHARED"
  fi

  mkdir -p "$config_dir"
  cat > "$config_dir/calcephConfig.cmake" <<EOF
set(calceph_FOUND TRUE)
if(NOT TARGET calceph)
  add_library(calceph ${lib_type} IMPORTED GLOBAL)
  set_target_properties(calceph PROPERTIES
    IMPORTED_LOCATION "${lib_path}"
    INTERFACE_INCLUDE_DIRECTORIES "${include_dir}"
  )
endif()
EOF
}

configure_and_build() {
  local triplet="$1"
  local build_dir="$2"
  local sysroot="$3"
  local architectures="$4"
  local calceph_config_dir="$5"

  cmake -S "$NATIVE_ROOT" -B "$build_dir" -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_SYSROOT="$sysroot" \
    -DCMAKE_OSX_ARCHITECTURES="$architectures" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
    -DCMAKE_PREFIX_PATH="$VCPKG_ROOT/installed/$triplet" \
    -Dcalceph_DIR="$calceph_config_dir" \
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

find_library_with_fallback() {
  local root="$1"
  local primary_pattern="$2"
  local fallback_pattern="$3"
  local path

  path="$(find "$root" -type f -name "$primary_pattern" | sort | head -n 1)"
  if [[ -n "$path" ]]; then
    printf '%s\n' "$path"
    return 0
  fi

  path="$(find "$root" -type f -name "$fallback_pattern" | sort | head -n 1)"
  if [[ -n "$path" ]]; then
    printf '%s\n' "$path"
    return 0
  fi

  echo "Unable to locate $primary_pattern or $fallback_pattern in $root" >&2
  exit 1
}

build_slice() {
  local triplet="$1"
  local name="$2"
  local sysroot="$3"
  local architectures="$4"
  local build_dir="$BUILD_ROOT/$name"
  local calceph_config_dir="$build_dir/calceph-config"

  rm -rf "$build_dir"
  install_calceph "$triplet"
  write_calceph_config "$triplet" "$calceph_config_dir"
  configure_and_build "$triplet" "$build_dir" "$sysroot" "$architectures" "$calceph_config_dir"
}

merge_simulator_libs() {
  local output_path="$1"
  local arm64_path="$2"
  local x64_path="$3"

  rm -f "$output_path"
  lipo -create "$arm64_path" "$x64_path" -output "$output_path"
}

build_slice "arm64-ios" "device" "iphoneos" "arm64"
build_slice "arm64-ios-simulator" "sim-arm64" "iphonesimulator" "arm64"
build_slice "x64-ios-simulator" "sim-x64" "iphonesimulator" "x86_64"

rm -rf "$JME_OUTPUT_DIR" "$CALCEPH_OUTPUT_DIR"
mkdir -p "$FRAMEWORK_DIR" "$BUILD_ROOT/universal"

DEVICE_JME_LIB="$(find_library_with_fallback "$BUILD_ROOT/device" 'libjme*.dylib' 'libjme*.a')"
SIM_ARM64_JME_LIB="$(find_library_with_fallback "$BUILD_ROOT/sim-arm64" 'libjme*.dylib' 'libjme*.a')"
SIM_X64_JME_LIB="$(find_library_with_fallback "$BUILD_ROOT/sim-x64" 'libjme*.dylib' 'libjme*.a')"
SIM_UNIVERSAL_JME_LIB="$BUILD_ROOT/universal/$(basename "$DEVICE_JME_LIB")"
merge_simulator_libs "$SIM_UNIVERSAL_JME_LIB" "$SIM_ARM64_JME_LIB" "$SIM_X64_JME_LIB"

DEVICE_CALCEPH_LIB="$(find_library_with_fallback "$VCPKG_ROOT/installed/arm64-ios/lib" 'libcalceph*.a' 'libcalceph*.dylib')"
SIM_ARM64_CALCEPH_LIB="$(find_library_with_fallback "$VCPKG_ROOT/installed/arm64-ios-simulator/lib" 'libcalceph*.a' 'libcalceph*.dylib')"
SIM_X64_CALCEPH_LIB="$(find_library_with_fallback "$VCPKG_ROOT/installed/x64-ios-simulator/lib" 'libcalceph*.a' 'libcalceph*.dylib')"
SIM_UNIVERSAL_CALCEPH_LIB="$BUILD_ROOT/universal/$(basename "$DEVICE_CALCEPH_LIB")"
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
