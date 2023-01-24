///A track represents either the audio or video that a peer is publishing.

// Project imports:

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
  
///100ms HMSTrack
///
///Parent of all tracks
class HMSTrack {
  final String trackId;
  final HMSTrackKind kind;
  final String source;
  final String trackDescription;
  final bool isMute;

  const HMSTrack({
    required this.trackId,
    required this.kind,
    required this.source,
    required this.trackDescription,
    required this.isMute,
  });

  factory HMSTrack.fromMap({required Map map, required bool isLocal}) {
    HMSTrackKind hmsTrackKind =
        HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']);
    if (hmsTrackKind == HMSTrackKind.kHMSTrackKindVideo) {
      return HMSVideoTrack.fromMap(map: map, isLocal: isLocal);
    }
    return HMSAudioTrack.fromMap(map: map, isLocal: isLocal);
  }

  factory HMSTrack.copyWith(bool? isHighest, {required HMSTrack track}) {
    return HMSTrack(
        kind: track.kind,
        source: track.source,
        trackId: track.trackId,
        trackDescription: track.trackDescription,
        isMute: track.isMute);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSTrack &&
          runtimeType == other.runtimeType &&
          trackId == other.trackId;

  @override
  int get hashCode => trackId.hashCode;

  @override
  String toString() {
    return 'HMSTrack{trackId: $trackId, kind: $kind, source: $source, trackDescription: $trackDescription,isMute: $isMute}';
  }

}
