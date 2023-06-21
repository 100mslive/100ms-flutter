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
  /// Refer [addHMSHLSPlaybackEventsListener](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-get-hls-callbacks)
  static void addHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.addHLSPlaybackEventListener(hmshlsPlaybackEventsListener);
  }

  /// Removes an [HMSHLSPlaybackEventsListener] that was previously added.
  /// **parameters**:
  ///
  /// **hmshlsPlaybackEventsListener** - hls playback event listener to be removed
  /// Refer [addHMSHLSPlaybackEventsListener](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-get-hls-callbacks)
  static void removeHMSHLSPlaybackEventsListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    PlatformService.removeHLSPlaybackEventListener(
        hmshlsPlaybackEventsListener);
  }

  /// Starts the HLS playback with the specified [hlsUrl].
  /// **parameters**:
  ///
  /// **hlsUrl** - hls stream m3u8 url to be played
  /// Refer [Start HLS Player](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-startstop-the-playback)
  static Future<void> start({String? hlsUrl}) async {
    await PlatformService.invokeMethod(PlatformMethod.start,
        arguments: {"hls_url": hlsUrl});
  }

  /// Stops the HLS playback.
  /// Refer [Stop HLS Player](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-startstop-the-playback)
  static Future<void> stop() async {
    await PlatformService.invokeMethod(PlatformMethod.stop);
  }

  /// Pauses the HLS playback.
  /// Refer [Pause HLS Playback](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-pause-and-resume-the-playback)
  static Future<void> pause() async {
    await PlatformService.invokeMethod(PlatformMethod.pause);
  }

  /// Resumes the paused HLS playback.
  /// Refer [Resume HLS Playback](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-pause-and-resume-the-playback) 
  static Future<void> resume() async {
    await PlatformService.invokeMethod(PlatformMethod.resume);
  }

  /// Seeks to the live position in the HLS playback.
  /// Refer [Seek to live position](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-seek-to-live-position)
  static Future<void> seekToLivePosition() async {
    await PlatformService.invokeMethod(PlatformMethod.seekToLivePosition);
  }

  /// Seeks forward in the HLS playback by the specified [seconds].
  /// **parameters**:
  ///
  /// **seconds** - seek forward in the stream by specified seconds
  /// Refer [seek Forward](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-seek-forward-or-backward)
  static Future<void> seekForward({required int seconds}) async {
    final Map<String, dynamic> arguments = {'seconds': seconds};
    await PlatformService.invokeMethod(PlatformMethod.seekForward,
        arguments: arguments);
  }

  /// Seeks backward in the HLS playback by the specified [seconds].
  /// **parameters**:
  ///
  /// **seconds** - seek backward in the stream by specified seconds
  /// Refer [seek Backward](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-seek-forward-or-backward)
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
  /// Refer [set Volume](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-change-volume-of-hls-playback)
  static Future<void> setVolume({required int volume}) async {
    /// Asserting that volume can be between 0 and 100.
    assert(volume >= 0 && volume <= 100,
        "Volume must be between 0 and 100 currently it is provided as $volume");
    final Map<String, dynamic> arguments = {'volume': volume};

    await PlatformService.invokeMethod(PlatformMethod.setHLSPlayerVolume,
        arguments: arguments);
  }

  /// Adds an HLS stats listener to receive HLS playback statistics.
  /// Refer [add HLS Stats listener](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-know-the-stats-related-to-hls-playback)
  static Future<void> addHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.addHLSStatsListener);
  }

  /// Removes the HLS stats listener that was previously added.
  /// Refer [remove HLS Stats listener](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-know-the-stats-related-to-hls-playback)
  static Future<void> removeHLSStatsListener() async {
    await PlatformService.invokeMethod(PlatformMethod.removeHLSStatsListener);
  }
}
