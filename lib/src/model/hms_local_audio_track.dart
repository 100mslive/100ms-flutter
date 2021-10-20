import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSLocalAudioTrack extends HMSAudioTrack {
  final HMSAudioTrackSetting setting;

  HMSLocalAudioTrack(
      {required this.setting,
      required HMSTrackKind kind,
      required HMSTrackSource source,
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
}
