import 'dart:convert';
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
  static const String _packageName = 'jpl_moshier_ephemeris_dart';
  static const String _jmeLibraryName = 'jme';
  static const String _calcephLibraryName = 'calceph';

  /// Finds the platform-appropriate JME shared library path.
  static String findLibraryPath({
    Map<String, String>? environment,
    String? currentDirectory,
    String? executablePath,
  }) =>
      _findPath(
        'JME_LIBRARY_PATH',
        _jmeLibraryName,
        environment: environment,
        currentDirectory: currentDirectory,
        executablePath: executablePath,
      );

  /// Finds the platform-appropriate CALCEPH shared library path.
  static String findCalcephLibraryPath({
    Map<String, String>? environment,
    String? currentDirectory,
    String? executablePath,
  }) =>
      _findPath(
        'JME_CALCEPH_LIBRARY_PATH',
        _calcephLibraryName,
        environment: environment,
        currentDirectory: currentDirectory,
        executablePath: executablePath,
      );

  /// Best-effort preload of CALCEPH so JME can resolve dependent symbols.
  static DynamicLibrary? loadCalcephRuntime() {
    try {
      if (Platform.isAndroid) {
        return DynamicLibrary.open(_filename(_calcephLibraryName));
      }
      if (Platform.isIOS) {
        return null;
      }
      if (_isDesktopPlatform()) {
        return DynamicLibrary.open(findCalcephLibraryPath());
      }
      return null;
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
    if (_isDesktopPlatform()) {
      loadCalcephRuntime();
      return DynamicLibrary.open(findLibraryPath());
    }
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  static String _findPath(
    String envVar,
    String kind, {
    Map<String, String>? environment,
    String? currentDirectory,
    String? executablePath,
  }) {
    final env = environment ?? Platform.environment;
    final envPath = env[envVar];
    if (envPath != null && envPath.isNotEmpty) {
      if (FileSystemEntity.typeSync(envPath) != FileSystemEntityType.notFound) {
        return envPath;
      }
      throw JmeLibraryNotFoundError('$envVar does not exist: $envPath');
    }

    final filename = _filename(kind);
    final candidates = _candidatePaths(
      filename,
      currentDirectory: currentDirectory,
      executablePath: executablePath,
    );
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

  static List<String> _candidatePaths(
    String filename, {
    String? currentDirectory,
    String? executablePath,
  }) {
    final candidates = <String>{};
    final searchRoots = _searchRoots(currentDirectory);

    final executable = executablePath ?? Platform.resolvedExecutable;
    if (executable.isNotEmpty) {
      final executableDir = File(executable).parent.absolute.path;
      candidates.add('$executableDir/$filename');

      if (Platform.isMacOS) {
        final contentsDir = Directory(executableDir).parent.absolute.path;
        candidates.addAll(<String>[
          '$contentsDir/Frameworks/$filename',
          '$contentsDir/Resources/$filename',
        ]);
      }
    }

    for (final root in searchRoots) {
      candidates.add('$root/libs/${_platformDir()}/$filename');
    }

    for (final packageRoot in _packageRoots(searchRoots)) {
      candidates.add('$packageRoot/libs/${_platformDir()}/$filename');
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

  static Set<String> _searchRoots(String? currentDirectory) {
    final current = Directory(
      currentDirectory ?? Directory.current.path,
    ).absolute.path;
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

  static Set<String> _packageRoots(Set<String> searchRoots) {
    for (final root in searchRoots) {
      final packageConfig = File('$root/.dart_tool/package_config.json');
      if (!packageConfig.existsSync()) {
        continue;
      }

      try {
        final decoded = jsonDecode(packageConfig.readAsStringSync())
            as Map<String, Object?>;
        final packages = decoded['packages'];
        if (packages is! List<Object?>) {
          continue;
        }

        for (final entry in packages) {
          if (entry is! Map<String, Object?>) {
            continue;
          }
          if (entry['name'] != _packageName) {
            continue;
          }

          final rootUriRaw = entry['rootUri'];
          if (rootUriRaw is! String || rootUriRaw.isEmpty) {
            continue;
          }

          final rootUri = Uri.parse(rootUriRaw);
          final configRoot = Uri.directory(packageConfig.parent.parent.path);
          final resolvedUri =
              rootUri.isAbsolute ? rootUri : configRoot.resolveUri(rootUri);
          return <String>{Directory.fromUri(resolvedUri).absolute.path};
        }
      } catch (_) {
        continue;
      }
    }

    return const <String>{};
  }

  static bool _isDesktopPlatform() =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

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
