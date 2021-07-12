import 'package:hmssdk_flutter/model/hms_audio_track.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_video_track.dart';

class HMSPeer {
  final String peerId;
  final String name;
  final String isLocal;
  final String? role;
  final String? customerUserId;
  final String? customerDescription;
  final HMSAudioTrack? audioTrack;
  final HMSVideoTrack? videoTrack;
  final List<HMSTrack>? auxiliaryTracks;

  HMSPeer(
      {required this.peerId,
      required this.name,
      required this.isLocal,
      this.role,
      this.customerUserId,
      this.customerDescription,
      this.audioTrack,
      this.videoTrack,
      this.auxiliaryTracks});

  factory HMSPeer.fromMap(Map<String, dynamic> map) {
    return HMSPeer(
        peerId: map['peer_id'],
        name: map['name'],
        isLocal: map['isLocal'],
        role: map['role'],
        customerDescription: map['customer_description'],
        customerUserId: map['customer_user_id']);
  }
}
