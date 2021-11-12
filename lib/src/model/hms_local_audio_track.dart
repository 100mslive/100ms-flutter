import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSLocalAudioTrack extends HMSAudioTrack {
  final HMSAudioTrackSetting setting;

  HMSLocalAudioTrack(
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

  void setMute() {
    //TODO:: call platform method
  }

  factory HMSLocalAudioTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSLocalAudioTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: map['track_source'],
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        peer: peer,
        setting: HMSAudioTrackSetting.fromMap(map["hms_audio_track_settings"]));
  }
}
