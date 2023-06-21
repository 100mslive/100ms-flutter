//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSHLSPlaybackEventsListener
///
///100ms provides callbacks to the client app about any changes in HLS Player
///Refer for more info [HMSHLSPlaybackEventsListener](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-get-hls-callbacks)
abstract class HMSHLSPlaybackEventsListener {
  ///Callback to know about the errors that happen during playback.
  ///
  ///- Parameter: error: Error string containing the reason for failure
  void onPlaybackFailure({required String? error}) {}

  ///Callback to know about the state change event during the playback.
  ///
  ///- Parameter: playbackState: An enum of type [HMSHLSPlaybackState] containing the current playback state
  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {}

  ///Callback to know about any HLS Timed Metadata cue and use it's data to show any UI like quizzes, poll etc. to HLS viewers.
  ///
  ///- Parameter: hlsCue: A [HMSHLSCue] object containing details of the HLS Metadata payload, time etc.
  void onCue({required HMSHLSCue hlsCue}) {}

  /// Callback to know about failures in HLS Stats.
  ///
  ///- Parameter: hlsException: A [HMSException] object containing details about the failure cause.
  void onHLSError({required HMSException hlsException}) {}

  /// Callback to get HLS Player stats
  ///
  /// - Parameter: playerStats: A [HMSHLSPlayerStats] object containing info about HLS Player stats
  void onHLSEventUpdate({required HMSHLSPlayerStats playerStats}) {}
}
