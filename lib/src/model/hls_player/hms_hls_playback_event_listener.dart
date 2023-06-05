import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_hls_playback_state.dart';
import 'package:hmssdk_flutter/src/model/hls_player/hms_hls_player_stats.dart';
import 'package:hmssdk_flutter/src/model/hls_player/hms_hls_cue.dart';

abstract class HMSHLSPlaybackEventsListener {
  void onPlaybackFailure({required String? error}) {}

  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {}

  void onCue({required HMSHLSCue hlsCue}) {}

  void onHLSError({required HMSException hlsException}) {}

  void onHLSEventUpdate({required HMSHLSPlayerStats playerStats}) {}
}
