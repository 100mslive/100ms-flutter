import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// The [AppDebugConfig] class contains the debug configuration for the UI
class AppDebugConfig {
  /*
  Setting these values to defaults and can be toggled from the application
  This will not be shipped with the ui_kit package and only used for internal testing
  */
  static bool joinWithMutedAudio = false;
  static bool joinWithMutedVideo = false;
  static bool skipPreview = false;
  static bool mirrorCamera = true;
  static bool showStats = false;
  static bool isSoftwareDecoderDisabled = true;
  static bool isAudioMixerDisabled = true;
  static bool isAutoSimulcast = true;

  static bool isDebugMode = false;
  static bool isProdRoom = true;

  /// The [iOSScreenshareConfig] contains the configuration for the iOS screenshare
  static HMSIOSScreenshareConfig? iOSScreenshareConfig;

  /// Resets the debug configuration to default values
  static void resetToDefault() {
    joinWithMutedAudio = true;
    joinWithMutedVideo = true;
    skipPreview = false;
    mirrorCamera = true;
    showStats = false;
    isSoftwareDecoderDisabled = true;
    isAudioMixerDisabled = true;
    isAutoSimulcast = true;
    isProdRoom = true;
  }
}
