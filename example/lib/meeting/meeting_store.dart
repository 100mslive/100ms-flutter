import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase with Store implements HMSUpdateListener {
  @observable
  bool isSpeakerOn = true;

  @observable
  HMSError? error;

  @observable
  HMSRoleChangeRequest? roleChangeRequest;

  @observable
  bool isMeetingStarted = false;
  @observable
  bool isVideoOn = true;
  @observable
  bool isMicOn = true;
  @observable
  bool reconnecting = false;
  @observable
  bool reconnected = false;
  @observable
  HMSTrackChangeRequest? hmsTrackChangeRequest;

  late MeetingController meetingController;

  @observable
  List<HMSPeer> peers = ObservableList.of([]);

  @observable
  HMSPeer? localPeer;

  @observable
  HMSTrack? screenTrack;

  @observable
  List<HMSTrack> tracks = ObservableList.of([]);

  @observable
  List<HMSMessage> messages = ObservableList.of([]);

  @observable
  ObservableMap<String, HMSTrackUpdate> trackStatus = ObservableMap.of({});

  @observable
  ObservableMap<String, HMSTrackUpdate> audioTrackStatus = ObservableMap.of({});

  @action
  void startListen() {
    meetingController.addMeetingListener(this);
  }

  @action
  void toggleSpeaker() {
    print("toggleSpeaker");
    if (isSpeakerOn) {
      muteAll();
    } else {
      unMuteAll();
    }
    isSpeakerOn = !isSpeakerOn;
  }

  @action
  Future<void> toggleVideo() async {
    print("toggleVideo ${isVideoOn}");
    await meetingController.switchVideo(isOn: isVideoOn);
    // if(isVideoOn){
    //   meetingController.stopCapturing();
    // }
    // else{
    //   meetingController.startCapturing();
    // }
    isVideoOn = !isVideoOn;
  }

  @action
  Future<void> toggleCamera() async {
    await meetingController.switchCamera();
  }

  @action
  Future<void> toggleAudio() async {
    await meetingController.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
  }

  @action
  void removePeer(HMSPeer peer) {
    peers.remove(peer);
    removeTrackWithPeerId(peer.peerId);
  }

  @action
  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
  }

  @action
  void removeTrackWithTrackId(String trackId) {
    tracks
        .remove(tracks.firstWhere((eachTrack) => eachTrack.trackId == trackId));
  }

  @action
  void removeTrackWithPeerId(String peerId) {
    tracks.removeWhere((eachTrack) => eachTrack.peer?.peerId == peerId);
  }

  @action
  void addTrack(HMSTrack track) {
    if (!tracks.contains(track))
      tracks.add(track);
    else {
      removeTrackWithTrackId(track.trackId);
      addTrack(track);
    }
  }

  @action
  void onRoleUpdated(int index, HMSPeer peer) {
    peers[index] = peer;
  }

  @action
  Future<bool> joinMeeting() async {
    bool ans = await meetingController.joinMeeting();
    if (!ans) return false;
    isMeetingStarted = true;
    return true;
  }

  @action
  Future<void> sendMessage(String message) async {
    await meetingController.sendMessage(message);
  }

  Future<void> sendDirectMessage(String message, String peerId) async {
    await meetingController.sendDirectMessage(message, peerId);
  }

  Future<void> sendGroupMessage(String message, String roleName) async {
    await meetingController.sendGroupMessage(message, roleName);
  }

  @action
  void updateError(HMSError error) {
    this.error = error;
  }

  @action
  void updateRoleChangeRequest(HMSRoleChangeRequest roleChangeRequest) {
    this.roleChangeRequest = roleChangeRequest;
  }

  @action
  void addMessage(HMSMessage message) {
    this.messages.add(message);
  }

  @action
  void addTrackChangeRequestInstance(
      HMSTrackChangeRequest hmsTrackChangeRequest) {
    this.hmsTrackChangeRequest = hmsTrackChangeRequest;
  }

  @action
  void updatePeerAt(peer) {
    int index = this.peers.indexOf(peer);
    this.peers.removeAt(index);
    this.peers.insert(index, peer);
  }

  @override
  void onJoin({required HMSRoom room}) {
    if (Platform.isAndroid) {
      for (HMSPeer each in room.peers!) {
        if (each.isLocal) {
          localPeer = each;
          addPeer(localPeer!);
          print('on join ${localPeer!.peerId}');
          break;
        }
      }
    } else {
      for (HMSPeer each in room.peers!) {
        addPeer(each);
        if (each.isLocal) {
          localPeer = each;
          print('on join ${localPeer!.name}  ${localPeer!.peerId}');
          if (each.videoTrack != null) {
            tracks.insert(0, each.videoTrack!);
          }
        } else {
          if (each.videoTrack != null) {
            tracks.insert(0, each.videoTrack!);
          }
        }
      }
    }
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    print('on room update');
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    peerOperation(peer, update);
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    print("onTrackUpdateFlutter $trackUpdate");
    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      if (isSpeakerOn) {
        unMuteAll();
      } else {
        muteAll();
      }
      audioTrackStatus[peer.peerId] = trackUpdate;
      if (peer.isLocal && trackUpdate == HMSTrackUpdate.trackMuted) {
        this.isMicOn = false;
      }
      return;
    }
    if (track.source == HMSTrackSource.kHMSTrackSourceScreen) {
      //trackStatus[peer.peerId+"Screen"]=trackUpdate;
      if (trackUpdate == HMSTrackUpdate.trackAdded)
        screenTrack = track;
      else
        screenTrack = null;
    } else
      trackStatus[peer.peerId] = track.isMute
          ? HMSTrackUpdate.trackMuted
          : HMSTrackUpdate.trackUnMuted;
    if (peer.isLocal) {
      localPeer = peer;
      if (trackStatus[peer.peerId] == HMSTrackUpdate.trackMuted) {
        this.isVideoOn = false;
      }

      if (Platform.isAndroid) tracks.insert(0, track);
    } else {
      if (track.source != HMSTrackSource.kHMSTrackSourceScreen)
        peerOperationWithTrack(peer, trackUpdate, track);
    }
  }

  @override
  void onError({required HMSError error}) {
    updateError(error);
  }

  @override
  void onMessage({required HMSMessage message}) {
    addMessage(message);
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    debugPrint("onRoleChangeRequest Flutter");
    updateRoleChangeRequest(roleChangeRequest);
  }

  HMSTrack? previousHighestVideoTrack;
  int? previousHighestIndex;
  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    print('speakersFlutter $updateSpeakers');
    if (updateSpeakers.length == 0) return;
    HMSSpeaker highestAudioSpeaker = updateSpeakers[0];
    int newHighestIndex = tracks.indexWhere(
        (element) => element.peer?.peerId == highestAudioSpeaker.peerId);
    if (newHighestIndex == -1) return;

    if (previousHighestVideoTrack != null) {
      HMSTrack newPreviousTrack =
          HMSTrack.copyWith(false, track: previousHighestVideoTrack!);

      int newPrevHighestIndex = tracks.indexWhere((element) {
        print(element.peer?.peerId == previousHighestVideoTrack?.peer?.peerId);

        return element.peer?.peerId == previousHighestVideoTrack?.peer?.peerId;
      });
      if (newPrevHighestIndex != -1) {
        tracks.removeAt(newPrevHighestIndex);

        tracks.insert(newPrevHighestIndex, newPreviousTrack);
      }
    }
    HMSTrack highestAudioSpeakerVideoTrack = tracks[newHighestIndex];
    HMSTrack newHighestTrack =
        HMSTrack.copyWith(true, track: highestAudioSpeakerVideoTrack);
    tracks.removeAt(newHighestIndex);
    tracks.insert(newHighestIndex, newHighestTrack);
    previousHighestVideoTrack = newHighestTrack;
  }

  @override
  void onReconnecting() {
    reconnecting = true;
  }

  @override
  void onReconnected() {
    reconnecting = false;
    reconnected = true;
  }

  int trackChange = -1;
  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    int isVideoTrack =
        hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo
            ? 1
            : 0;
    trackChange = isVideoTrack;
    print("flutteronChangeTrack ${trackChange}");
    addTrackChangeRequestInstance(hmsTrackChangeRequest);
  }

  void changeTracks() {
    print("flutteronChangeTracks ${trackChange}");
    if (trackChange == 1) {
      toggleVideo();
    } else if (trackChange == 0) {
      toggleAudio();
    }
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    meetingController.leaveMeeting();
  }

  void changeRole(
      {required String peerId,
      required String roleName,
      bool forceChange = false}) {
    meetingController.changeRole(
        roleName: roleName, peerId: peerId, forceChange: forceChange);
  }

  Future<List<HMSRole>> getRoles() async {
    return meetingController.getRoles();
  }

  void changeTrackRequest(String peerId, bool mute, bool isVideoTrack) {
    return meetingController.changeTrackRequest(peerId, mute, isVideoTrack);
  }

  @action
  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        print('peer joined');
        addPeer(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        print('peer left');
        removePeer(peer);

        break;
      case HMSPeerUpdate.peerKnocked:
        // removePeer(peer);
        break;
      case HMSPeerUpdate.audioToggled:
        print('Peer audio toggled');
        break;
      case HMSPeerUpdate.videoToggled:
        print('Peer video toggled');
        break;
      case HMSPeerUpdate.roleUpdated:
        print('${peers.indexOf(peer)}');
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.defaultUpdate:
        print("Some default update or untouched case");
        break;
      default:
        print("Some default update or untouched case");
    }
  }

  @action
  void peerOperationWithTrack(
      HMSPeer peer, HMSTrackUpdate update, HMSTrack track) {
    print("onTrackUpdateFlutter $update ${peer.isLocal} update");
    switch (update) {
      case HMSTrackUpdate.trackAdded:
        if (track.kind == HMSTrackKind.kHMSTrackKindVideo) addTrack(track);
        break;
      case HMSTrackUpdate.trackRemoved:
        removeTrackWithTrackId(track.trackId);
        break;
      case HMSTrackUpdate.trackMuted:
        break;
      case HMSTrackUpdate.trackUnMuted:
        break;
      case HMSTrackUpdate.trackDescriptionChanged:
        break;
      case HMSTrackUpdate.trackDegraded:
        break;
      case HMSTrackUpdate.trackRestored:
        break;
      case HMSTrackUpdate.defaultUpdate:
        break;
      default:
        print("Some default update or untouched case");
    }
  }

  Future<bool> endRoom(bool lock) async {
    return await meetingController.endRoom(lock);
  }

  void leaveMeeting() {
    meetingController.leaveMeeting();
  }

  void removePeerFromRoom(String peerId) {
    meetingController.removePeer(peerId);
  }

  void muteAll() {
    meetingController.muteAll();
  }

  void unMuteAll() {
    meetingController.unMuteAll();
  }
}
