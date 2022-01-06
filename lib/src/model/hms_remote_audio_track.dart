// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSRemoteAudioTrack extends HMSAudioTrack {
  int? volume;

  HMSRemoteAudioTrack(
      {required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      this.volume,
      HMSPeer? peer})
      : super(
            kind: kind,
            source: source,
            trackDescription: trackDescription,
            trackId: trackId,
            isMute: isMute,
            peer: peer);

  factory HMSRemoteAudioTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSRemoteAudioTrack(
      trackId: map['track_id'],
      trackDescription: map['track_description'],
      source: map['track_source'],
      kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
      isMute: map['track_mute'],
      peer: peer,
      volume: (map["volume"]),
    );
  }

  void setVolume(int volume) async {
    bool result = await PlatformService.invokeMethod(PlatformMethod.setVolume,
        arguments: {"peer_id": peer?.peerId, "volume": volume.toDouble()});
    if(result == true)
      this.volume = volume;
  }
}
