import 'dart:ffi';
import 'dart:io';

/// Helper to load the native JPL Moshier Ephemeris library.
class JmeLoader {
  static const String _libName = 'jme';

  /// Loads the [DynamicLibrary] based on the current platform.
  static DynamicLibrary load() {
    if (Platform.isAndroid) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    if (Platform.isIOS || Platform.isMacOS) {
      // On iOS, symbols are usually statically linked or provided by a framework.
      // DynamicLibrary.process() looks up symbols in the current process.
      return DynamicLibrary.process();
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('$_libName.dll');
    }
    if (Platform.isLinux) {
      return DynamicLibrary.open('lib$_libName.so');
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}
