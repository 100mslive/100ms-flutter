import 'package:hmssdk_flutter/src/enum/hms_hls_playback_state.dart';
import 'package:hmssdk_flutter/src/model/hms_hls_cue.dart';

abstract class HMSHLSPlaybackEventsListener {
  
  
  void onPlaybackFailure({required String? error}){}


  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {}


  void onCue({required HMSHLSCue hlsCue}){}


}
