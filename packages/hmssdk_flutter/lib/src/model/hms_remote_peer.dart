// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///100ms HMSRemotePeer.
///
/// To use, import `package:hmssdk_flutter/model/hms__remote_peer.dart`.
///
///[HMSRemotePeer] model contains everything about a remote peer and it's tracks information.
///
/// A [peer] is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.
///
///This library depends only on core Dart libraries and hms_remote_audio_track.dart, hms_role.dart, hms_track.dart, hms_remote_video_track.dart library.

class HMSRemotePeer extends HMSPeer {
  @override
  String toString() {
    return 'HMSPeer{name: $name, isLocal: $isLocal}';
  }

  HMSRemoteAudioTrack? audioRemoteTrack;
  HMSRemoteVideoTrack? videoRemoteTrack;

  HMSRemotePeer(
      {required String peerId,
      required String name,
      required bool isHandRaised,
      bool isLocal = false,
      required HMSRole role,
      String? customerUserId,
      String? metadata,
      this.audioRemoteTrack,
      this.videoRemoteTrack,
      List<HMSTrack>? auxiliaryTracks,
      HMSNetworkQuality? networkQuality,
      DateTime? joinedAt,
      DateTime? updatedAt})
      : super(
            peerId: peerId,
            name: name,
            isLocal: isLocal,
            isHandRaised: isHandRaised,
            role: role,
            customerUserId: customerUserId,
            metadata: metadata,
            audioTrack: audioRemoteTrack,
            videoTrack: videoRemoteTrack,
            auxiliaryTracks: auxiliaryTracks,
            networkQuality: networkQuality,
            joinedAt: joinedAt,
            updatedAt: updatedAt);

  ///important to compare using [peerId]
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSPeer &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId;

  @override
  int get hashCode => peerId.hashCode;

  factory HMSRemotePeer.fromMap(Map map) {
    HMSRole role = HMSRole.fromMap(map['role']);
    // TODO: add auxiliary tracks
    HMSRemotePeer peer = HMSRemotePeer(
      peerId: map['peer_id'],
      name: map['name'],
      isLocal: map['is_local'],
      isHandRaised: map['is_hand_raised'],
      role: role,
      metadata: map['metadata'],
      customerUserId: map['customer_user_id'],
      networkQuality: map["network_quality"] != null
          ? HMSNetworkQuality.fromMap(map["network_quality"])
          : null,
      joinedAt: map.containsKey("joined_at")
          ? HMSDateExtension.convertDate(map["joined_at"])
          : null,
      updatedAt: map.containsKey("updated_at")
          ? HMSDateExtension.convertDate(map["updated_at"])
          : null,
    );

    if (map['audio_track'] != null) {
      peer.audioRemoteTrack =
          HMSAudioTrack.fromMap(map: map['audio_track']!, isLocal: false)
              as HMSRemoteAudioTrack;
    }

    if (map['video_track'] != null) {
      peer.videoRemoteTrack =
          HMSVideoTrack.fromMap(map: map['video_track']!, isLocal: false)
              as HMSRemoteVideoTrack;
    }

    return peer;
  }

  static List<HMSPeer> fromListOfMap(List peersMap) {
    List<HMSPeer> peers = peersMap.map((e) => HMSPeer.fromMap(e)).toList();
    return peers;
  }
}
