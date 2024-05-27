import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// The [AppDebugConfig] class contains the debug configuration for the UI
class AppDebugConfig {
  /*
  Setting these values to defaults and can be toggled from the application
  This will not be shipped with the ui_kit package and only used for internal testing
  */
  static bool skipPreview = false;
  static bool mirrorCamera = true;
  static bool showStats = false;
  static bool isSoftwareDecoderDisabled = true;
  static bool isAudioMixerDisabled = true;
  static bool isAutoSimulcast = true;
  static bool nameChangeOnPreview = true;

  static bool isDebugMode = false;
  static bool isProdRoom = true;
  static bool isVirtualBackgroundEnabled = false;
  static bool isVBEnabled = false;
  static bool isBlurEnabled = false;

  /// The [iOSScreenshareConfig] contains the configuration for the iOS screenshare
  static HMSIOSScreenshareConfig? iOSScreenshareConfig;

  /// Resets the debug configuration to default values
  static void resetToDefault() {
    skipPreview = false;
    mirrorCamera = true;
    showStats = false;
    isSoftwareDecoderDisabled = true;
    isAudioMixerDisabled = true;
    isAutoSimulcast = true;
    isProdRoom = true;
    nameChangeOnPreview = true;
    isVirtualBackgroundEnabled = false;
    isBlurEnabled = false;
    isVBEnabled = false;
  }
}
