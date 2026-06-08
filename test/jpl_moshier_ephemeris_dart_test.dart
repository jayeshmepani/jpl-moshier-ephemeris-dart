import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

void main() {
  test('Can load JME library and call jme_version', () {
    // Determine the path to the library for testing
    const libPath = 'android/src/main/jniLibs/x86_64/libjme.so';
    if (!File(libPath).existsSync()) {
      return;
    }

    final dylib = DynamicLibrary.open(libPath);
    final jme = JmeEph(dylib);

    using((Arena arena) {
      final buffer = arena<Char>(100);
      jme.bindings.jme_version(buffer, 100);
      final version = buffer.cast<Utf8>().toDartString();
      expect(version, isNotEmpty);
    });
  });

  test('Can call jme_julian_day', () {
    const libPath = 'android/src/main/jniLibs/x86_64/libjme.so';
    if (!File(libPath).existsSync()) {
      return;
    }

    final dylib = DynamicLibrary.open(libPath);
    final jme = JmeEph(dylib);

    final jd = jme.bindings.jme_julian_day(2026, 6, 8, 12, JME_CALENDAR_GREGORIAN);
    expect(jd, closeTo(2461200, 0.0001));
  });
}
