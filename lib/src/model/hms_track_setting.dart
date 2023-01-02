// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSTrackSetting
///
///[HMSTrackSetting] contains audioTrackSetting and videoTrackSetting.
///
///Refer [HMSTrackSetting guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/set-track-settings)
class HMSTrackSetting {
  HMSAudioTrackSetting? audioTrackSetting;
  HMSVideoTrackSetting? videoTrackSetting;

  HMSTrackSetting({this.audioTrackSetting, this.videoTrackSetting});

  factory HMSTrackSetting.fromMap(Map map) {
    HMSAudioTrackSetting? audioTrackSetting;
    HMSVideoTrackSetting? videoTrackSetting;
    if (map.containsKey('audio_track_setting')) {
      audioTrackSetting =
          HMSAudioTrackSetting.fromMap(map['audio_track_setting']);
    }
    if (map.containsKey('video_track_setting')) {
      videoTrackSetting =
          HMSVideoTrackSetting.fromMap(map['video_track_setting']);
    }
    return HMSTrackSetting(
      audioTrackSetting: audioTrackSetting,
      videoTrackSetting: videoTrackSetting,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'audio_track_setting': audioTrackSetting?.toMap(),
      'video_track_setting': videoTrackSetting?.toMap(),
    };
  }
}
