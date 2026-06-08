import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:jpl_moshier_ephemeris_dart/src/jme_bindings.dart';
import 'package:jpl_moshier_ephemeris_dart/src/jme_loader.dart';

export 'package:jpl_moshier_ephemeris_dart/src/jme_bindings.dart';

/// High-level wrapper for the JPL Moshier Ephemeris library.
class JmeEph {
  /// Creates a new [JmeEph] instance by loading the native library.
  JmeEph([DynamicLibrary? library])
      : bindings = JmeBindings(library ?? JmeLoader.load());

  /// The underlying FFI bindings.
  final JmeBindings bindings;

  /// Helper to configure the engine, matching the PHP/Python implementation.
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
    // Basic resolution logic similar to PHP
    final candidates =
        [jplFile, ephemerisPath].whereType<String>().where((s) => s.isNotEmpty);

    for (final candidate in candidates) {
      if (FileSystemEntity.isFileSync(candidate)) {
        return candidate;
      }
      if (FileSystemEntity.isDirectorySync(candidate)) {
        final dir = Directory(candidate);
        final files = dir
            .listSync()
            .where((f) => f.path.toLowerCase().endsWith('.bsp'))
            .toList();
        if (files.isNotEmpty) {
          return files.first.path;
        }
      }
    }

    throw Exception('ENGINE=JPL requires a readable .bsp kernel file.');
  }
}
