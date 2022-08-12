// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';

class HMSAudioTrackSetting {
  final int? maxBitrate;
  final HMSAudioCodec? hmsAudioCodec;
  final bool? useHardwareAcousticEchoCanceler;
  final double? volume;
  final String? trackDescription;
  HMSAudioMixerSource? audioSource;

  HMSAudioTrackSetting(
      {this.maxBitrate = 32,
      this.hmsAudioCodec,
      this.useHardwareAcousticEchoCanceler,
      this.volume,
      this.trackDescription = "This is an audio Track",
      this.audioSource});

  factory HMSAudioTrackSetting.fromMap(Map map) {
    List<HMSAudioNode> nodeList = [];
    List? node = map["audio_source"] ?? null;
    HMSAudioMixerSource? audioMixerSource;
    if (node != null) {
      for (String i in node) {
        if (i == "mic_node") {
          nodeList.add(HMSMicNode());
        } else {
          nodeList.add(HMSAudioFilePlayerNode(i));
        }
      }
      audioMixerSource = HMSAudioMixerSource(node: nodeList);
    }
    HMSAudioMixerSource(node: nodeList);
    return HMSAudioTrackSetting(
        volume: map['volume'] ?? null,
        maxBitrate: map['bit_rate'] ?? 32,
        hmsAudioCodec: map["audio_codec"] == null
            ? null
            : HMSAudioCodecValues.getHMSCodecFromName(map['audio_codec']),
        useHardwareAcousticEchoCanceler:
            map['user_hardware_acoustic_echo_canceler'] ?? null,
        trackDescription: map['track_description'] ?? "This is an audio Track",
        audioSource: audioMixerSource);
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
      'audio_source': audioSource?.toList()
    };
  }
}
