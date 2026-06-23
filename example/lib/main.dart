import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:jpl_moshier_ephemeris_dart/jpl_moshier_ephemeris_dart.dart';

void main() {
  runApp(const JmeExampleApp());
}

class JmeExampleApp extends StatelessWidget {
  const JmeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JPL Moshier Ephemeris Dart',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const JmeExampleHomePage(),
    );
  }
}

class JmeExampleHomePage extends StatefulWidget {
  const JmeExampleHomePage({super.key});

  @override
  State<JmeExampleHomePage> createState() => _JmeExampleHomePageState();
}

class _JmeExampleHomePageState extends State<JmeExampleHomePage> {
  String _version = 'Tap refresh to query the native runtime.';
  String _sunPosition = 'Tap refresh to compute the Sun position for J2000.';

  Future<void> _refresh() async {
    try {
      final jme = JmeEph();
      final version = using((arena) {
        final buffer = arena<Char>(256);
        jme.bindings.jme_version(buffer, 256);
        return buffer.cast<Utf8>().toDartString();
      });

      final sunPosition = using((arena) {
        final result = arena<Double>(6);
        final error = arena<Char>(256);
        final status = jme.bindings.jme_calc_ut(
          2451545,
          JME_BODY_SUN,
          JME_CALC_SPEED,
          result,
          error,
        );
        if (status < 0) {
          final nativeError = error.cast<Utf8>().toDartString();
          throw Exception(
            nativeError.isEmpty
                ? 'Native position calculation failed.'
                : nativeError,
          );
        }
        return 'lon=${result[0].toStringAsFixed(6)}°, '
            'lat=${result[1].toStringAsFixed(6)}°, '
            'dist=${result[2].toStringAsFixed(9)} AU';
      });

      if (!mounted) return;
      setState(() {
        _version = version;
        _sunPosition = sunPosition;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _version = 'Error: $error';
        _sunPosition = 'Unable to compute a sample ephemeris result.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JPL Moshier Ephemeris Dart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This example loads the bundled native runtime and queries a couple '
              'of simple values through the generated FFI bindings.',
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Native runtime version'),
                subtitle: Text(_version),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Sun position at J2000'),
                subtitle: Text(_sunPosition),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _refresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
