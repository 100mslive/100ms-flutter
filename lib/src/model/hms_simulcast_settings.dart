import 'package:hmssdk_flutter/src/model/hms_simulcast_settings_policy.dart';

class HMSSimulcastSettings {
  final HMSSimulcastSettingsPolicy? video;
  final HMSSimulcastSettingsPolicy? screen;

  HMSSimulcastSettings({this.video, this.screen});

  factory HMSSimulcastSettings.fromMap(Map map) {
    return HMSSimulcastSettings(
        video: map.containsKey("video") && map["video"].isNotEmpty
            ? HMSSimulcastSettingsPolicy.fromMap(map["video"])
            : null,
        screen: map.containsKey("screen") && map["screen"].isNotEmpty
            ? HMSSimulcastSettingsPolicy.fromMap(map["screen"])
            : null);
  }
}
