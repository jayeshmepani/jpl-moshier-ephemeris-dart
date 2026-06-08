# jpl_moshier_ephemeris_dart

Pure Dart FFI wrapper for the **JPL Moshier Ephemeris** native library.

This package provides direct, lossless access to the `jme_*` C API and `JME_*` constants for high-precision astronomical and astrological calculations in Flutter applications.

## Features

*   **100% API Coverage:** All 204 public functions and 462 public constants from the JME native library.
*   **Lossless Work:** Pure FFI bindings with no shaping, normalization, or round-off.
*   **Zero Abstraction:** Direct access to the native C functions for power users.
*   **Modern Dart:** Built with Dart 3.3+ and Flutter 3.19+ support.
*   **Multi-Platform:** Support for Android and iOS.

## Native Integration

This plugin uses prebuilt native binaries for maximum performance and stability.

### Android
Supports the following ABIs in `android/src/main/jniLibs/`:
*   `arm64-v8a`: Most modern Android phones.
*   `armeabi-v7a`: Older ARM devices.
*   `x86_64`: Android emulators.

### iOS
Supports `arm64` and simulator architectures via `ios/Frameworks/Jme.xcframework`.

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

We maintain strict quality standards similar to our PHP and Python wrappers:

*   **Linting:** `dart analyze` with `very_good_analysis`.
*   **Formatting:** `dart format`.
*   **Verification:** Unit tests covering native integration.

Run the quality check:
```bash
./scripts/quality.sh
```

## License

MIT License.
