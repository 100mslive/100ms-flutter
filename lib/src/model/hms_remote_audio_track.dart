import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import 'hms_audio_track_setting.dart';

class HMSRemoteAudioTrack extends HMSAudioTrack {
  final HMSAudioTrackSetting setting;

  HMSRemoteAudioTrack(
      {required this.setting,
      required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      HMSPeer? peer})
      : super(
            kind: kind,
            source: source,
            trackDescription: trackDescription,
            trackId: trackId,
            isMute: isMute,
            peer: peer);
}
