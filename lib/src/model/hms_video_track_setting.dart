// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_track_init_state.dart';

class HMSVideoTrackSetting {
  final HMSCodec? codec;
  final HMSResolution? resolution;
  final int? maxBitrate;
  final int? maxFrameRate;
  final HMSCameraFacing? cameraFacing;
  final String? trackDescription;
  final bool? disableAutoResize;
  final HMSTrackInitState hmsVideoTrackInitState;

  HMSVideoTrackSetting(
      {this.codec = HMSCodec.VP8,
      this.resolution,
      this.maxBitrate = 512,
      this.maxFrameRate = 25,
      this.cameraFacing = HMSCameraFacing.FRONT,
      this.trackDescription = "This a video track",
      this.disableAutoResize = false,
      this.hmsVideoTrackInitState = HMSTrackInitState.MUTED});

  factory HMSVideoTrackSetting.fromMap(Map map) {
    HMSResolution? resolution;
    if (map.containsKey('resolution')) {
      resolution = HMSResolution.fromMap(map['resolution']);
    }
    return HMSVideoTrackSetting(
        codec: HMSCodecValues.getHMSCodecFromName(map['video_codec']),
        resolution: resolution,
        maxBitrate: map['bit_rate'] ?? 0,
        maxFrameRate: map['max_frame_rate'] ?? 0,
        cameraFacing: HMSCameraFacingValues.getHMSCameraFacingFromName(
            map['camera_facing']),
        disableAutoResize: map['disable_auto_resize'] ?? false,
        hmsVideoTrackInitState:HMSTrackInitStateValue.getHMSTrackInitStateFromName(map['hms_video_track_init_state'])
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'video_codec':
          codec != null ? HMSCodecValues.getValueFromHMSCodec(codec!) : null,
      'max_bit_rate': maxBitrate,
      'max_frame_rate': maxFrameRate,
      'resolution': resolution?.toMap(),
      'camera_facing': cameraFacing != null
          ? HMSCameraFacingValues.getValueFromHMSCameraFacing(cameraFacing!)
          : null,
      'track_description': trackDescription,
      'disable_auto_resize': disableAutoResize ?? false,
      'hms_video_track_init_state':HMSTrackInitStateValue.getValuefromHMSTrackInitState(hmsVideoTrackInitState)
    };
  }
}
