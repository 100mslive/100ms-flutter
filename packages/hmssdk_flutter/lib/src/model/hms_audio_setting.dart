// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSAudioSetting
///
///HMSAudioSetting contains bitrate and codec
class HMSAudioSetting {
  final int bitRate;
  final HMSAudioCodec codec;

  HMSAudioSetting({required this.bitRate, required this.codec});

  factory HMSAudioSetting.fromMap(Map map) {
    return HMSAudioSetting(
        bitRate: map['bit_rate'] ?? 0,
        codec: HMSAudioCodecValues.getHMSCodecFromName(map['codec'] ?? ''));
  }
}
