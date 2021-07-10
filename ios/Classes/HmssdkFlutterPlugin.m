#import "HmssdkFlutterPlugin.h"
#if __has_include(<hmssdk_flutter/hmssdk_flutter-Swift.h>)
#import <hmssdk_flutter/hmssdk_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hmssdk_flutter-Swift.h"
#endif

@implementation HmssdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHmssdkFlutterPlugin registerWithRegistrar:registrar];
}
@end
