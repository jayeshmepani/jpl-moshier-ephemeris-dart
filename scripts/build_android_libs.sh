#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_NATIVE_ROOT="$ROOT_DIR/../../jpl-ephemeris"
NATIVE_ROOT="${1:-${JME_SOURCE_PATH:-$DEFAULT_NATIVE_ROOT}}"
ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}"
OUTPUT_ROOT="$ROOT_DIR/android/src/main/jniLibs"
BUILD_ROOT="${TMPDIR:-/tmp}/jme-android-build"
CALCEPH_VERSION="4.0.5"
CALCEPH_ARCHIVE="calceph-${CALCEPH_VERSION}.tar.gz"
CALCEPH_SHA512_IMCCE="d3f17a302dafee243a3c7698dd5b7e67550ba070cd3217c399e2cee5f90486d2be394ddcfe6dcc1b72f980e212d19bda50c4057fca05b032f6558794f191935a"
CALCEPH_SHA512_DEBIAN="a7005b78d61e94e84b15ddba858f8877b6b4d73ba8c91166508a5b345fca788a0f670ad70f108234a6ae8b82d1554745c43f4f4ce7fcc147b7b4ba50cf1be0a4"
CALCEPH_URLS=(
  "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/${CALCEPH_ARCHIVE}"
  "https://deb.debian.org/debian/pool/main/c/calceph/calceph_${CALCEPH_VERSION}.orig.tar.gz"
)
PATCH_DIR="$ROOT_DIR/ports/calceph"
DOWNLOAD_DIR="$BUILD_ROOT/downloads"
CALCEPH_SOURCE_DIR="$BUILD_ROOT/calceph-src"

if [[ -z "$ANDROID_NDK_ROOT" ]]; then
  echo "ANDROID_NDK_ROOT or ANDROID_NDK_HOME must be set for Android builds." >&2
  exit 1
fi

if [[ ! -d "$NATIVE_ROOT" ]]; then
  echo "Native source tree not found: $NATIVE_ROOT" >&2
  exit 1
fi

NATIVE_ROOT="$(cd "$NATIVE_ROOT" && pwd)"

download_calceph_source() {
  local archive_path="$DOWNLOAD_DIR/$CALCEPH_ARCHIVE"
  local temp_path hash

  mkdir -p "$DOWNLOAD_DIR"

  if [[ -f "$archive_path" ]]; then
    hash="$(sha512sum "$archive_path" | awk '{print $1}')"
    if [[ "$hash" == "$CALCEPH_SHA512_IMCCE" || "$hash" == "$CALCEPH_SHA512_DEBIAN" ]]; then
      printf '%s\n' "$archive_path"
      return 0
    fi
    rm -f "$archive_path"
  fi

  for url in "${CALCEPH_URLS[@]}"; do
    temp_path="$archive_path.part"
    rm -f "$temp_path"
    echo "Downloading CALCEPH source: $url" >&2
    if curl -fL --retry 2 --connect-timeout 30 --max-time 300 -o "$temp_path" "$url"; then
      hash="$(sha512sum "$temp_path" | awk '{print $1}')"
      if [[ "$hash" == "$CALCEPH_SHA512_IMCCE" || "$hash" == "$CALCEPH_SHA512_DEBIAN" ]]; then
        mv "$temp_path" "$archive_path"
        printf '%s\n' "$archive_path"
        return 0
      fi
      echo "Unexpected CALCEPH archive hash from $url" >&2
      echo "Actual: $hash" >&2
    fi
    rm -f "$temp_path"
  done

  echo "Unable to download a trusted CALCEPH source archive." >&2
  exit 1
}

prepare_calceph_source() {
  local archive_path="$1"

  rm -rf "$CALCEPH_SOURCE_DIR"
  mkdir -p "$CALCEPH_SOURCE_DIR"

  tar -xzf "$archive_path" -C "$CALCEPH_SOURCE_DIR" --strip-components=1

  patch -d "$CALCEPH_SOURCE_DIR" -p1 < "$PATCH_DIR/disable-gnu-source.diff"
  patch -d "$CALCEPH_SOURCE_DIR" -p1 < "$PATCH_DIR/find-mathlib.diff"
}

