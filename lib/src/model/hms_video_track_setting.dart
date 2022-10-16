// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSVideoTrackSetting {
  /// [cameraFacing] property specifies which camera to use while joining. It can be toggled later on. The default value is `HMSCameraFacing.FRONT`.
  final HMSCameraFacing? cameraFacing;

  /// [disableAutoResize] property to disable auto-resizing. By default it's set to false.
  final bool? disableAutoResize;

  /// [trackInitialState] property to set the initial state of the video track i.e Mute/Unmute.
  final HMSTrackInitState trackInitialState;

  /// [forceSoftwareDecoder] property to use software decoder. By default it's set to false.(Android Only)
  final bool? forceSoftwareDecoder;

  HMSVideoTrackSetting(
      {this.cameraFacing = HMSCameraFacing.FRONT,
      this.disableAutoResize = false,
      this.trackInitialState = HMSTrackInitState.UNMUTED,
      this.forceSoftwareDecoder = false});

  factory HMSVideoTrackSetting.fromMap(Map map) {
    return HMSVideoTrackSetting(
        cameraFacing: HMSCameraFacingValues.getHMSCameraFacingFromName(
            map['camera_facing']),
        disableAutoResize: map['disable_auto_resize'] ?? false,
        trackInitialState: HMSTrackInitStateValue.getHMSTrackInitStateFromName(
            map['track_initial_state']),
        forceSoftwareDecoder: map['force_software_decoder']);
  }

  Map<String, dynamic> toMap() {
    return {
      'camera_facing': cameraFacing != null
          ? HMSCameraFacingValues.getValueFromHMSCameraFacing(cameraFacing!)
          : null,
      'disable_auto_resize': disableAutoResize ?? false,
      'track_initial_state':
          HMSTrackInitStateValue.getValuefromHMSTrackInitState(
              trackInitialState),
      'force_software_decoder': forceSoftwareDecoder ?? false
    };
  }
}
