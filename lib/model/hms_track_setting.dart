import 'package:hmssdk_flutter/model/hms_audio_track_setting.dart';
import 'package:hmssdk_flutter/model/hms_video_track_setting.dart';

class HMSTrackSetting {
  final HMSAudioTrackSetting audioTrackSetting;
  final HMSVideoTrackSetting videoTrackSetting;

  factory HMSTrackSetting.fromMap(Map<String, dynamic> map) {
    return new HMSTrackSetting(
      audioTrackSetting: map['audioTrackSetting'] as HMSAudioTrackSetting,
      videoTrackSetting: map['videoTrackSetting'] as HMSVideoTrackSetting,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'audioTrackSetting': this.audioTrackSetting,
      'videoTrackSetting': this.videoTrackSetting,
    } as Map<String, dynamic>;
  }

  HMSTrackSetting(
      {required this.audioTrackSetting, required this.videoTrackSetting});
}
