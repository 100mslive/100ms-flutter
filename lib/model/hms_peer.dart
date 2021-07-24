import 'package:hmssdk_flutter/model/hms_audio_track.dart';
import 'package:hmssdk_flutter/model/hms_role.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_video_track.dart';

// TODO: Need to update models with HMSSDK v0.0.6
class HMSPeer {
  final String peerId;
  final String name;
  final bool isLocal;
  final HMSRole? role;
  final String? customerUserId;
  final String? customerDescription;
  final HMSAudioTrack? audioTrack;
  final HMSVideoTrack? videoTrack;
  final List<HMSTrack>? auxiliaryTracks;

  HMSPeer({
    required this.peerId,
    required this.name,
    required this.isLocal,
    this.role,
    this.customerUserId,
    this.customerDescription,
    this.audioTrack,
    this.videoTrack,
    this.auxiliaryTracks,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSPeer &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId;

  @override
  int get hashCode => peerId.hashCode;

  factory HMSPeer.fromMap(Map map) {
    //TODO:: parse hms audio and video tracks

    return HMSPeer(
      peerId: map['peer_id'],
      name: map['name'],
      isLocal: map['is_local'],
      role: HMSRole.fromMap(map['role']),
      customerDescription: map['customer_description'],
      customerUserId: map['customer_user_id'],
    );
  }

  static List<HMSPeer> fromListOfMap(List<Map> peersMap) {
    List<HMSPeer> peers = peersMap.map((e) => HMSPeer.fromMap(e)).toList();
    return peers ?? [];
  }

  @override
  String toString() {
    return 'HMSPeer{peerId: $peerId, name: $name, isLocal: $isLocal, role: $role, customerUserId: $customerUserId, customerDescription: $customerDescription, audioTrack: $audioTrack, videoTrack: $videoTrack, auxiliaryTracks: $auxiliaryTracks}';
  }
}