copy_calceph_runtime_artifacts() {
  local runtime_prefix="$1"
  local output_dir="$2"
  local file="$runtime_prefix/lib/libcalceph.so"

  if [[ ! -f "$file" ]]; then
    echo "Shared CALCEPH runtime not found: $file" >&2
    exit 1
  fi

  cp -L "$file" "$output_dir/libcalceph.so"
}

write_calceph_config() {
  local install_prefix="$1"
  local config_dir="$2"
  local include_dir="$install_prefix/include"
  local lib_path="$install_prefix/lib/libcalceph.a"

  if [[ ! -f "$lib_path" ]]; then
    echo "Static CALCEPH library not found: $lib_path" >&2
    exit 1
  fi

  mkdir -p "$config_dir"
  cat > "$config_dir/calcephConfig.cmake" <<EOF
set(calceph_FOUND TRUE)
if(NOT TARGET calceph)
  add_library(calceph STATIC IMPORTED GLOBAL)
  set_target_properties(calceph PROPERTIES
    IMPORTED_LOCATION "${lib_path}"
    INTERFACE_INCLUDE_DIRECTORIES "${include_dir}"
  )
endif()
EOF
}

build_calceph_variant() {
  local abi="$1"
  local android_abi="$2"
  local source_dir="$3"
  local build_dir="$4"
  local install_prefix="$5"
  local build_shared="$6"

  rm -rf "$build_dir" "$install_prefix"

  cmake -S "$source_dir" -B "$build_dir" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$android_abi" \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$install_prefix" \
    -DBUILD_SHARED_LIBS="$build_shared" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DENABLE_THREAD=ON \
    -DENABLE_FORTRAN=OFF \
    -DBUILD_TESTING=OFF

  cmake --build "$build_dir" --parallel
  cmake --install "$build_dir"

  if [[ "$build_shared" == "ON" && ! -f "$install_prefix/lib/libcalceph.so" ]]; then
    echo "Shared CALCEPH runtime was not produced for ABI $abi" >&2
    exit 1
  fi

  if [[ "$build_shared" == "OFF" && ! -f "$install_prefix/lib/libcalceph.a" ]]; then
    echo "Static CALCEPH library was not produced for ABI $abi" >&2
    exit 1
  fi
}

build_abi() {
  local abi="$1"
  local android_abi="$2"
  local build_dir="$BUILD_ROOT/$abi"
  local output_dir="$OUTPUT_ROOT/$abi"
  local source_dir="$build_dir/calceph-source"
  local static_build_dir="$build_dir/calceph-static-build"
  local shared_build_dir="$build_dir/calceph-shared-build"
  local static_prefix="$build_dir/calceph-static"
  local shared_prefix="$build_dir/calceph-shared"
  local calceph_config_dir="$build_dir/calceph-config"
  local lib_path archive_path

  rm -rf "$build_dir" "$output_dir"
  mkdir -p "$build_dir" "$output_dir"

  archive_path="$(download_calceph_source)"
  prepare_calceph_source "$archive_path"
  cp -R "$CALCEPH_SOURCE_DIR" "$source_dir"
  build_calceph_variant "$abi" "$android_abi" "$source_dir" "$static_build_dir" "$static_prefix" OFF

  rm -rf "$source_dir"
  cp -R "$CALCEPH_SOURCE_DIR" "$source_dir"
  build_calceph_variant "$abi" "$android_abi" "$source_dir" "$shared_build_dir" "$shared_prefix" ON

  write_calceph_config "$static_prefix" "$calceph_config_dir"

  cmake -S "$NATIVE_ROOT" -B "$build_dir/jme" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$android_abi" \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$static_prefix" \
    -DCMAKE_FIND_ROOT_PATH="$static_prefix" \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH \
    -Dcalceph_DIR="$calceph_config_dir" \
    -DJME_BUILD_TESTS=OFF \
    -DJME_REQUIRE_CALCEPH=ON

  cmake --build "$build_dir/jme" --parallel

  lib_path="$(
    find "$build_dir/jme" -type f -name 'libjme.so' | sort | head -n 1
  )"

  if [[ -z "$lib_path" ]]; then
    echo "Unable to locate libjme.so for ABI $abi" >&2
    exit 1
  fi

  cp "$lib_path" "$output_dir/libjme.so"
  copy_calceph_runtime_artifacts "$shared_prefix" "$output_dir"
}

build_abi "arm64-v8a" "arm64-v8a"
build_abi "x86_64" "x86_64"

echo "Generated Android JNI libraries under $OUTPUT_ROOT"
