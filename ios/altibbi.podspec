#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint altibbi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'altibbi'
  s.version          = '0.0.1'
  s.summary          = 'Altbbi sample.'
  s.description      = <<-DESC
Altibbi Sample.
                       DESC
  s.homepage         = 'http://altibbi.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Altibbi' => 'wecare@altibbi.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'OpenTok'
  s.static_framework = true
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
