#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_NATIVE_ROOT="$ROOT_DIR/../../jpl-ephemeris"
NATIVE_ROOT="${1:-${JME_SOURCE_PATH:-$DEFAULT_NATIVE_ROOT}}"
VCPKG_ROOT="${VCPKG_ROOT:-${VCPKG_INSTALLATION_ROOT:-}}"
VCPKG_EXE="${VCPKG_EXE:-$VCPKG_ROOT/vcpkg}"
ANDROID_NDK_ROOT="${ANDROID_NDK_ROOT:-${ANDROID_NDK_HOME:-}}"
OUTPUT_ROOT="$ROOT_DIR/android/src/main/jniLibs"
BUILD_ROOT="${TMPDIR:-/tmp}/jme-android-build"
OVERLAY_TRIPLETS="$ROOT_DIR/vcpkg-triplets"
CALCEPH_ARCHIVE_NAME="calceph-4.0.5.tar.gz"
CALCEPH_ARCHIVE_PATH="$VCPKG_ROOT/downloads/$CALCEPH_ARCHIVE_NAME"

if [[ -z "$VCPKG_ROOT" ]]; then
  echo "VCPKG_ROOT or VCPKG_INSTALLATION_ROOT must be set." >&2
  exit 1
fi

if [[ ! -x "$VCPKG_EXE" ]]; then
  echo "vcpkg executable not found: $VCPKG_EXE" >&2
  exit 1
fi

if [[ -z "$ANDROID_NDK_ROOT" ]]; then
  echo "ANDROID_NDK_ROOT or ANDROID_NDK_HOME must be set for Android CALCEPH builds." >&2
  exit 1
fi

if [[ ! -d "$NATIVE_ROOT" ]]; then
  echo "Native source tree not found: $NATIVE_ROOT" >&2
  exit 1
fi

NATIVE_ROOT="$(cd "$NATIVE_ROOT" && pwd)"
export VCPKG_OVERLAY_TRIPLETS="$OVERLAY_TRIPLETS"

ensure_calceph_source() {
  local url

  if [[ -f "$CALCEPH_ARCHIVE_PATH" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$CALCEPH_ARCHIVE_PATH")"

  for url in \
    "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/$CALCEPH_ARCHIVE_NAME" \
    "https://deb.debian.org/debian/pool/main/c/calceph/calceph_4.0.5.orig.tar.gz"
  do
    if curl --fail --location --retry 5 --retry-all-errors --connect-timeout 30 --max-time 600 \
      --output "$CALCEPH_ARCHIVE_PATH" "$url"; then
      return 0
    fi
  done

  echo "Unable to download $CALCEPH_ARCHIVE_NAME from known mirrors." >&2
  exit 1
}

copy_calceph_artifacts() {
  local triplet="$1"
  local output_dir="$2"
  local vcpkg_lib_dir="$VCPKG_ROOT/installed/$triplet/lib"

  if [[ ! -d "$vcpkg_lib_dir" ]]; then
    echo "CALCEPH library directory not found: $vcpkg_lib_dir" >&2
    exit 1
  fi

  find "$vcpkg_lib_dir" -maxdepth 1 -type f -name 'libcalceph.so*' | while read -r file; do
    cp "$file" "$output_dir/"
  done
}

build_abi() {
  local abi="$1"
  local triplet="$2"
  local build_dir="$BUILD_ROOT/$abi"
  local output_dir="$OUTPUT_ROOT/$abi"
  local android_abi="$3"
  local lib_path

  rm -rf "$build_dir" "$output_dir"
  mkdir -p "$output_dir"

  ensure_calceph_source
  "$VCPKG_EXE" install "calceph:$triplet"

  cmake -S "$NATIVE_ROOT" -B "$build_dir" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$android_abi" \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$VCPKG_ROOT/installed/$triplet" \
    -Dcalceph_DIR="$VCPKG_ROOT/installed/$triplet/share/calceph" \
    -DJME_BUILD_TESTS=OFF \
    -DJME_REQUIRE_CALCEPH=ON

  cmake --build "$build_dir" --parallel

  lib_path="$(
    find "$build_dir" -type f -name 'libjme.so' | sort | head -n 1
  )"

  if [[ -z "$lib_path" ]]; then
    echo "Unable to locate libjme.so for ABI $abi" >&2
    exit 1
  fi

  cp "$lib_path" "$output_dir/libjme.so"
  copy_calceph_artifacts "$triplet" "$output_dir"
}

build_abi "arm64-v8a" "arm64-android-dynamic" "arm64-v8a"
build_abi "x86_64" "x64-android-dynamic" "x86_64"

echo "Generated Android JNI libraries under $OUTPUT_ROOT"
