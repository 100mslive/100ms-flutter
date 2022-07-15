// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSVideoTrackSetting {
  final HMSCodec? codec;
  final HMSResolution? resolution;
  final int? maxBitrate;
  final int? maxFrameRate;
  final HMSCameraFacing? cameraFacing;
  final bool? disableAutoResize;

  HMSVideoTrackSetting({
    this.codec,
    this.resolution,
    this.maxBitrate,
    this.maxFrameRate,
    this.cameraFacing,
    this.disableAutoResize = false
  });

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
      disableAutoResize: map['disable_auto_resize']??false
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
      'disable_auto_resize':disableAutoResize??false
    };
  }
}
