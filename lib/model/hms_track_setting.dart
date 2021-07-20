import 'package:hmssdk_flutter/model/hms_audio_track_setting.dart';
import 'package:hmssdk_flutter/model/hms_video_track_setting.dart';

class HMSTrackSetting {
  final HMSAudioTrackSetting audioTrackSetting;
  final HMSVideoTrackSetting videoTrackSetting;

  HMSTrackSetting(
      {required this.audioTrackSetting, required this.videoTrackSetting});
}
