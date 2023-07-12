// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSVideoSetting
///
///[HMSVideoSetting] contains bitrate, codec, framerate, width and height.
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
        bitRate: map['bit_rate'] ?? 0,
        codec: HMSVideoCodecValues.getHMSCodecFromName(map['codec'] ?? ''),
        frameRate: map['frame_rate'],
        width: map['width'],
        height: map['height']);
  }
}
