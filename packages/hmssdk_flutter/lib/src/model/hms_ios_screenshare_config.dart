/// 100ms HMSIOSScreenshareConfig
///
/// [HMSIOSScreenshareConfig] is required for starting Screen share (Broadcast screen) from iOS devices like iPhones & iPads. To learn more about Screen Share, refer to the guide [here](https://www.100ms.live/docs/flutter/v2/features/screen-share).
///
/// `Note: You can find appGroup and preferredExtension name in Xcode under Signing and Capabilities section under target > yourExtensionName.`
class HMSIOSScreenshareConfig {
  /// [appGroup] is required for starting Screen Share (Broadcast screen) from iOS Devices.
  ///
  /// To know more about how to add [appGroup] follow the guide [here](https://www.100ms.live/docs/flutter/v2/features/screen-share#step-3-add-app-group).
  ///
  /// `Note: You can find app group in Xcode under Signing and Capabilities section under target > yourExtensionName.`
  String appGroup;

  /// [preferredExtension] is required for starting Screen Share (Broadcast screen) from iOS Devices.
  ///
  /// To know more about how to add [preferredExtension] follow the guide [here](https://www.100ms.live/docs/flutter/v2/features/screen-share#step-2-add-broadcast-upload-extension).
  ///
  /// `Note: You can find preferredExtension name in Xcode under Signing and Capabilities section under target > yourExtensionName.`
  String preferredExtension;

  /// [HMSIOSScreenshareConfig] is required for starting Screen Share (Broadcast screen) from iOS Devices.
  HMSIOSScreenshareConfig(
      {required this.appGroup, required this.preferredExtension});

  /// Converts the [HMSIOSScreenshareConfig] instance to a Map.
  Map<String, String> toMap() {
    return {
      'app_group': this.appGroup,
      'preferred_extension': this.preferredExtension,
    };
  }
}
