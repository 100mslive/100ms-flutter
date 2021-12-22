import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///HMSLocalPeer instance of the localPeer means your instance in the room.
class HMSLocalPeer extends HMSPeer {
  HMSLocalPeer({
    required String peerId,
    required String name,
    required bool isLocal,
    HMSRole? role,
    String? customerUserId,
    String? metadata,
    HMSLocalAudioTrack? audioTrack,
    HMSLocalVideoTrack? videoTrack,
    List<HMSTrack>? auxiliaryTracks,
  }) : super(
            isLocal: isLocal,
            name: name,
            peerId: peerId,
            customerUserId: customerUserId,
            metadata: metadata,
            role: role,
            audioTrack: audioTrack,
            videoTrack: videoTrack,
            auxiliaryTracks: auxiliaryTracks);

  factory HMSLocalPeer.fromMap(Map map) {
    return HMSLocalPeer(
        peerId: map['peer_id'],
        name: map['name'],
        isLocal: map['is_local'],
        role: HMSRole.fromMap(map['role']),
        metadata: map['metadata'],
        customerUserId: map['customer_user_id'],
        audioTrack: map["audio_track"] != null
            ? HMSLocalAudioTrack.fromMap(map: map["audio_track"])
            : null,
        videoTrack: map["video_track"] != null
            ? HMSLocalVideoTrack.fromMap(map: map["video_track"])
            : null);
  }
}
