import 'dart:ffi';
import 'dart:io';

/// Raised when no compatible native JME shared library can be located.
class JmeLibraryNotFoundError implements Exception {
  /// Creates a new error with a human-readable [message].
  const JmeLibraryNotFoundError(this.message);

  /// Detailed explanation of the lookup failure.
  final String message;

  @override
  String toString() => 'JmeLibraryNotFoundError: $message';
}

/// Helper to load the native JPL Moshier Ephemeris library.
class JmeLoader {
  static const String _jmeLibraryName = 'jme';
  static const String _calcephLibraryName = 'calceph';

  /// Finds the platform-appropriate JME shared library path.
  static String findLibraryPath() =>
      _findPath('JME_LIBRARY_PATH', _jmeLibraryName);

  /// Finds the platform-appropriate CALCEPH shared library path.
  static String findCalcephLibraryPath() =>
      _findPath('JME_CALCEPH_LIBRARY_PATH', _calcephLibraryName);

  /// Best-effort preload of CALCEPH so JME can resolve dependent symbols.
  static DynamicLibrary? loadCalcephRuntime() {
    try {
      if (Platform.isAndroid) {
        return DynamicLibrary.open(_filename(_calcephLibraryName));
      }
      if (Platform.isIOS) {
        return null;
      }
      return DynamicLibrary.open(findCalcephLibraryPath());
    } on JmeLibraryNotFoundError {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Loads the [DynamicLibrary] based on the current platform.
  static DynamicLibrary load() {
    if (Platform.isAndroid) {
      loadCalcephRuntime();
      return DynamicLibrary.open(_filename(_jmeLibraryName));
    }
    if (Platform.isIOS) {
      // On iOS, symbols are usually statically linked or provided by a framework.
      // DynamicLibrary.process() looks up symbols in the current process.
      return DynamicLibrary.process();
    }
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      loadCalcephRuntime();
      return DynamicLibrary.open(findLibraryPath());
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  static String _findPath(String envVar, String kind) {
    final envPath = Platform.environment[envVar];
    if (envPath != null && envPath.isNotEmpty) {
      if (FileSystemEntity.typeSync(envPath) != FileSystemEntityType.notFound) {
        return envPath;
      }
      throw JmeLibraryNotFoundError('$envVar does not exist: $envPath');
    }

    final filename = _filename(kind);
    final candidates = _candidatePaths(filename);
    for (final candidate in candidates) {
      if (File(candidate).existsSync()) {
        return candidate;
      }
    }

    throw JmeLibraryNotFoundError(
      '${kind.toUpperCase()} library not found. '
      'Searched: ${candidates.join(', ')}',
    );
  }

  static List<String> _candidatePaths(String filename) {
    final candidates = <String>{};

    for (final root in _searchRoots()) {
      candidates.add('$root/libs/${_platformDir()}/$filename');

      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        candidates.add(
          '$root/android/src/main/jniLibs/${_androidAbiForHost()}/$filename',
        );
      }
    }

    if (Platform.isLinux || Platform.isMacOS) {
      candidates.addAll(<String>[
        '/usr/local/lib/$filename',
        '/usr/lib/$filename',
        '/lib/x86_64-linux-gnu/$filename',
        '/lib/aarch64-linux-gnu/$filename',
      ]);
    }

    return candidates.toList(growable: false);
  }

  static Set<String> _searchRoots() {
    final current = Directory.current.absolute.path;
    final roots = <String>{current};
    var cursor = Directory(current);

    while (true) {
      roots.add(cursor.path);
      final parent = cursor.parent;
      if (parent.path == cursor.path) {
        break;
      }
      cursor = parent;
    }

    return roots;
  }

  static String _normalizedArch() {
    final version = Platform.version.toLowerCase();
    if (version.contains('x64') ||
        version.contains('x86_64') ||
        version.contains('amd64')) {
      return 'x64';
    }
    if (version.contains('arm64') || version.contains('aarch64')) {
      return 'arm64';
    }
    return Platform.version;
  }

  static String _platformDir() {
    final arch = _normalizedArch();
    if (Platform.isWindows) {
      return 'windows-$arch';
    }
    if (Platform.isMacOS) {
      return 'macos-$arch';
    }
    return 'linux-$arch';
  }

  static String _androidAbiForHost() {
    final arch = _normalizedArch();
    if (arch == 'arm64') {
      return 'arm64-v8a';
    }
    return 'x86_64';
  }

  static String _filename(String kind) {
    if (kind == _jmeLibraryName) {
      if (Platform.isWindows) {
        return 'jme.dll';
      }
      if (Platform.isMacOS) {
        return 'libjme.dylib';
      }
      return 'libjme.so';
    }

    if (Platform.isWindows) {
      return 'calceph.dll';
    }
    if (Platform.isMacOS) {
      return 'libcalceph.dylib';
    }
    return 'libcalceph.so';
  }
}
