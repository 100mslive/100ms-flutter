import 'package:hmssdk_flutter/enum/hms_codec.dart';
import 'package:hmssdk_flutter/model/hms_camera_facing.dart';
import 'package:hmssdk_flutter/model/hms_video_resolution.dart';

class HMSVideoTrackSetting {
  final HMSCodec codec;
  final HMSVideoResolution resolution;
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
}
