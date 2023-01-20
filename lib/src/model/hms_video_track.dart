// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'dart:developer';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSVideoTrack
///
///[HMSVideoTrack] contains information about video track of peer.
class HMSVideoTrack extends HMSTrack {
  final bool isDegraded;

  HMSVideoTrack({
    this.isDegraded = false,
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

  factory HMSVideoTrack.fromMap({required Map map, required bool isLocal}) {
    return isLocal
        ? HMSLocalVideoTrack.fromMap(map: map)
        : HMSRemoteVideoTrack.fromMap(map: map);
  }

    void sendTrackNotif(){
    log("%%% trackId-- $trackId");
    PlatformService.invokeMethod(PlatformMethod.sendTrackNotif,
        arguments: {
          "track_id": trackId,
        });
  } 
}
