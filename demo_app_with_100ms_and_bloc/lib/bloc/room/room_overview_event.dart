import 'package:equatable/equatable.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

abstract class RoomOverviewEvent extends Equatable {
  const RoomOverviewEvent();

  @override
  List<Object> get props => [];
}

class RoomOverviewSubscriptionRequested extends RoomOverviewEvent {
  const RoomOverviewSubscriptionRequested();
}

class RoomOverviewLocalPeerVideoToggled extends RoomOverviewEvent {
  const RoomOverviewLocalPeerVideoToggled();
}

class RoomOverviewLocalPeerAudioToggled extends RoomOverviewEvent {
  const RoomOverviewLocalPeerAudioToggled();
}

class RoomOverviewLeaveRequested extends RoomOverviewEvent {
  const RoomOverviewLeaveRequested();
}

class RoomOverviewSetOffScreen extends RoomOverviewEvent{
  final int index;
  final bool setOffScreen;
  const RoomOverviewSetOffScreen(this.setOffScreen,this.index);
}

class RoomOverviewOnJoinSuccess extends RoomOverviewEvent {
  final HMSRoom hmsRoom;
  const RoomOverviewOnJoinSuccess(this.hmsRoom);
}

class RoomOverviewOnPeerLeave extends RoomOverviewEvent {
  final HMSPeer hmsPeer;
  final HMSVideoTrack hmsVideoTrack;
  const RoomOverviewOnPeerLeave(this.hmsVideoTrack,this.hmsPeer);
}

class RoomOverviewOnPeerJoin extends RoomOverviewEvent {
  final HMSPeer hmsPeer;
  final HMSVideoTrack hmsVideoTrack;
  const RoomOverviewOnPeerJoin(this.hmsVideoTrack,this.hmsPeer);
}