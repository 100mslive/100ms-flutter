import 'package:bloc/bloc.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/peer_track_node.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_event.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_state.dart';
import 'package:demo_app_with_100ms_and_bloc/observers/room_observer.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class RoomOverviewBloc extends Bloc<RoomOverviewEvent, RoomOverviewState> {
  final bool isVideoMute;
  final bool isAudioMute;
  HMSSDK hmsSdk = HMSSDK();
  String name;
  String url;
  late RoomObserver roomObserver;

  RoomOverviewBloc(this.isVideoMute, this.isAudioMute, this.name, this.url)
      : super(RoomOverviewState(
            isAudioMute: isAudioMute, isVideoMute: isVideoMute)) {
    roomObserver = RoomObserver(this);
    on<RoomOverviewSubscriptionRequested>(_onSubscription);
    on<RoomOverviewLocalPeerAudioToggled>(_onLocalAudioToggled);
    on<RoomOverviewLocalPeerVideoToggled>(_onLocalVideoToggled);
    on<RoomOverviewOnJoinSuccess>(_onJoinSuccess);
    on<RoomOverviewOnPeerLeave>(_onPeerLeave);
    on<RoomOverviewOnPeerJoin>(_onPeerJoin);
    on<RoomOverviewLeaveRequested>(_leaveRequested);
    on<RoomOverviewSetOffScreen>(_setOffScreen);
  }

  Future<void> _onSubscription(RoomOverviewSubscriptionRequested event,
      Emitter<RoomOverviewState> emit) async {
    await emit.forEach<List<PeerTrackNode>>(
      roomObserver.getTracks(),
      onData: (tracks) {
        return state.copyWith(
            status: RoomOverviewStatus.success, peerTrackNodes: tracks);
      },
      onError: (_, __) => state.copyWith(
        status: RoomOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onLocalVideoToggled(RoomOverviewLocalPeerVideoToggled event,
      Emitter<RoomOverviewState> emit) async {
    hmsSdk.switchVideo(isOn: !state.isVideoMute);
    emit(state.copyWith(isVideoMute: !state.isVideoMute));
  }

  Future<void> _onLocalAudioToggled(RoomOverviewLocalPeerAudioToggled event,
      Emitter<RoomOverviewState> emit) async {
    hmsSdk.switchAudio(isOn: !state.isAudioMute);
    emit(state.copyWith(isAudioMute: !state.isAudioMute));
  }

  Future<void> _onJoinSuccess(
      RoomOverviewOnJoinSuccess event, Emitter<RoomOverviewState> emit) async {
    if(state.isAudioMute){
      hmsSdk.switchAudio(isOn : state.isAudioMute);
    }

    if(state.isVideoMute){
      hmsSdk.switchVideo(isOn : state.isVideoMute);
    }

  }

  Future<void> _onPeerLeave(
      RoomOverviewOnPeerLeave event, Emitter<RoomOverviewState> emit) async {
    await roomObserver.deletePeer(event.hmsPeer.peerId);
  }

  Future<void> _onPeerJoin(
      RoomOverviewOnPeerJoin event, Emitter<RoomOverviewState> emit) async {
    await roomObserver.addPeer(event.hmsVideoTrack, event.hmsPeer);
  }

  Future<void> _leaveRequested(RoomOverviewLeaveRequested event, Emitter<RoomOverviewState> emit) async{
    await roomObserver.leaveMeeting();
    emit(state.copyWith(leaveMeeting: true));
  }

  Future<void> _setOffScreen(RoomOverviewSetOffScreen event, Emitter<RoomOverviewState> emit) async{
    await roomObserver.setOffScreen(event.index,event.setOffScreen);
  }
}
