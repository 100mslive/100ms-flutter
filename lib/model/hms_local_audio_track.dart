import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/model/hms_audio_track.dart';
import 'package:hmssdk_flutter/model/hms_audio_track_setting.dart';

class HMSLocalAudioTrack extends HMSAudioTrack {
  final HMSAudioTrackSetting setting;

  HMSLocalAudioTrack(
      {required this.setting,
      required HMSTrackKind kind,
      required HMSTrackSource source,
      required String trackId,
      required String trackDescription})
      : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
        );

  void setMute() {
    //TODO:: call platform method
  }
}
