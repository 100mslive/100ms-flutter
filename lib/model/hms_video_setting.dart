import 'package:hmssdk_flutter/enum/hms_video_codec.dart';

class HMSVideoSetting {
  final int bitRate;
  final HMSVideoCodec codec;
  final int frameRate;
  final int width;
  final int height;

  HMSVideoSetting(
      {required this.bitRate,
      required this.codec,
      required this.frameRate,
      required this.width,
      required this.height});

  factory HMSVideoSetting.fromMap(Map map) {
    return HMSVideoSetting(
        bitRate: map['bit_rate'],
        codec: HMSVideoCodecValues.getHMSCodecFromName(map['codec']),
        frameRate: map['frame_rate'],
        width: map['width'],
        height: map['height']);
  }
}
