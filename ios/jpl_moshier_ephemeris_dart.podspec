#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint jpl_moshier_ephemeris_dart.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'jpl_moshier_ephemeris_dart'
  s.version          = '1.0.0'
  s.summary          = 'Dart FFI wrapper for JPL Moshier Ephemeris.'
  s.description      = <<-DESC
Flutter FFI plugin for the JPL Moshier Ephemeris native library with direct jme_* API access for iOS and Android.
                       DESC
  s.homepage         = 'https://github.com/jayeshmepani/jpl-moshier-ephemeris-dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jayesh Patel' => 'jayeshmepani777@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Bundle the native frameworks
  s.vendored_frameworks = 'Frameworks/Jme.xcframework', 'Frameworks/Calceph.xcframework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' 
  }
  s.swift_version = '5.0'
end
