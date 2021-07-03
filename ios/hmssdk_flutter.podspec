#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hmssdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hmssdk_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter Project for 100ms SDK'
  s.description      = <<-DESC
  A Flutter Project for 100ms SDK.
                       DESC
  s.homepage         = 'http://100ms.live'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'vivek@100ms.live' }
  s.source           = { :git => 'https://github.com/100mslive/100ms-flutter.git' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'HMSSDK'
  s.dependency 'AFNetworking'
  s.platform = :ios, '10.0'
  s.ios.deployment_target  = '10.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
