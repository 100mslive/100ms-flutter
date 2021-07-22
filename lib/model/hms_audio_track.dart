import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';

class HMSAudioTrack extends HMSTrack {
  HMSAudioTrack(
      {required HMSTrackKind kind,
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
  bool isMute() {
    //TODO:: make platform call
    return false;
  }
}
