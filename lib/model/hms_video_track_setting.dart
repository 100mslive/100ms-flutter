import 'package:hmssdk_flutter/enum/hms_camera_facing.dart';
import 'package:hmssdk_flutter/enum/hms_codec.dart';
import 'package:hmssdk_flutter/model/hms_video_resolution.dart';

class HMSVideoTrackSetting {
  final HMSCodec codec;
  final HMSVideoResolution? resolution;
  final int maxBitrate;
  final int maxFrameRate;
  final HMSCameraFacing cameraFacing;
  final String trackDescription;

  HMSVideoTrackSetting(
      {required this.codec,
      required this.resolution,
      required this.maxBitrate,
      required this.maxFrameRate,
      required this.cameraFacing,
      required this.trackDescription});

  factory HMSVideoTrackSetting.fromMap(Map map) {
    HMSVideoResolution? resolution;
    if (map.containsKey('resolution')) {
      resolution = HMSVideoResolution.fromMap(map['resolution']);
    }
    return HMSVideoTrackSetting(
        codec: HMSCodecValues.getHMSCodecFromName(map['codec']),
        resolution: resolution,
        maxBitrate: map['bit_rate'] ?? 0,
        maxFrameRate: map['max_frame_rate'] ?? 0,
        cameraFacing: HMSCameraFacingValues.getHMSCameraFacingFromName(
            map['camera_facing']),
        trackDescription: map['track_description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'codec': HMSCodecValues.getValueFromHMSCodec(codec),
      'bit_rate': maxBitrate,
      'max_frame_rate': maxFrameRate,
      'track_description': trackDescription,
      'resolution': resolution?.toMap(),
      'camera_facing':
          HMSCameraFacingValues.getValueFromHMSCameraFacing(cameraFacing)
    };
  }
}
