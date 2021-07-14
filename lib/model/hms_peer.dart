import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/model/hms_audio_track.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_video_track.dart';

class HMSPeer {
  final String peerId;
  final String name;
  final bool isLocal;
  final String? role;

  @override
  String toString() {
    return 'HMSPeer{peerId: $peerId, name: $name, isLocal: $isLocal, role: $role, customerUserId: $customerUserId, customerDescription: $customerDescription, audioTrack: $audioTrack, videoTrack: $videoTrack, auxiliaryTracks: $auxiliaryTracks, update: $update}';
  }

  final String? customerUserId;
  final String? customerDescription;
  final HMSAudioTrack? audioTrack;
  final HMSVideoTrack? videoTrack;
  final List<HMSTrack>? auxiliaryTracks;
  final HMSPeerUpdate? update;

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
    this.update = HMSPeerUpdate.defaultUpdate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HMSPeer &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId;

  @override
  int get hashCode => peerId.hashCode;

  factory HMSPeer.fromMap(Map<String, dynamic> map) {
    return HMSPeer(
        peerId: map['peer_id'],
        name: map['name'],
        isLocal: map['is_local'],
        role: map['role'],
        customerDescription: map['customer_description'],
        customerUserId: map['customer_user_id'],
        update: HMSPeerUpdateValues.getHMSPeerUpdateFromName(map['status']));
  }


}
