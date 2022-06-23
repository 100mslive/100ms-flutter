
import 'package:equatable/equatable.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode extends Equatable {


  final HMSVideoTrack? hmsVideoTrack;
  final bool? isMute;
  final HMSPeer? peer;
  final bool isOffScreen;

  const PeerTrackNode(
      this.hmsVideoTrack, this.isMute, this.peer, this.isOffScreen);


  @override
  List<Object?> get props => [hmsVideoTrack, isMute, peer, isOffScreen];

  PeerTrackNode copyWith({
    HMSVideoTrack? hmsVideoTrack,
    bool? isMute,
    HMSPeer? peer,
    bool? isOffScreen,
  }) {
    return PeerTrackNode(
      hmsVideoTrack ?? this.hmsVideoTrack,
      isMute ?? this.isMute,
      peer ?? this.peer,
      isOffScreen ?? this.isOffScreen,
    );
  }
}
