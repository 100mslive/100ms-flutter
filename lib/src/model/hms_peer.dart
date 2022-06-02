///100ms HMSPeer.
///
/// To use, import `package:hmssdk_flutter/model/hms_peer.dart`.
///
///[HMSPeer] model contains everything about a peer and it's tracks information.
///
/// A [peer] is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.
///
///This library depends only on core Dart libraries and hms_audio_track.dart, hms_role.dart, hms_track.dart, hms_video_track.dart library.

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSPeer {
  ///id of the peer
  late final String peerId;

  ///name of the peer in the room.
  final String name;

  ///returns whether peer is local or not.
  final bool isLocal;

  @override
  String toString() {
    return 'HMSPeer{name: $name, isLocal: $isLocal}';
  }

  ///role of the peer in the room.
  final HMSRole role;
  final String? customerUserId;
  final String? metadata;
  HMSAudioTrack? audioTrack;
  HMSVideoTrack? videoTrack;
  final List<HMSTrack>? auxiliaryTracks;
  final HMSNetworkQuality? networkQuality;

  HMSPeer({
    required this.peerId,
    required this.name,
    required this.isLocal,
    required this.role,
    this.customerUserId,
    this.metadata,
    this.audioTrack,
    this.videoTrack,
    this.auxiliaryTracks,
    this.networkQuality,
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
            role: role,
            metadata: map['metadata'],
            customerUserId: map['customer_user_id'],
            networkQuality: map['network_quality'] == null
                ? null
                : HMSNetworkQuality.fromMap(map['network_quality']))
        : HMSRemotePeer(
            peerId: map['peer_id'],
            name: map['name'],
            isLocal: map['is_local'],
            role: role,
            metadata: map['metadata'],
            customerUserId: map['customer_user_id'],
            networkQuality: map['network_quality'] == null
                ? null
                : HMSNetworkQuality.fromMap(map['network_quality']));

    if (map['audio_track'] != null) {
      peer.audioTrack = HMSAudioTrack.fromMap(map: map['audio_track']!);
    }

    if (map['video_track'] != null) {
      peer.videoTrack = HMSVideoTrack.fromMap(map: map['video_track']!);
    }

    return peer;
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
      HMSTrack hmsTrack = HMSTrack.fromMap(map: element);
      tracks.add(hmsTrack);
    });

    return tracks;
  }

  Future<HMSTrack> getTrackById({required String trackId}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.getTrackById,
        arguments: {"peer_id": this.peerId, "track_id": trackId});

    HMSTrack hmsTrack = HMSTrack.fromMap(map: result);
    return hmsTrack;
  }
}
