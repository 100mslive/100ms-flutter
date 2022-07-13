///100ms HMSLocalPeer.
///
/// To use, import `package:hmssdk_flutter/model/hms__local_peer.dart`.
///
///[HMSLocalPeer] model contains everything about a local peer and it's tracks information.
///
/// A [peer] is the object returned by 100ms SDKs that contains all information about a user - name, role, video track etc.
///
///This library depends only on core Dart libraries and hms_local_audio_track.dart, hms_role.dart, hms_track.dart, hms_local_video_track.dart library.

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///HMSLocalPeer instance of the localPeer means your instance in the room.
class HMSLocalPeer extends HMSPeer {
  HMSLocalPeer(
      {required String peerId,
      required String name,
      required bool isLocal,
      required HMSRole role,
      String? customerUserId,
      String? metadata,
      HMSLocalAudioTrack? audioTrack,
      HMSLocalVideoTrack? videoTrack,
      List<HMSTrack>? auxiliaryTracks,
      HMSNetworkQuality? networkQuality})
      : super(
            isLocal: isLocal,
            name: name,
            peerId: peerId,
            customerUserId: customerUserId,
            metadata: metadata,
            role: role,
            audioTrack: audioTrack,
            videoTrack: videoTrack,
            auxiliaryTracks: auxiliaryTracks,
            networkQuality: networkQuality);

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
            : null,
        networkQuality: map["network_quality"] != null
            ? HMSNetworkQuality.fromMap(map["network_quality"])
            : null);
  }
}
