///100ms HMSPeer.
///
/// To use, import `package:hmssdk_flutter/model/hms_peer.dart`.
///
///[HMSPeer] model contains everything about a peer and it's tracks information.
///
/// A [peer] is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.
///
///This library depends only on core Dart libraries and hms_audio_track.dart, hms_role.dart, hms_track.dart, hms_video_track.dart library.

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HMSPeer {
  ///id of the peer
  final String peerId;

  ///name of the peer in the room.
  final String name;

  ///returns whether peer is local or not.
  final bool isLocal;

  @override
  String toString() {
    return 'HMSPeer{name: $name, isLocal: $isLocal}';
  }

  ///role of the peer in the room.
  final HMSRole? role;
  final String? customerUserId;
  final String? metadata;
  HMSAudioTrack? audioTrack;
  HMSVideoTrack? videoTrack;
  final List<HMSTrack>? auxiliaryTracks;

  HMSPeer({
    required this.peerId,
    required this.name,
    required this.isLocal,
    this.role,
    this.customerUserId,
    this.metadata,
    this.audioTrack,
    this.videoTrack,
    this.auxiliaryTracks,
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
    if (Platform.isAndroid) {
      HMSRole? role;
      if (map['role'] != null) role = HMSRole.fromMap(map['role']);
      return HMSPeer(
        peerId: map['peer_id'],
        name: map['name'],
        isLocal: map['is_local'],
        role: role,
        metadata: map['metadata'],
        customerUserId: map['customer_user_id'],
      );
    } else {
      HMSRole? role;

      if (map['role'] != null) role = HMSRole.fromMap(map['role']);

      // TODO: add auxiliary tracks

      HMSPeer peer = HMSPeer(
        peerId: map['peer_id'],
        name: map['name'],
        isLocal: map['is_local'],
        role: role,
        metadata: map['metadata'],
        customerUserId: map['customer_user_id'],
      );

      if (map['audio_track'] != null) {
        peer.audioTrack =
            HMSAudioTrack.fromMap(map: map['audio_track']!, peer: peer);
      }

      if (map['video_track'] != null) {
        peer.videoTrack =
            HMSVideoTrack.fromMap(map: map['video_track']!, peer: peer);
      }

      return peer;
    }
  }

  static List<HMSPeer> fromListOfMap(List peersMap) {
    List<HMSPeer> peers = peersMap.map((e) => HMSPeer.fromMap(e)).toList();
    return peers;
  }
}
