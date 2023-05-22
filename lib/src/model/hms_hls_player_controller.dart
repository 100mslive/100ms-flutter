import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSHLSPlayerController {
  static void addHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.addHLSPlaybackEventListener(hmshlsPlaybackEventsListener);
  }

  static void removeHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.removeHLSPlaybackEventListener(
        hmshlsPlaybackEventsListener);
  }

  static Future<void> start({required String? hlsUrl}) async {
    await PlatformService.invokeMethod(PlatformMethod.start);
  }

  static Future<void> stop() async {
    await PlatformService.invokeMethod(PlatformMethod.stop);
  }

  static Future<void> pause() async {
    await PlatformService.invokeMethod(PlatformMethod.pause);
  }

  static Future<void> resume() async {
    await PlatformService.invokeMethod(PlatformMethod.resume);
  }

  static Future<void> seekToLivePosition() async {
    await PlatformService.invokeMethod(PlatformMethod.seekToLivePosition);
  }

  static Future<void> seekForward({required int seconds}) async {
    final Map<String, dynamic> arguments = {'seconds': seconds};
    await PlatformService.invokeMethod(PlatformMethod.seekForward,
        arguments: arguments);
  }

  static Future<void> seekBackward({required int seconds}) async {
    final Map<String, dynamic> arguments = {
      'seconds': seconds,
    };
    await PlatformService.invokeMethod(PlatformMethod.seekBackward,
        arguments: arguments);
  }

  static Future<void> setVolume({required int volume}) async {
    /// Asserting that volume can be between 0 and 100.
    assert(volume >= 0 && volume <= 100,
        "Volume must be between 0 and 100 currently it is provided as $volume");
    final Map<String, dynamic> arguments = {'volume': volume};

    await PlatformService.invokeMethod(PlatformMethod.setHLSPlayerVolume,
        arguments: arguments);
  }

  static Future<void> addHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.addHLSStatsListener);
  }

  static Future<void> removeHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.removeHLSStatsListener);
  }
}
