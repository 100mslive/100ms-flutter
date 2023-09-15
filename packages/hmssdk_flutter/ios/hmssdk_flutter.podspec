require 'json'

sdkVersions = JSON.parse(File.read(File.join("../lib/assets/sdk-versions.json")))

Pod::Spec.new do |s|
  s.name             = 'hmssdk_flutter'
  s.version          = sdkVersions["flutter"]
  s.summary          = 'The Flutter plugin for 100ms SDK'
  s.description      = <<-DESC
  A Flutter Project for 100ms SDK.
                      DESC
  s.homepage         = 'http://100ms.live'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yogesh Singh' => 'yogesh@100ms.live' }
  s.source           = { :git => 'https://github.com/100mslive/100ms-flutter.git' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency "HMSSDK", sdkVersions["ios"]
  s.dependency 'HMSBroadcastExtensionSDK', sdkVersions['iOSBroadcastExtension']
  s.dependency 'HMSHLSPlayerSDK', sdkVersions['iOSHLSPlayerSDK']
  s.platform = :ios, '12.0'
  s.ios.deployment_target  = '12.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
