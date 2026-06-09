# jpl_moshier_ephemeris_dart

Flutter FFI plugin for the JPL Moshier Ephemeris native library.

This package exposes the native `jme_*` API and bundles the required mobile binaries for Android and iOS. After adding the dependency, no separate native download step is required.

## Features

- Direct Dart FFI bindings for the JPL Moshier Ephemeris native API
- Bundled mobile runtimes for Android and iOS
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
