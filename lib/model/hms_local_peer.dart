import 'package:hmssdk_flutter/model/hms_audio_track.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_role.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_video_track.dart';

class HMSLocalPeer extends HMSPeer {
  HMSLocalPeer({
    required String peerId,
    required String name,
    required bool isLocal,
    HMSRole? role,
    String? customerUserId,
    String? customerDescription,
    HMSAudioTrack? audioTrack,
    HMSVideoTrack? videoTrack,
    List<HMSTrack>? auxiliaryTracks,
  }) : super(
            isLocal: isLocal,
            name: name,
            peerId: peerId,
            customerUserId: customerUserId,
            customerDescription: customerDescription,
            role: role,
            audioTrack: audioTrack,
            videoTrack: videoTrack,
            auxiliaryTracks: auxiliaryTracks);

// HMSLocalAudioTrack localAudioTrack() {}
// HMSLocalVideoTrack localVideoTrack() {
//
// }
}
