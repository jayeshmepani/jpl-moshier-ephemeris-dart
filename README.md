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

## Credits

This package is a binding for [JPL Moshier Ephemeris (JME)](https://github.com/jayeshmepani/jpl-ephemeris) by Jayesh Mepani (Jayesh Patel). JME builds on:

- **JPL DE440 / DE441** ephemerides (NASA/JPL; Park et al. 2021). Kernels are downloaded separately and are redistributed unmodified per the NAIF rules.
- **CALCEPH 4.0.5** (Copyright 2008-2025 CNRS, Observatoire de Paris, Observatoire de la Côte d'Azur), used under the CeCILL-B license. Prebuilt CALCEPH runtime libraries are bundled unmodified; license text in [`LICENSES/CeCILL-B.txt`](LICENSES/CeCILL-B.txt); provided without warranty (CeCILL-B Articles 8 and 9); source code at https://calceph.imcce.fr/.
- **Stephen L. Moshier**: plan404 and Astronomical Almanac 5.6 analytical theories (Moshier engine). No explicit license; permission requested.
- **ELP2000-82B** by M. Chapront-Touzé and J. Chapront (CDS VI/79); C implementation by Serhii Tsyba. No license file; permission requested.
- **VSOP87** by P. Bretagnon and G. Francou (CDS VI/81); C code from Greg A. Miller's VSOP87-Multilang (public domain dedication).
- **Jean Meeus**, *Astronomical Algorithms* (formulas cited); **F. Espenak and J. Meeus** (NASA) ΔT polynomials; **ERFA** (BSD 3-Clause, NumFOCUS Foundation) IAU 2000B nutation; **Yale Bright Star Catalogue** (Hoffleit and Warren).

Full credits, terms, and required notice texts: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## License

The original code in this repository is licensed under the [MIT License](LICENSE), Copyright (c) 2026 Jayesh Mepani (Jayesh Patel).

**Scope:** MIT applies to the original code in this repository; third-party components keep their own terms, see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). The bundled CALCEPH runtime libraries are licensed under CeCILL-B, not MIT. The bundled JME runtime libraries include the Moshier and ELP2000-82B components described there, which are not covered by the MIT License.
