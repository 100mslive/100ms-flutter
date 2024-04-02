// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_audio_node.dart';
import 'package:hmssdk_flutter/src/enum/hms_phone_call_state.dart';

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
  /// Refer: Read more about useHardwareAcousticEchoCanceler [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/track/set-track-settings#usehardwareacousticechocanceler)
  final bool? useHardwareAcousticEchoCanceler;

  ///[audioSource] only for iOS. Used for audioSharing use cases.
  ///Refer: Read more about audio source [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/local-audio-share#i-os-setup)
  HMSAudioMixerSource? audioSource;

  ///[trackInitialState] property to set the initial state of the audio track i.e Mute/Unmute.By default it's unmuted.
  ///Refer: Read more about trackInitialState [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/join#join-with-muted-audio-video)
  final HMSTrackInitState? trackInitialState;

  ///[audioMode] property to set the audio mode of audio track i.e voice or music mode
  ///Refer: Read more about audio mode [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/microphone/music-mode)
  final HMSAudioMode? audioMode;

  ///[phoneCallState] property to set the state of microphone i.e mute/unmute on phone call ring
  ///If set to `DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING` then the microphone will not be muted on phone call ring
  ///Similarly if set to `ENABLE_MUTE_ON_PHONE_CALL_RING` then the microphone will be muted on phone call ring
  ///By default it's set to `DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING`
  ///Refer: Read more about phone call state [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/track/set-track-settings#phonecallstate-android-only)
  final HMSAndroidPhoneCallState phoneCallState;

  HMSAudioTrackSetting(
      {this.useHardwareAcousticEchoCanceler,
      this.audioSource,
      this.trackInitialState = HMSTrackInitState.UNMUTED,
      this.audioMode,
      this.phoneCallState =
          HMSAndroidPhoneCallState.DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING});

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
    HMSAudioMode? audioMode;
    if ((map.containsKey("audio_mode")) && (map["audio_mode"] != null)) {
      audioMode = HMSAudioModeValues.getAudioModeFromName(map["audio_mode"]);
    }

    HMSAndroidPhoneCallState phoneCallState =
        HMSAndroidPhoneCallState.DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING;
    if (map.containsKey("phone_call_state")) {
      if (map["phone_call_state"] != "DISABLE_MUTE_ON_VOIP_PHONE_CALL_RING") {
        phoneCallState =
            HMSAndroidPhoneCallState.ENABLE_MUTE_ON_PHONE_CALL_RING;
      }
    }

    return HMSAudioTrackSetting(
        useHardwareAcousticEchoCanceler:
            map['user_hardware_acoustic_echo_canceler'] ?? null,
        audioSource: audioMixerSource,
        trackInitialState: map.containsKey("track_initial_state")
            ? HMSTrackInitStateValue.getHMSTrackInitStateFromName(
                map['track_initial_state'])
            : HMSTrackInitState.UNMUTED,
        audioMode: audioMode,
        phoneCallState: phoneCallState);
  }

  Map<String, dynamic> toMap() {
    return {
      'user_hardware_acoustic_echo_canceler': useHardwareAcousticEchoCanceler,
      'audio_source': audioSource?.toList(),
      'track_initial_state':
          HMSTrackInitStateValue.getValuefromHMSTrackInitState(
              trackInitialState),
      'audio_mode': (audioMode != null)
          ? HMSAudioModeValues.getNameFromHMSAudioMode(audioMode!)
          : null,
      'phone_call_state':
          HMSAndroidPhoneCallStateValue.getValuefromHMSPhoneCallState(
              phoneCallState)
    };
  }
}
