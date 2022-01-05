// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSAudioTrackSetting {
  final int? maxBitrate;
  final HMSAudioCodec? hmsAudioCodec;
  final bool? useHardwareAcousticEchoCanceler;
  final double? volume;

  HMSAudioTrackSetting(
      {this.maxBitrate,
      this.hmsAudioCodec,
      this.useHardwareAcousticEchoCanceler,
      this.volume});

  factory HMSAudioTrackSetting.fromMap(Map map) {
    return HMSAudioTrackSetting(
        volume: map['volume'],
        maxBitrate: map['bit_rate'],
        hmsAudioCodec:
            HMSAudioCodecValues.getHMSCodecFromName(map['audio_codec']),
        useHardwareAcousticEchoCanceler:
            map['user_hardware_acoustic_echo_canceler']);
  }

  Map<String, dynamic> toMap() {
    return {
      'bit_rate': maxBitrate,
      'volume': volume,
      'audio_codec': hmsAudioCodec != null
          ? HMSAudioCodecValues.getValueFromHMSAudioCodec(hmsAudioCodec!)
          : null,
      'user_hardware_acoustic_echo_canceler': useHardwareAcousticEchoCanceler
    };
  }
}
