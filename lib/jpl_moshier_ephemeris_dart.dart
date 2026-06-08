import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:jpl_moshier_ephemeris_dart/src/jme_bindings.dart';
import 'package:jpl_moshier_ephemeris_dart/src/jme_loader.dart';

export 'package:jpl_moshier_ephemeris_dart/src/jme_bindings.dart';
export 'package:jpl_moshier_ephemeris_dart/src/jme_loader.dart';
export 'package:jpl_moshier_ephemeris_dart/src/jme_metadata.dart';

/// High-level wrapper for the JPL Moshier Ephemeris library.
class JmeEph {
  /// Creates a new [JmeEph] instance by loading the native library.
  JmeEph([DynamicLibrary? library])
      : bindings = JmeBindings(library ?? JmeLoader.load());

  /// The underlying FFI bindings.
  final JmeBindings bindings;

  /// Helper to configure the engine.
  void configureEngine(
    String engine, {
    String? ephemerisPath,
    String? jplFile,
  }) {
    final normalizedEngine = _normalizeEngine(engine);

    if (ephemerisPath != null && ephemerisPath.isNotEmpty) {
      using((Arena arena) {
        bindings.jme_set_ephemeris_path(
          ephemerisPath.toNativeUtf8(allocator: arena).cast(),
        );
      });
    }

    if (jplFile != null && jplFile.isNotEmpty) {
      using((Arena arena) {
        bindings.jme_set_jpl_file(
          jplFile.toNativeUtf8(allocator: arena).cast(),
        );
      });
    }

    if (normalizedEngine == 'JPL') {
      final kernelPath = _resolveUsableJplKernelPath(ephemerisPath, jplFile);
      using((Arena arena) {
        final error = arena<Char>(256);
        final pathPtr = kernelPath.toNativeUtf8(allocator: arena).cast<Char>();
        bindings.jme_set_jpl_file(pathPtr);
        final openResult = bindings.jme_jpl_open(pathPtr, error);
        if (openResult != JME_OK) {
          throw Exception(
            'ENGINE=JPL is configured but unusable: '
            '${error.cast<Utf8>().toDartString()}',
          );
        }
      });
    }

    using((Arena arena) {
      bindings.jme_set_astro_models(
        'ENGINE=$normalizedEngine'.toNativeUtf8(allocator: arena).cast(),
        0,
      );
    });
  }

  String _normalizeEngine(String engine) {
    switch (engine.toUpperCase()) {
      case 'AUTO':
        return 'AUTO';
      case 'JPL':
        return 'JPL';
      case 'MOSHIER':
        return 'MOSHIER';
      case 'VSOP_ELP_MEEUS':
      case 'ANALYTICAL':
        return 'VSOP_ELP_MEEUS';
      default:
        return engine.toUpperCase();
    }
  }

  String _resolveUsableJplKernelPath(String? ephemerisPath, String? jplFile) {
    final runtimeJplFile = using((Arena arena) {
      final ptr = bindings.jme_jpl_file();
      return ptr == nullptr ? '' : ptr.cast<Utf8>().toDartString();
    });
    final runtimeEphemerisPath = using((Arena arena) {
      final ptr = bindings.jme_ephemeris_path();
      return ptr == nullptr ? '' : ptr.cast<Utf8>().toDartString();
    });

    final candidates = <String>[
      if (jplFile != null && jplFile.isNotEmpty) jplFile,
      if (ephemerisPath != null && ephemerisPath.isNotEmpty) ephemerisPath,
      if (runtimeJplFile.isNotEmpty) runtimeJplFile,
      if (runtimeEphemerisPath.isNotEmpty) runtimeEphemerisPath,
    ];

    for (final candidate in candidates) {
      if (FileSystemEntity.isFileSync(candidate)) {
        return candidate;
      }
      if (FileSystemEntity.isDirectorySync(candidate)) {
        final dir = Directory(candidate);
        final files = dir
            .listSync()
            .where((f) => f.path.toLowerCase().endsWith('.bsp'))
            .map((f) => f.path)
            .toList()
          ..sort();
        if (files.isNotEmpty) {
          return files.first;
        }
      }
    }

    throw Exception(
      'ENGINE=JPL requires a readable .bsp kernel file, but no usable kernel '
      'was found in the configured JPL file or ephemeris path. Download '
      'kernels from: https://github.com/jayeshmepani/jpl-ephemeris/releases/tag/jpl-kernels',
    );
  }
}
