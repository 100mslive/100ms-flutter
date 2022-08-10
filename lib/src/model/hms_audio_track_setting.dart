// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSAudioTrackSetting {
  final int? maxBitrate;
  final HMSAudioCodec? hmsAudioCodec;
  final bool? useHardwareAcousticEchoCanceler;
  final double? volume;
  final String? trackDescription;
  HMSAudioMixerSource? audioSource;

  HMSAudioTrackSetting(
      {this.maxBitrate,
      this.hmsAudioCodec,
      this.useHardwareAcousticEchoCanceler,
      this.volume,
      this.trackDescription = "This is an audio Track",
      this.audioSource});

  factory HMSAudioTrackSetting.fromMap(Map map) {
    return HMSAudioTrackSetting(
        volume: map['volume'] ?? null,
        maxBitrate: map['bit_rate'] ?? 32,
        hmsAudioCodec: map["audio_codec"] == null
            ? null
            : HMSAudioCodecValues.getHMSCodecFromName(map['audio_codec']),
        useHardwareAcousticEchoCanceler:
            map['user_hardware_acoustic_echo_canceler'] ?? null,
        trackDescription: map['track_description'] ?? "This is an audio Track");
  }

  Map<String, dynamic> toMap() {
    return {
      'bit_rate': maxBitrate,
      'volume': volume,
      'audio_codec': hmsAudioCodec != null
          ? HMSAudioCodecValues.getValueFromHMSAudioCodec(hmsAudioCodec!)
          : null,
      'user_hardware_acoustic_echo_canceler': useHardwareAcousticEchoCanceler,
      'track_description': trackDescription,
      'player_node': audioSource?.toList()
    };
  }
}
