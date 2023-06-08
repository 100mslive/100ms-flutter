import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSHLSPlayerController
///
/// [HMSHLSPlayerController] class contains methods to control the HLS Playback
class HMSHLSPlayerController {
  /// Adds an [HMSHLSPlaybackEventsListener] to listen for HLS playback events.
  /// **parameters**:
  ///
  /// **hmshlsPlaybackEventsListener** - hls playback event listener to be attached
  static void addHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.addHLSPlaybackEventListener(hmshlsPlaybackEventsListener);
  }

  /// Removes an [HMSHLSPlaybackEventsListener] that was previously added.
  /// **parameters**:
  ///
  /// **hmshlsPlaybackEventsListener** - hls playback event listener to be removed
  static void removeHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.removeHLSPlaybackEventListener(
        hmshlsPlaybackEventsListener);
  }

  /// Starts the HLS playback with the specified [hlsUrl].
  /// **parameters**:
  ///
  /// **hlsUrl** - hls stream m3u8 url to be played
  static Future<void> start({String? hlsUrl}) async {
    await PlatformService.invokeMethod(PlatformMethod.start,arguments: {
      "hls_url": hlsUrl
    });
  }

  /// Stops the HLS playback.
  static Future<void> stop() async {
    await PlatformService.invokeMethod(PlatformMethod.stop);
  }

  /// Pauses the HLS playback.
  static Future<void> pause() async {
    await PlatformService.invokeMethod(PlatformMethod.pause);
  }

  /// Resumes the paused HLS playback.
  static Future<void> resume() async {
    await PlatformService.invokeMethod(PlatformMethod.resume);
  }

  /// Seeks to the live position in the HLS playback.
  static Future<void> seekToLivePosition() async {
    await PlatformService.invokeMethod(PlatformMethod.seekToLivePosition);
  }

  /// Seeks forward in the HLS playback by the specified [seconds].
  /// **parameters**:
  ///
  /// **seconds** - seek forward in the stream by specified seconds
  static Future<void> seekForward({required int seconds}) async {
    final Map<String, dynamic> arguments = {'seconds': seconds};
    await PlatformService.invokeMethod(PlatformMethod.seekForward,
        arguments: arguments);
  }

  /// Seeks backward in the HLS playback by the specified [seconds].
  /// **parameters**:
  ///
  /// **seconds** - seek backward in the stream by specified seconds
  static Future<void> seekBackward({required int seconds}) async {
    final Map<String, dynamic> arguments = {
      'seconds': seconds,
    };
    await PlatformService.invokeMethod(PlatformMethod.seekBackward,
        arguments: arguments);
  }

  /// Sets the volume of the HLS player to the specified [volume].
  /// **parameters**:
  ///
  /// **volume** - volume for HLS player
  /// The [volume] value should be between 0 and 100.
  static Future<void> setVolume({required int volume}) async {
    /// Asserting that volume can be between 0 and 100.
    assert(volume >= 0 && volume <= 100,
        "Volume must be between 0 and 100 currently it is provided as $volume");
    final Map<String, dynamic> arguments = {'volume': volume};

    await PlatformService.invokeMethod(PlatformMethod.setHLSPlayerVolume,
        arguments: arguments);
  }

  /// Adds an HLS stats listener to receive HLS playback statistics.
  static Future<void> addHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.addHLSStatsListener);
  }

  /// Removes the HLS stats listener that was previously added.
  static Future<void> removeHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.removeHLSStatsListener);
  }
}
