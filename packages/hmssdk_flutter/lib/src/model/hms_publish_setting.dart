// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSPublishSetting {
  final List<String> allowed;
  final HMSAudioSetting? audioSetting;
  final HMSVideoSetting? videoSetting;
  final HMSVideoSetting? screenSetting;
  final HMSSimulcastSettings? simulcast;

  HMSPublishSetting(
      {required this.allowed,
      this.audioSetting,
      this.videoSetting,
      this.screenSetting,
      this.simulcast});

  factory HMSPublishSetting.fromMap(Map map) {
    List<String> allowed;
    if (map.containsKey('allowed')) {
      allowed = map['allowed'].cast<String>();
    } else
      allowed = [];

    HMSAudioSetting? audioSetting;
    if (map.containsKey('audio'))
      audioSetting = HMSAudioSetting.fromMap(map['audio']);
    HMSVideoSetting? videoSetting;
    if (map.containsKey('video')) {
      videoSetting = HMSVideoSetting.fromMap(map['video']);
    }
    HMSVideoSetting? screenSetting;
    if (map.containsKey('screen')) {
      screenSetting = HMSVideoSetting.fromMap(map['screen']);
    }
    HMSSimulcastSettings? simulcastSettings;
    if (map.containsKey('simulcast')) {
      simulcastSettings = HMSSimulcastSettings.fromMap(map['simulcast']);
    }

    return HMSPublishSetting(
        allowed: allowed,
        audioSetting: audioSetting,
        videoSetting: videoSetting,
        screenSetting: screenSetting,
        simulcast: simulcastSettings);
  }
}
