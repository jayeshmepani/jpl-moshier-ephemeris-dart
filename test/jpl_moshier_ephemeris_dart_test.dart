import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

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
    test('finds a bundled JME library for this host', () {
      final jmePath = JmeLoader.findLibraryPath();

      expect(File(jmePath).existsSync(), isTrue);
    });

    test('loads CALCEPH runtime when one is bundled for this host', () {
      try {
        final calcephPath = JmeLoader.findCalcephLibraryPath();
        expect(File(calcephPath).existsSync(), isTrue);
        expect(JmeLoader.loadCalcephRuntime(), isNotNull);
      } on JmeLibraryNotFoundError {
        expect(JmeLoader.loadCalcephRuntime(), isNull);
      }
    });
  });

  group('native integration parity', () {
    test('loads the default library and reports a semantic version', () {
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
