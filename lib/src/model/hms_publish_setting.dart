// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSPublishSetting {
  final List<String> allowed;
  final HMSAudioSetting? audioSetting;
  final HMSVideoSetting? videoSetting;
  final HMSVideoSetting? screenSetting;
  final HMSSimulCastSettings? audioSimulCast;
  final HMSSimulCastSettings? videoSimulCast;
  final HMSSimulCastSettings? screenSimulCast;

  HMSPublishSetting(
      {required this.allowed,
      this.audioSetting,
      this.videoSetting,
      this.screenSetting,
      this.audioSimulCast,
      this.videoSimulCast,
      this.screenSimulCast});

  factory HMSPublishSetting.fromMap(Map map) {
    List<String> allowed;
    if (map.containsKey('allowed')) {
      allowed = map['allowed'].cast<String>();
    } else
      allowed = [];

    HMSAudioSetting? audioSetting;
    if (map.containsKey('audio_setting'))
      audioSetting = HMSAudioSetting.fromMap(map['audio_setting']);
    HMSVideoSetting? videoSetting;
    if (map.containsKey('video_setting')) {
      videoSetting = HMSVideoSetting.fromMap(map['video_setting']);
    }
    HMSVideoSetting? screenSetting;
    if (map.containsKey('screen_setting')) {
      screenSetting = HMSVideoSetting.fromMap(map['screen_setting']);
    }
    HMSSimulCastSettings? audioSimulCast;
    if (map.containsKey('audio_simul_cast')) {
      audioSimulCast = HMSSimulCastSettings.fromMap(map['audio_simul_cast']);
    }
    HMSSimulCastSettings? videoSimulCast;
    if (map.containsKey('video_simul_cast')) {
      videoSimulCast = HMSSimulCastSettings.fromMap(map['video_simul_cast']);
    }
    HMSSimulCastSettings? screenSimulCast;
    if (map.containsKey('screen_simul_cast')) {
      screenSimulCast = HMSSimulCastSettings.fromMap(map['screen_simul_cast']);
    }

    return HMSPublishSetting(
        allowed: allowed,
        audioSetting: audioSetting,
        videoSetting: videoSetting,
        screenSetting: screenSetting,
        audioSimulCast: audioSimulCast,
        videoSimulCast: videoSimulCast,
        screenSimulCast: screenSimulCast);
  }
}
