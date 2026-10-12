// Tests for the C engine API added in jpl-ephemeris PR #3. Expected values
// were printed by the C library itself (%.17g) at jpl-ephemeris f08dac8; the
// bindings must pass them through unchanged. Arithmetic-only results are
// compared exactly; results that go through libm transcendental functions
// allow 1e-14 relative (platform libm).
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

void expectClose(double actual, double expected) {
  expect(actual, closeTo(expected, expected.abs() * 1e-14));
}

void main() {
  final b = JmeEph().bindings;

  setUp(() {
    using((arena) {
      b
        ..jme_set_astro_models(
            'DEFAULT'.toNativeUtf8(allocator: arena).cast(), 0)
        ..jme_set_tid_acc(JME_TIME_TIDAL_AUTOMATIC.toDouble());
    });
  });

  test('time scale convert and name', () {
    using((arena) {
      final o1 = arena<Double>();
      final o2 = arena<Double>();
      final err = arena<Char>(256);
      expect(
        b.jme_time_scale_convert(
          2451545,
          0,
          JME_TIME_SCALE_TT,
          JME_TIME_SCALE_TAI,
          o1,
          o2,
          err,
        ),
        0,
      );
      expect(o1.value, 2451545.0);
      expect(o2.value, -0.00037249999999999995);
      b.jme_time_scale_convert(
        2457754.5,
        0.25,
        JME_TIME_SCALE_UTC,
        JME_TIME_SCALE_TT,
        o1,
        o2,
        err,
      );
      expect(o1.value, 2457754.5);
      expect(o2.value, 0.25080074074074071);
      expect(
        b.jme_time_scale_name(JME_TIME_SCALE_TDB).cast<Utf8>().toDartString(),
        'TDB',
      );
    });
  });

  test('leap second and IERS table info', () {
    using((arena) {
      final a = arena<Double>();
      final c = arena<Double>();
      final d = arena<Double>();
      final err = arena<Char>(256);
      expect(b.jme_leap_second_table_info(a, c, err), 0);
      expect([a.value, c.value], [2461587.5, 37.0]);
      expect(b.jme_delta_t_iers_table_info(a, c, d, err), 0);
      expect([a.value, c.value, d.value], [2441684.5, 2461321.5, 2461682.5]);
    });
  });

  test('ayanamsa ex2 and sidereal time ex', () {
    using((arena) {
      final ay = arena<Double>();
      final rate = arena<Double>();
      final err = arena<Char>(256);
      b.jme_set_sidereal_mode(JME_SIDEREAL_LAHIRI, 0, 0);
      expect(
        b.jme_get_ayanamsa_ex2(
          2451545,
          JME_SIDEREAL_LAHIRI,
          JME_AYANAMSA_TRUE,
          ay,
          rate,
          err,
        ),
        0,
      );
      expectClose(ay.value, 23.853224722663143);
      expectClose(rate.value, 3.8246992136024994e-05);
      b.jme_get_ayanamsa_ex2_ut(
        2451545,
        JME_SIDEREAL_LAHIRI,
        JME_AYANAMSA_MEAN,
        ay,
        rate,
        err,
      );
      expectClose(ay.value, 23.857092357910052);
      final hours = arena<Double>();
      expect(b.jme_sidereal_time_ex(2451545, 1, hours, err), 0);
      expectClose(hours.value, 18.69713803335517);
    });
  });

  test('Gauquelin houses', () {
    using((arena) {
      final cusps = arena<Double>(37);
      final ascmc = arena<Double>(10);
      final err = arena<Char>(256);
      expect(
        b.jme_houses_gauquelin(2451545, 0, 28.6, 77.2, cusps, ascmc, err),
        0,
      );
      expectClose(cusps[1], 100.17642650805641);
      expectClose(cusps[19], 280.17642650805641);
      expectClose(cusps[36], 107.65087247267206);
      expectClose(ascmc[0], 100.17642650805641);
      expect(
        b.jme_houses_gauquelin_armc(100, 28.6, 23.44, cusps, ascmc, err),
        0,
      );
      expectClose(cusps[10], 99.18946523149512);
      expectClose(cusps[36], 197.96278849881179);
    });
  });

  test('engine resolution and JPL centre policy', () {
    using((arena) {
      final eid = arena<Int>()..value = -1;
      final sub = arena<Int>()..value = -1;
      final err = arena<Char>(256);
      expect(
          b.jme_calc_resolve_engine(2451545, JME_BODY_MARS, eid, sub, err), 0);
      expect([eid.value, sub.value], [JME_ENGINE_ID_MOSHIER, 0]);
      expect(b.jme_set_jpl_center_policy(7, err), -1);
      expect(err.cast<Utf8>().toDartString(), isNotEmpty);
      expect(b.jme_get_jpl_center_policy(), JME_JPL_CENTER_STRICT);
    });
  });

  test('checked setters and Laskar 1986 precession', () {
    using((arena) {
      final err = arena<Char>(256);
      expect(
        b.jme_set_astro_models_checked(
          'NOPE_TOKEN'.toNativeUtf8(allocator: arena).cast(),
          err,
        ),
        -1,
      );
      expect(
        b.jme_set_astro_models_checked(
          'PREC=LASKAR1986'.toNativeUtf8(allocator: arena).cast(),
          err,
        ),
        0,
      );
      final m = arena<Double>(9);
      expect(
        b.jme_get_precession_matrix(
          2451545,
          2451545 + 36525,
          JME_MODEL_PREC_LASKAR_1986,
          m,
        ),
        0,
      );
      expectClose(m[0], 0.99970264828061839);
      expectClose(m[1], -0.022366275629188623);
      expect(b.jme_set_topo_checked(0, 95, 0, err), -1);
      expect(b.jme_set_sidereal_mode_checked(99999, 0, 0, err), -1);
    });
  });

  test('EOP loading and polar motion', () {
    using((arena) {
      final a = arena<Double>();
      final c = arena<Double>();
      final err = arena<Char>(256);
      final path =
          File('test/fixtures/eop_finals2000A_excerpt.txt').absolute.path;
      b.jme_eop_clear();
      expect(b.jme_eop_coverage(a, c, err), -1);
      expect(
        b.jme_eop_load_file(path.toNativeUtf8(allocator: arena).cast(), err),
        0,
      );
      expect(b.jme_eop_coverage(a, c, err), 0);
      expect([a.value, c.value], [58845.0, 60314.0]);
      final pred = arena<Int>()..value = -1;
      expect(b.jme_eop_polar_motion(58849.25, a, c, pred, err), 0);
      expect(
        [a.value, c.value, pred.value],
        [0.076103695312499997, 0.28242803124999993, 0],
      );
      expect(b.jme_eop_polar_motion(59000, a, c, pred, err), -1);
      b.jme_set_polar_motion(1);
      expect(b.jme_get_polar_motion(), 1);
      b.jme_set_polar_motion(0);
      expect(b.jme_get_polar_motion(), 0);
      b.jme_eop_clear();
      expect(b.jme_eop_coverage(a, c, err), -1);
    });
  });

  test('Delta-T models and DE441 tidal error', () {
    using((arena) {
      final err = arena<Char>(256);
      b.jme_set_tid_acc(JME_TIME_TIDAL_DE441.toDouble());
      expect(
        b
            .jme_delta_t_ex(2000000, JME_MODEL_DELTAT_ESPENAK_MEEUS_2006, err)
            .isNaN,
        isTrue,
      );
      expect(err.cast<Utf8>().toDartString(), contains('DE441'));
      b.jme_set_tid_acc(JME_TIME_TIDAL_AUTOMATIC.toDouble());
      expectClose(
        b.jme_delta_t_ex(2000000, JME_MODEL_DELTAT_MS2004_TABLE1_LINEAR, err),
        3268.5267123287672,
      );
      expectClose(
        b.jme_delta_t_ex(2000000, JME_MODEL_DELTAT_STEPHENSON_ETC_2021, err),
        3229.007157575752,
      );
    });
  });
}
