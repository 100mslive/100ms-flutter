// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSRemotelVideoTrack
///
///[HMSLocalVideoTrack] contains the remote peer video track infomation.
class HMSRemoteVideoTrack extends HMSVideoTrack {
  bool isPlaybackAllowed;
  HMSRemoteVideoTrack(
      {required bool isDegraded,
      required HMSTrackKind kind,
      required String source,
      required String trackId,
      required String trackDescription,
      required bool isMute,
      required this.isPlaybackAllowed})
      : super(
          isDegraded: isDegraded,
          kind: kind,
          source: source,
          trackDescription: trackDescription,
          trackId: trackId,
          isMute: isMute,
        );

  factory HMSRemoteVideoTrack.fromMap({required Map map}) {
    return HMSRemoteVideoTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source: (map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        isMute: map['track_mute'],
        isDegraded: map['is_degraded'],
        isPlaybackAllowed: map['is_playback_allowed']);
  }

  Future<HMSException?> setPlaybackAllowed(bool isPlaybackAllowed) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.setPlaybackAllowedForTrack,
        arguments: {
          "is_playback_allowed": isPlaybackAllowed,
          "track_id": trackId,
          "track_kind": HMSTrackKindValue.getValueFromHMSTrackKind(
              HMSTrackKind.kHMSTrackKindVideo)
        });

    if (result == null) {
      this.isPlaybackAllowed = isPlaybackAllowed;
      return null;
    } else {
      return HMSException.fromMap(result["error"]);
    }
  }
}
