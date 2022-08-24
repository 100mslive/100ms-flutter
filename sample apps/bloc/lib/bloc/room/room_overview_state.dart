import 'package:demo_app_with_100ms_and_bloc/bloc/room/peer_track_node.dart';
import 'package:equatable/equatable.dart';

enum RoomOverviewStatus { initial, loading, success, failure }

class RoomOverviewState extends Equatable {
  final RoomOverviewStatus status;
  final List<PeerTrackNode> peerTrackNodes;
  final bool isVideoMute;
  final bool isAudioMute;
  final bool leaveMeeting;
  final bool isScreenShareActive;
  const RoomOverviewState(
      {this.status = RoomOverviewStatus.initial,
      this.peerTrackNodes = const [],
      this.isVideoMute = false,
      this.isAudioMute = false,
      this.leaveMeeting = false,
      this.isScreenShareActive = false});

  @override
  List<Object?> get props => [
        status,
        peerTrackNodes,
        isAudioMute,
        isVideoMute,
        leaveMeeting,
        isScreenShareActive
      ];

  RoomOverviewState copyWith(
      {RoomOverviewStatus? status,
      List<PeerTrackNode>? peerTrackNodes,
      bool? isVideoMute,
      bool? isAudioMute,
      bool? leaveMeeting,
      bool? isScreenShareActive}) {
    return RoomOverviewState(
        status: status ?? this.status,
        peerTrackNodes: peerTrackNodes ?? this.peerTrackNodes,
        isVideoMute: isVideoMute ?? this.isVideoMute,
        isAudioMute: isAudioMute ?? this.isAudioMute,
        leaveMeeting: leaveMeeting ?? this.leaveMeeting,
        isScreenShareActive: isScreenShareActive ?? this.isScreenShareActive);
  }
}
