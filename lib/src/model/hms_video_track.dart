// Project imports:
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
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

  ///[captureSnapshot] function used to capture a snapshot of the video stream of a local or remote peer's video.
  Future<Uint8List?> captureSnapshot() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.captureSnapshot,
        arguments: {"track_id": trackId});
    if (result != null) {
      return base64.decode(result.replaceAll(RegExp(r'\s+'), ''));
    }
    return null;
  }
}
