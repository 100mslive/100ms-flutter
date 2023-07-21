import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class AppDebugConfig {
  /*
  Setting these values to defaults and can be toggled from the application
  This will not be shipped with the ui_kit package and only used for internal testing
  */
  static bool joinWithMutedAudio = true;
  static bool joinWithMutedVideo = true;
  static bool skipPreview = false;
  static bool mirrorCamera = true;
  static bool showStats = false;
  static bool isSoftwareDecoderDisabled = true;
  static bool isAudioMixerDisabled = true;
  static bool isAutoSimulcast = true;

  static bool isDebugMode = false;
  static bool isStreamingFlow = true;

  static HMSIOSScreenshareConfig iOSScreenshareConfig = HMSIOSScreenshareConfig(
      appGroup: "group.flutterhms",
      preferredExtension: "live.100ms.flutter.FlutterBroadcastUploadExtension");

  static void resetToDefault() {
    joinWithMutedAudio = true;
    joinWithMutedVideo = true;
    skipPreview = false;
    mirrorCamera = true;
    showStats = false;
    isSoftwareDecoderDisabled = true;
    isAudioMixerDisabled = true;
    isAutoSimulcast = true;
    isStreamingFlow = true;
  }
}
