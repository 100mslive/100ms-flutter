import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/model/hms_audio_track.dart';

import 'hms_audio_track_setting.dart';

class HMSRemoteAudioTrack extends HMSAudioTrack {
  final HMSAudioTrackSetting setting;

  HMSRemoteAudioTrack(
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

  @override
  Future<bool> isMute() {
    // TODO: implement isMute
    return super.isMute();
  }
}
