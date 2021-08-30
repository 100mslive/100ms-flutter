///A track represents either the audio or video that a peer is publishing.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Parent of all tracks
class HMSTrack {
  final String trackId;
  final HMSTrackKind kind;
  final HMSTrackSource source;
  final String trackDescription;
  final HMSPeer? peer;
  final bool isHighestAudio;


  Future<bool> isMute() async {
    return false;
  }

  const HMSTrack(
      {required this.kind,
      required this.source,
      required this.trackId,
      required this.trackDescription,
      this.peer,
      this.isHighestAudio = false});

  factory HMSTrack.fromMap({required Map map, HMSPeer? peer}) {
    return HMSTrack(
        trackId: map['track_id'],
        trackDescription: map['track_description'],
        source:
            HMSTrackSourceValue.getHMSTrackSourceFromName(map['track_source']),
        kind: HMSTrackKindValue.getHMSTrackKindFromName(map['track_kind']),
        peer: peer);
  }

  factory HMSTrack.copyWith(bool? isHighest, {required HMSTrack track}) {
    return HMSTrack(
        kind: track.kind,
        source: track.source,
        trackId: track.trackId,
        trackDescription: track.trackDescription,
        isHighestAudio: isHighest??track.isHighestAudio,
        peer: track.peer
    );
  }

  static List<HMSTrack> getHMSTracksFromList(
      {required List listOfMap, HMSPeer? peer}) {
    List<HMSTrack> tracks = [];

    listOfMap.forEach((each) {
      tracks.add(HMSTrack.fromMap(map: each, peer: peer));
    });

    return tracks;
  }

  @override
  String toString() {
    return 'HMSTrack{trackId: $trackId, kind: $kind, source: $source, trackDescription: $trackDescription, peer: $peer}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSTrack &&
          runtimeType == other.runtimeType &&
          trackId == other.trackId &&
          peer?.peerId == other.peer?.peerId;

  @override
  int get hashCode => trackId.hashCode;
}
