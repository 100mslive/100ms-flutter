import 'package:hmssdk_flutter/enum/hms_audio_codec.dart';

class HMSAudioSetting {
  final int bitRate;
  final HMSAudioCodec codec;

  HMSAudioSetting({required this.bitRate, required this.codec});

  factory HMSAudioSetting.fromMap(Map map) {
    // TODO:: do not take input when no data is present
    return HMSAudioSetting(
        bitRate: map['bit_rate'] ?? 0,
        codec: HMSAudioCodecValues.getHMSCodecFromName(map['codec'] ?? ''));
  }
}
