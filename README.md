# jpl_moshier_ephemeris_dart

Flutter FFI plugin for the **JPL Moshier Ephemeris** native library.

This package provides direct, lossless access to the `jme_*` C API and `JME_*` constants for high-precision astronomical and astrological calculations in Flutter applications.

## Features

*   **100% API Coverage:** All 204 public functions and 462 public constants from the JME native library.
*   **Lossless Work:** Pure FFI bindings with no shaping, normalization, or round-off.
*   **Zero Abstraction:** Direct access to the native C functions for power users.
*   **Modern Dart:** Built with Dart 3.3+ and Flutter 3.19+ support.
*   **Multi-Platform:** Support for Android and iOS.

## Native Integration

This plugin ships its mobile native binaries inside the package itself.
After `dart pub add jpl_moshier_ephemeris_dart` or `flutter pub add jpl_moshier_ephemeris_dart`, no separate native download step is required.

### Android
Supports the following ABIs in `android/src/main/jniLibs/`:
*   `arm64-v8a`: Most modern Android phones.
*   `x86_64`: Android emulators.

The published plugin includes `libjme.so` and `libcalceph.so*` for these ABIs, so Flutter apps can use `ENGINE=JPL` immediately.

### iOS
Supports `arm64` and simulator architectures via `ios/Frameworks/Jme.xcframework`.

The xcframeworks are generated from the native `jpl-ephemeris` source tree on macOS by `scripts/build_ios_xcframework.sh` and by the publish workflow before release.

For JPL mode on iOS, the published plugin ships both:

*   `ios/Frameworks/Jme.xcframework`
*   `ios/Frameworks/Calceph.xcframework`

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  jpl_moshier_ephemeris_dart: ^1.0.0
```

That is enough for consumers. The plugin already contains the Android JNI libraries and iOS xcframeworks required for JPL mode.

## Quick Start

```dart
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

void main() {
  final jme = JmeEph();
  
  // Get version
  // ... (usage example)
}
```

## Quality Assurance

We maintain strict quality standards for the Dart wrapper:

*   **Linting:** `dart analyze` with `very_good_analysis`.
*   **Formatting:** `dart format`.
*   **Verification:** Unit tests covering native integration.

Run the quality check:
```bash
./scripts/quality.sh
```

For a manual publish from macOS, build the iOS xcframework first:

```bash
./scripts/build_ios_xcframework.sh
flutter pub publish
```

## License

MIT License.
