import 'package:demo_app_with_100ms_and_bloc/bloc/room/peer_track_node.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_bloc.dart';
import 'package:demo_app_with_100ms_and_bloc/bloc/room/room_overview_event.dart';
import 'package:demo_app_with_100ms_and_bloc/services/RoomService.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:rxdart/subjects.dart';

class RoomObserver implements HMSUpdateListener, HMSActionResultListener {
  RoomOverviewBloc roomOverviewBloc;

  RoomObserver(this.roomOverviewBloc) {
    roomOverviewBloc.hmsSdk.addUpdateListener(listener: this);

    roomOverviewBloc.hmsSdk.build();
    RoomService()
        .getToken(user: roomOverviewBloc.name, room: roomOverviewBloc.url)
        .then((token) {
      if (token == null) return;
      if (token[0] == null) return;

      HMSConfig config = HMSConfig(
        authToken: token[0]!,
        userName: roomOverviewBloc.name,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init",
      );

      roomOverviewBloc.hmsSdk.join(config: config);
    });
  }

  final _peerNodeStreamController =
      BehaviorSubject<List<PeerTrackNode>>.seeded(const []);

  Stream<List<PeerTrackNode>> getTracks() =>
      _peerNodeStreamController.asBroadcastStream();

  Future<void> addPeer(HMSVideoTrack hmsVideoTrack, HMSPeer peer) async{
    final tracks = [..._peerNodeStreamController.value];
    final todoIndex = tracks.indexWhere((t) => t.peer?.peerId == peer.peerId);
    if (todoIndex >= 0) {
      print("onTrackUpdate ${peer.name} ${hmsVideoTrack.isMute}");
      tracks[todoIndex] =
          PeerTrackNode(hmsVideoTrack, hmsVideoTrack.isMute, peer, false);
    } else {
      tracks
          .add(PeerTrackNode(hmsVideoTrack, hmsVideoTrack.isMute, peer, false));
    }

    _peerNodeStreamController.add(tracks);
  }

  Future<void> deletePeer(String id) async {
    final tracks = [..._peerNodeStreamController.value];
    final todoIndex = tracks.indexWhere((t) => t.peer?.peerId == id);
    if (todoIndex >= 0) {
      tracks.removeAt(todoIndex);
    }
    _peerNodeStreamController.add(tracks);
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
    // TODO: implement onError
  }

  @override
  void onJoin({required HMSRoom room}) {
    // TODO: implement onJoin
    roomOverviewBloc.add(RoomOverviewOnJoinSuccess(room));
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        roomOverviewBloc
            .add(RoomOverviewOnPeerLeave(track as HMSVideoTrack, peer));
      } else {

        roomOverviewBloc
            .add(RoomOverviewOnPeerJoin(track as HMSVideoTrack, peer));
      }
    }
  }

  Future<void> leaveMeeting() async{
    roomOverviewBloc.hmsSdk.leave(hmsActionResultListener: this);
  }

  Future<void> setOffScreen(int index, bool setOffScreen) async{
    final tracks = [..._peerNodeStreamController.value];

    if (index >= 0) {
      tracks[index] = tracks[index].copyWith(isOffScreen: setOffScreen);
    }
    _peerNodeStreamController.add(tracks);
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  @override
  void onException({HMSActionResultListenerMethod? methodType, Map<String, dynamic>? arguments, required HMSException hmsException}) {
    // TODO: implement onException
  }

  @override
  void onSuccess({HMSActionResultListenerMethod? methodType, Map<String, dynamic>? arguments}) {
    _peerNodeStreamController.add([]);
  }


}
