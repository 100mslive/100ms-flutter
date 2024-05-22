// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSVideoTrackSetting
///
///[HMSVideoTrackSetting] contains cameraFacing, disableAutoResize, trackInitialState and forceSoftwareDecoder.
///
///Refer [HMSVideoTrackSetting guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/set-track-settings#for-the-video-track-we-can-set-the-following-properties)
class HMSVideoTrackSetting {
  /// [cameraFacing] property specifies which camera to use while joining. It can be toggled later on. The default value is `HMSCameraFacing.FRONT`.
  final HMSCameraFacing? cameraFacing;

  /// [disableAutoResize] property to disable auto-resizing. By default it's set to false.
  final bool? disableAutoResize;

  /// [trackInitialState] property to set the initial state of the video track i.e Mute/Unmute.
  final HMSTrackInitState? trackInitialState;

  /// [forceSoftwareDecoder] property to use software decoder. By default it's set to false. This property is available only on Android.
  final bool? forceSoftwareDecoder;

  final bool? isVirtualBackgroundEnabled;

  HMSVideoTrackSetting(
      {this.cameraFacing = HMSCameraFacing.FRONT,
      this.disableAutoResize = false,
      this.trackInitialState = HMSTrackInitState.UNMUTED,
      this.forceSoftwareDecoder = false,
      this.isVirtualBackgroundEnabled = false});

  factory HMSVideoTrackSetting.fromMap(Map map) {
    return HMSVideoTrackSetting(
        cameraFacing: HMSCameraFacingValues.getHMSCameraFacingFromName(
            map['camera_facing']),
        disableAutoResize: map['disable_auto_resize'] ?? false,
        trackInitialState: map.containsKey('track_initial_state')
            ? HMSTrackInitStateValue.getHMSTrackInitStateFromName(
                map['track_initial_state'])
            : HMSTrackInitState.UNMUTED,
        forceSoftwareDecoder: map.containsKey('force_software_decoder')
            ? map['force_software_decoder']
            : false,
        isVirtualBackgroundEnabled:
            map["is_virtual_background_enabled"] ?? false);
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
      'force_software_decoder': forceSoftwareDecoder ?? false,
      'is_virtual_background_enabled': isVirtualBackgroundEnabled ?? false,
    };
  }
}
