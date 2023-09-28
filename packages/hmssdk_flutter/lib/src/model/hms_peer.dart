// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///100ms HMSPeer.
///
/// To use, import `package:hmssdk_flutter/model/hms_peer.dart`.
///
///[HMSPeer] model contains everything about a peer and it's track information.
///
/// A [peer] is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.
///
///This library depends only on core Dart libraries and hms_audio_track.dart, hms_role.dart, hms_track.dart, hms_video_track.dart library.
class HMSPeer {
  ///id of the peer
  late final String peerId;

  ///name of the peer in the room.
  final String name;

  ///returns whether the peer is local or not.
  final bool isLocal;

  ///returns whether peer's hand is raised or not
  final bool isHandRaised;

  ///the current role of the peer in the room
  final HMSRole role;

  ///optional data which can be linked to a peer while joining room
  final String? customerUserId;

  ///optional metadata of the peer in the room
  final String? metadata;

  ///audioTrack of the peer in the room
  HMSAudioTrack? audioTrack;

  ///videoTrack of the peer in the room
  HMSVideoTrack? videoTrack;

  ///auxiliary tracks include Screenshare, Audio or Video files, etc published by this peer in the room
  final List<HMSTrack>? auxiliaryTracks;

  ///networkQuality of the peer in room
  final HMSNetworkQuality? networkQuality;

  ///joinedAt is the time when peer joined the room
  final DateTime? joinedAt;

  ///updatedAt is the time when the peer object was last updated
  final DateTime? updatedAt;

  HMSPeer({
    required this.peerId,
    required this.name,
    required this.isLocal,
    required this.role,
    required this.isHandRaised,
    this.customerUserId,
    this.metadata,
    this.audioTrack,
    this.videoTrack,
    this.auxiliaryTracks,
    this.networkQuality,
    this.joinedAt,
    this.updatedAt,
  });

  ///important to compare using [peerId]
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSPeer &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId;

  @override
  int get hashCode => peerId.hashCode;

  factory HMSPeer.fromMap(Map map) {
    HMSRole role = HMSRole.fromMap(map['role']);

    // TODO: add auxiliary tracks

    HMSPeer peer = (map['is_local'] == true)
        ? HMSLocalPeer(
            peerId: map['peer_id'],
            name: map['name'],
            isLocal: map['is_local'],
            isHandRaised: map['is_hand_raised'],
            role: role,
            metadata: map['metadata'],
            customerUserId: map['customer_user_id'],
            networkQuality: map['network_quality'] == null
                ? null
                : HMSNetworkQuality.fromMap(
                    map['network_quality'],
                  ),
            joinedAt: map.containsKey("joined_at")
                ? HMSDateExtension.convertDate(map["joined_at"])
                : null,
            updatedAt: map.containsKey("updated_at")
                ? HMSDateExtension.convertDate(map["updated_at"])
                : null,
          )
        : HMSRemotePeer(
            peerId: map['peer_id'],
            name: map['name'],
            isLocal: map['is_local'],
            isHandRaised: map['is_hand_raised'],
            role: role,
            metadata: map['metadata'],
            customerUserId: map['customer_user_id'],
            networkQuality: map['network_quality'] == null
                ? null
                : HMSNetworkQuality.fromMap(map['network_quality']),
            joinedAt: map.containsKey("joined_at")
                ? HMSDateExtension.convertDate(map["joined_at"])
                : null,
            updatedAt: map.containsKey("updated_at")
                ? HMSDateExtension.convertDate(map["updated_at"])
                : null,
          );

    if (map['audio_track'] != null) {
      peer.audioTrack = HMSAudioTrack.fromMap(
          map: map['audio_track']!, isLocal: peer.isLocal);
    }

    if (map['video_track'] != null) {
      peer.videoTrack = HMSVideoTrack.fromMap(
          map: map['video_track']!, isLocal: peer.isLocal);
    }

    return peer;
  }


  @override
  String toString() {
    return 'HMSPeer{name: $name, isLocal: $isLocal}';
  }

  static List<HMSPeer> fromListOfMap(List peersMap) {
    List<HMSPeer> peers = peersMap.map((e) => HMSPeer.fromMap(e)).toList();
    return peers;
  }

  Future<List<HMSTrack>> getAllTracks() async {
    var result = await PlatformService.invokeMethod(PlatformMethod.getAllTracks,
        arguments: {"peer_id": this.peerId});
    List<HMSTrack> tracks = [];
    result.forEach((element) {
      HMSTrack hmsTrack = HMSTrack.fromMap(map: element, isLocal: isLocal);
      tracks.add(hmsTrack);
    });

    return tracks;
  }

  Future<HMSTrack> getTrackById({required String trackId}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.getTrackById,
        arguments: {"peer_id": this.peerId, "track_id": trackId});

    HMSTrack hmsTrack = HMSTrack.fromMap(map: result, isLocal: isLocal);
    return hmsTrack;
  }
}
