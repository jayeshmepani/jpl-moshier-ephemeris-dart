# 1.1.1

* Migrate Android build configuration to Built-in Kotlin (compatible with AGP 9.x and Gradle 9.x).
* Remove independent AGP/KGP buildscript pins from Android library module (`com.android.tools.build:gradle:8.7.3`, `kotlin-android`).
* Upgrade Android `compileSdk` to 36 and Java bytecode compatibility to Java 17.
* Apply `dart fix` and `dart format` modernizations.
* Update `ffi` to `^2.2.0`, `ffigen` to `^22.0.0`, `very_good_analysis` to `^11.0.0`.

# 1.1.0

* Add bundled desktop runtime payloads for Linux, macOS, and Windows.
* Add desktop loader resolution for package-root, package-config, and executable-adjacent runtimes.
* Add Flutter desktop bundling metadata for Linux, macOS, and Windows.

# 1.0.0

*   Initial release of `jpl_moshier_ephemeris_dart`.
*   Full FFI bindings for JPL Moshier Ephemeris (204 functions, 462 constants).
*   Bundled prebuilt binaries for Android (arm64-v8a, armeabi-v7a, x86_64).
*   Support for iOS via XCFramework.
*   Strict analysis with `very_good_analysis`.
