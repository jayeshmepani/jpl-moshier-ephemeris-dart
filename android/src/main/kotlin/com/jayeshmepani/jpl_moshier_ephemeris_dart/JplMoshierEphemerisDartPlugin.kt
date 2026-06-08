package com.jayeshmepani.jpl_moshier_ephemeris_dart

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** JplMoshierEphemerisDartPlugin */
class JplMoshierEphemerisDartPlugin: FlutterPlugin {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    System.loadLibrary("calceph")
    System.loadLibrary("jme")
  }

  override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {}
}
