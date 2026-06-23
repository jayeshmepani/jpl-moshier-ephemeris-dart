Pod::Spec.new do |s|
  s.name             = 'jpl_moshier_ephemeris_dart'
  s.version          = '1.1.0'
  s.summary          = 'Dart FFI wrapper for JPL Moshier Ephemeris.'
  s.description      = <<-DESC
Flutter FFI plugin for the JPL Moshier Ephemeris native library with bundled desktop runtimes for macOS.
                       DESC
  s.homepage         = 'https://github.com/jayeshmepani/jpl-moshier-ephemeris-dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jayesh Patel' => 'jayeshmepani777@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'FlutterMacOS'
  s.platform         = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.prepare_command = <<-CMD
    set -e
    rm -rf Libraries
    mkdir -p Libraries
    ARCH="$(uname -m)"
    case "$ARCH" in
      arm64)
        SRC="../libs/macos-arm64"
        ;;
      x86_64)
        SRC="../libs/macos-x64"
        ;;
      *)
        echo "Unsupported macOS architecture: $ARCH" >&2
        exit 1
        ;;
    esac
    cp "$SRC/libjme.dylib" Libraries/libjme.dylib
    cp "$SRC/libcalceph.dylib" Libraries/libcalceph.dylib
    chmod 755 Libraries/libjme.dylib Libraries/libcalceph.dylib
  CMD

  s.preserve_paths = 'Libraries/*.dylib'
  s.vendored_libraries = 'Libraries/libjme.dylib', 'Libraries/libcalceph.dylib'
  s.swift_version = '5.0'
end
