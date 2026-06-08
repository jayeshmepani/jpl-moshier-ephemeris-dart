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

This plugin uses bundled native binaries for mobile integration.

### Android
Supports the following ABIs in `android/src/main/jniLibs/`:
*   `arm64-v8a`: Most modern Android phones.
*   `x86_64`: Android emulators.

The Android release workflow regenerates `libjme.so` for these ABIs from source. CALCEPH is optional in mobile builds unless you add a mobile CALCEPH build path.

### iOS
Supports `arm64` and simulator architectures via `ios/Frameworks/Jme.xcframework`.

The xcframework is generated from the native `jpl-ephemeris` source tree on macOS by `scripts/build_ios_xcframework.sh` and by the publish workflow before release.

Current iOS packaging focuses on the core analytical engine surface. JPL kernel mode depends on CALCEPH availability in the Apple build you ship.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  jpl_moshier_ephemeris_dart: ^1.0.0
```

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
