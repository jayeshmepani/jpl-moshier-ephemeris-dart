import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

bool _hasBundledHostJme() {
  try {
    return File(JmeLoader.findLibraryPath()).existsSync();
  } on JmeLibraryNotFoundError {
    return false;
  }
}

bool _hasBundledHostCalceph() {
  try {
    return File(JmeLoader.findCalcephLibraryPath()).existsSync();
  } on JmeLibraryNotFoundError {
    return false;
  }
}

String _normalizePath(String path) =>
    path.replaceAll(r'\', '/').replaceAll('//', '/');

String _hostLibraryFilename(String kind) {
  if (kind == 'jme') {
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

String _hostPlatformDir() {
  final version = Platform.version.toLowerCase();
  final arch = version.contains('arm64') || version.contains('aarch64')
      ? 'arm64'
      : 'x64';
  if (Platform.isWindows) {
    return 'windows-$arch';
  }
  if (Platform.isMacOS) {
    return 'macos-$arch';
  }
  return 'linux-$arch';
}

void main() {
  group('surface parity', () {
    test('exports the same 204 native functions as the bundled header', () {
      final header = File('src/include/jme/jme.h').readAsStringSync();
      final headerFunctions = RegExp(r'\b(jme_[A-Za-z0-9_]+)\s*\(')
          .allMatches(header)
          .map((match) => match.group(1)!)
          .toSet()
          .toList()
        ..sort();

      expect(headerFunctions, hasLength(204));
      expect(signatureNames().toList(), orderedEquals(headerFunctions));
    });

    test('exports the same 462 tracked constants as the bundled header', () {
      final header = File('src/include/jme/jme.h').readAsStringSync();
      final headerConstants = RegExp(r'\b(JME_[A-Z0-9_]+)\b')
          .allMatches(header)
          .map((match) => match.group(1)!)
          .where((name) => name != 'JME_H')
          .toSet()
          .toList()
        ..sort();

      expect(headerConstants, hasLength(462));
      expect(constantNames().toList(), orderedEquals(headerConstants));
    });

    test('matches the native core constant contract', () {
      expect(JME_VERSION, '0.1.0');
      expect(JME_OK, 0);
      expect(JME_ERR, -1);
      expect(JME_BODY_SUN, 0);
      expect(JME_BODY_MOON, 1);
      expect(JME_BODY_MEAN_NODE, 21);
      expect(JME_BODY_TRUE_NODE, 22);
      expect(JME_CALC_SPEED, 1);
      expect(JME_CALC_SIDEREAL, 512);
      expect(JME_CALC_NO_ABERRATION, 1024);
      expect(JME_CALC_NO_LIGHT_DEFLECTION, 2048);
      expect(JME_CALC_TOPOCENTRIC, 131072);
      expect(JME_RISE_RISE, 1);
      expect(JME_RISE_SET, 2);
      expect(JME_RISE_MERIDIAN_TRANSIT, 4);
      expect(JME_HOUSE_AZIMUTHAL, 314);
      expect(JME_HOUSE_HORIZONTAL, 318);
      expect(JME_CALENDAR_GREGORIAN, 1);
      expect(JME_CALENDAR_JULIAN, 0);
    });
  });

  group('loader parity', () {
    test('honors explicit environment overrides', () {
      final tempDir = Directory.systemTemp.createTempSync('jme-loader-env-');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final jmePath = '${tempDir.path}/${_hostLibraryFilename('jme')}';
      File(jmePath).writeAsStringSync('stub');

      expect(
        JmeLoader.findLibraryPath(
          environment: {'JME_LIBRARY_PATH': jmePath},
        ),
        jmePath,
      );
    });

    test('finds bundled desktop libraries via package_config roots', () {
      final tempDir = Directory.systemTemp.createTempSync('jme-loader-pkg-');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final packageRoot = Directory('${tempDir.path}/deps/package')
        ..createSync(recursive: true);
      final appRoot = Directory('${tempDir.path}/app/sub/dir')
        ..createSync(recursive: true);
      final packageConfigDir = Directory('${tempDir.path}/app/.dart_tool')
        ..createSync(recursive: true);

      final bundledPath =
          '${packageRoot.path}/libs/${_hostPlatformDir()}/${_hostLibraryFilename('jme')}';
      File(bundledPath)
        ..createSync(recursive: true)
        ..writeAsStringSync('stub');

      File('${packageConfigDir.path}/package_config.json').writeAsStringSync('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "jpl_moshier_ephemeris_dart",
      "rootUri": "../deps/package",
      "packageUri": "lib/"
    }
  ]
}
''');

      expect(
        _normalizePath(
          JmeLoader.findLibraryPath(
            environment: const {},
            currentDirectory: appRoot.path,
            executablePath: '${tempDir.path}/bin/fake_executable',
          ),
        ),
        _normalizePath(bundledPath),
      );
    });

    test('finds desktop libraries next to the executable', () {
      final tempDir = Directory.systemTemp.createTempSync('jme-loader-exe-');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final executableDir = Directory('${tempDir.path}/bin')
        ..createSync(recursive: true);
      final bundledPath =
          '${executableDir.path}/${_hostLibraryFilename('jme')}';
      File(bundledPath).writeAsStringSync('stub');

      expect(
        _normalizePath(
          JmeLoader.findLibraryPath(
            environment: const {},
            currentDirectory: tempDir.path,
            executablePath: '${executableDir.path}/fake_executable',
          ),
        ),
        _normalizePath(bundledPath),
      );
    });

    test('finds a bundled JME library for this host', () {
      if (!_hasBundledHostJme()) {
        return;
      }
      expect(File(JmeLoader.findLibraryPath()).existsSync(), isTrue);
    });

    test('loads CALCEPH runtime when one is bundled for this host', () {
      if (!_hasBundledHostCalceph()) {
        expect(JmeLoader.loadCalcephRuntime(), isNull);
        return;
      }
      expect(File(JmeLoader.findCalcephLibraryPath()).existsSync(), isTrue);
      expect(JmeLoader.loadCalcephRuntime(), isNotNull);
    });
  });

  group('native integration parity', () {
    test('loads the default library and reports a semantic version', () {
      if (!_hasBundledHostJme()) {
        return;
      }
      final jme = JmeEph();

      using((Arena arena) {
        final buffer = arena<Char>(256);
        final result = jme.bindings.jme_version(buffer, 256);
        final version = buffer.cast<Utf8>().toDartString();

        expect(result.address, isNonZero);
        expect(version, matches(r'^\d+\.\d+\.\d+'));
      });
    });

    test('round-trips julian day conversion', () {
      if (!_hasBundledHostJme()) {
        return;
      }
      final jme = JmeEph();
      final jd = jme.bindings.jme_julian_day(
        2000,
        1,
        1,
        12,
        JME_CALENDAR_GREGORIAN,
      );

      expect(jd, closeTo(2451545.0, 1e-9));

      using((Arena arena) {
        final year = arena<Int>();
        final month = arena<Int>();
        final day = arena<Int>();
        final hour = arena<Double>();

        jme.bindings.jme_reverse_julian_day(
          jd,
          JME_CALENDAR_GREGORIAN,
          year,
          month,
          day,
          hour,
        );

        expect(year.value, 2000);
        expect(month.value, 1);
        expect(day.value, 1);
        expect(hour.value, closeTo(12.0, 1e-9));
      });
    });

    test('calculates a reasonable sun position at J2000', () {
      if (!_hasBundledHostJme()) {
        return;
      }
      final jme = JmeEph();

      using((Arena arena) {
        final xx = arena<Double>(6);
        final err = arena<Char>(256);
        final result = jme.bindings.jme_calc_ut(
          2451545,
          JME_BODY_SUN,
          JME_CALC_SPEED,
          xx,
          err,
        );

        expect(result, greaterThanOrEqualTo(0));
        expect(xx[0], inInclusiveRange(270.0, 300.0));
        expect(xx[2], inInclusiveRange(0.9, 1.1));
      });
    });
  });
}
