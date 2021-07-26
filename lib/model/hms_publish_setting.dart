import 'package:hmssdk_flutter/model/hms_audio_setting.dart';
import 'package:hmssdk_flutter/model/hms_simul_cast_settings.dart';
import 'package:hmssdk_flutter/model/hms_video_setting.dart';

class HMSPublishSetting {
  final HMSAudioSetting audioSetting;
  final HMSVideoSetting videoSetting;
  final HMSVideoSetting screenSetting;
  final HMSSimulCastSettings? audioSimulCast;
  final HMSSimulCastSettings? videoSimulCast;
  final HMSSimulCastSettings? screenSimulCast;

  HMSPublishSetting(
      {required this.audioSetting,
      required this.videoSetting,
      required this.screenSetting,
      this.audioSimulCast,
      this.videoSimulCast,
      this.screenSimulCast});

  factory HMSPublishSetting.fromMap(Map map) {
    return HMSPublishSetting(
        audioSetting: HMSAudioSetting.fromMap(map['audio_setting'] ?? {}),
        videoSetting: HMSVideoSetting.fromMap(map['video_setting'] ?? {}),
        screenSetting: HMSVideoSetting.fromMap(map['screen_setting'] ?? {}),
        audioSimulCast:
            HMSSimulCastSettings.fromMap(map['audio_simul_cast'] ?? {}),
        videoSimulCast:
            HMSSimulCastSettings.fromMap(map['video_simul_cast'] ?? {}),
        screenSimulCast:
            HMSSimulCastSettings.fromMap(map['screen_simul_cast'] ?? {}));
  }
}
