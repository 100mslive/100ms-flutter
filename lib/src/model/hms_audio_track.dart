// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///parent of all audio tracks
class HMSAudioTrack extends HMSTrack {
  HMSAudioTrack({
    required HMSTrackKind kind,
    required String source,
    required String trackId,
    required String trackDescription,
    required bool isMute,
  }) : super(
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  ///returns true if audio is mute
  factory HMSAudioTrack.fromMap({required Map map}) {
    if (map["hms_audio_track_settings"] == null) {
      return HMSRemoteAudioTrack.fromMap(map: map);
    }
    return HMSLocalAudioTrack.fromMap(map: map);
  }
}
