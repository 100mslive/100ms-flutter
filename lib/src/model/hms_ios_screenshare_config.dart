/// 100ms HMSIOSScreenshareConfig
///
/// [HMSIOSScreenshareConfig] is only used for screen share (broadcast screen) in iOS. For step by step guide follow [here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup).
///
/// `Note: You can find appGroup and preferredExtension name in Xcode under Signing and Capabilities section under target > yourExtensionName.`

class HMSIOSScreenshareConfig {
  /// [appGroup] is only used for screen share (broadcast screen) in iOS.
  ///
  /// To know how to add [appGroup] follow [here](https://www.100ms.live/docs/flutter/v2/features/screen-share#step-3-add-app-group).
  ///
  /// `Note: You can find app group in Xcode under Signing and Capabilities section under target > yourExtensionName.`
  String appGroup;

  /// [preferredExtension] is only used for screen share (broadcast screen) in iOS.
  ///
  /// To know how to add [preferredExtension] follow [here](https://www.100ms.live/docs/flutter/v2/features/screen-share#step-2-add-broadcast-upload-extension).
  ///
  /// `Note: You can find preferredExtension name in Xcode under Signing and Capabilities section under target > yourExtensionName.`
  String preferredExtension;

  HMSIOSScreenshareConfig(
      {required this.appGroup, required this.preferredExtension});
}
