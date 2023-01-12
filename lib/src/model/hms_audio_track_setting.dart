// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';

///100ms HMSAudioTrackSetting
///
///[HMSAudioTrackSetting] contains the useHardwareAcousticEchoCanceler, audioSource(iOS only), and trackInitialState.
///
///Refer [HMSAudioTrackSetting guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/set-track-settings#for-the-audio-track-we-can-set-the-following-properties)
class HMSAudioTrackSetting {
  /// [useHardwareAcousticEchoCanceler] controls if the built-in HW acoustic echo canceler should be used or not.
  /// The default is on if it is supported.
  /// Please note that on some devices the hardware wrongly reports the HW echo canceler to be present whereas it does not work
  /// In such as application need to set this to false, so that SW echo canceler is picked up.
  final bool? useHardwareAcousticEchoCanceler;

  ///[audioSource] only for iOS. Used for audioSharing use cases.
  HMSAudioMixerSource? audioSource;

  ///[trackInitialState] property to set the initial state of the audio track i.e Mute/Unmute.By default it's unmuted.
  final HMSTrackInitState? trackInitialState;

  HMSAudioTrackSetting(
      {this.useHardwareAcousticEchoCanceler,
      this.audioSource,
      this.trackInitialState = HMSTrackInitState.UNMUTED});

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
        useHardwareAcousticEchoCanceler:
            map['user_hardware_acoustic_echo_canceler'] ?? null,
        audioSource: audioMixerSource,
        trackInitialState: map.containsKey("track_initial_state")
            ? HMSTrackInitStateValue.getHMSTrackInitStateFromName(
                map['track_initial_state'])
            : HMSTrackInitState.UNMUTED);
  }

  Map<String, dynamic> toMap() {
    return {
      'user_hardware_acoustic_echo_canceler': useHardwareAcousticEchoCanceler,
      'audio_source': audioSource?.toList(),
      'track_initial_state':
          HMSTrackInitStateValue.getValuefromHMSTrackInitState(
              trackInitialState)
    };
  }
}
