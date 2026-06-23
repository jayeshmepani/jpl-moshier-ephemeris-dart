# JPL Moshier Ephemeris Dart

[![pub version](https://img.shields.io/pub/v/jpl_moshier_ephemeris_dart.svg?style=flat-square)](https://pub.dev/packages/jpl_moshier_ephemeris_dart)
[![pub points](https://img.shields.io/pub/points/jpl_moshier_ephemeris_dart?style=flat-square)](https://pub.dev/packages/jpl_moshier_ephemeris_dart)
[![likes](https://img.shields.io/pub/likes/jpl_moshier_ephemeris_dart?style=flat-square)](https://pub.dev/packages/jpl_moshier_ephemeris_dart)
[![dart](https://img.shields.io/badge/dart-3.3%2B-blue.svg?style=flat-square)](https://dart.dev/)
[![flutter](https://img.shields.io/badge/flutter-3.19%2B-blue.svg?style=flat-square)](https://flutter.dev/)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)

Flutter FFI plugin for the JPL Moshier Ephemeris native library.

This package exposes the native `jme_*` API and ships the required runtime binaries for supported mobile and desktop targets. After adding the dependency, no separate native download step is required for the default setup.

## Features

- Direct Dart FFI bindings for the JPL Moshier Ephemeris native API
- Bundled runtimes for Android, iOS, Linux, macOS, and Windows
- JPL mode support through bundled CALCEPH binaries
- Suitable for Flutter applications that need low-level access to the native library

## Supported Platforms

### Android

The published package includes:

- `android/src/main/jniLibs/arm64-v8a/libjme.so`
- `android/src/main/jniLibs/arm64-v8a/libcalceph.so*`
- `android/src/main/jniLibs/x86_64/libjme.so`
- `android/src/main/jniLibs/x86_64/libcalceph.so*`

This covers modern Android devices and x86_64 emulators.

### iOS

The published package includes:

- `ios/Frameworks/Jme.xcframework`
- `ios/Frameworks/Calceph.xcframework`

These frameworks contain device and simulator slices, so iOS consumers do not need to build or fetch them manually.

### Linux

The published package includes:

- `libs/linux-x64/libjme.so`
- `libs/linux-x64/libcalceph.so*`
- `libs/linux-arm64/libjme.so`
- `libs/linux-arm64/libcalceph.so*`

Flutter Linux builds bundle the matching runtime beside the executable, and local package usage can also resolve the libraries directly from the package itself.

### macOS

The published package includes:

- `libs/macos-x64/libjme.dylib`
- `libs/macos-x64/libcalceph.dylib`
- `libs/macos-arm64/libjme.dylib`
- `libs/macos-arm64/libcalceph.dylib`

The macOS plugin stages the matching host-architecture dylibs during pod installation, so a normal Flutter macOS build does not require a separate manual download.

### Windows

The published package includes:

- `libs/windows-x64/jme.dll`
- `libs/windows-x64/calceph.dll`

Flutter Windows builds bundle these DLLs beside the executable.

## Installation

Add the package:

```bash
flutter pub add jpl_moshier_ephemeris_dart
```

or

```bash
dart pub add jpl_moshier_ephemeris_dart
```

That is enough. The plugin already ships the required Android JNI libraries and iOS xcframeworks.
It also ships the desktop runtime payload used by Linux, macOS, and Windows builds.

## Manual Runtime Override

If you need to replace the bundled desktop runtime with a custom build, set:

- `JME_LIBRARY_PATH`
- `JME_CALCEPH_LIBRARY_PATH`

Or download the prebuilt desktop archives from:

- `https://github.com/jayeshmepani/jpl-moshier-ephemeris-php/releases/tag/prebuilt-libs`

Those archives are the same canonical desktop binaries mirrored into this package.

## Quick Start

```dart
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

void main() {
  final jme = JmeEph();
  print(JME_VERSION);
}
```

## Development

Run the local quality checks with:

```bash
./scripts/quality.sh
```

On macOS, if you need to regenerate the iOS frameworks before publishing:

```bash
./scripts/build_ios_xcframework.sh
```

To regenerate Android JNI libraries:

```bash
./scripts/build_android_libs.sh
```

## License

MIT
