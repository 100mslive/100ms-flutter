import 'dart:io';

import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/enum/hms_room_update.dart';
import 'package:hmssdk_flutter/enum/hms_track_update.dart';
import 'package:hmssdk_flutter/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_role_change_request.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_speaker.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase with Store implements HMSUpdateListener {
  void onJoin({required HMSRoom room}) {
    print('on join');
  }

  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    print('on room update');
  }

  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (peer.isLocal) {
      localPeer = peer;
    } else
      peerOperation(peer, update);
  }

  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (peer.isLocal) {
      localPeer = peer;
    } else
      peerOperationWithTrack(peer, trackUpdate, track);
  }

  void onError({required HMSError error}) {
    print('on error');
  }

  void onMessage({required HMSMessage message}) {
    print('on message');
  }

  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    print('on role change request');
  }

  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    print('on update speaker');
  }

  void onReconnecting() {
    print('on reconnecting');
  }

  void onReconnected() {
    print('on reconnected');
  }

  @action
  void startListen() {
    PlatformService.addListener(this);
  }

  @observable
  bool isSpeakerOn = true;

  @observable
  HMSException? exception;
  @observable
  HMSError? error;

  @observable
  bool isMeetingStarted = false;
  @observable
  bool isVideoOn = true;
  @observable
  bool isMicOn = true;

  late MeetingController meetingController;

  Stream<PlatformMethodResponse>? controller;

  @observable
  List<HMSPeer> peers = ObservableList.of([]);

  @observable
  HMSPeer? localPeer;

  @observable
  List<HMSTrack> tracks = ObservableList.of([]);

  @observable
  List<HMSMessage> messages = ObservableList.of([]);

  @action
  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
  }

  @action
  Future<void> toggleVideo() async {
    await meetingController.switchVideo(isOn: isVideoOn);
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
  Future<void> joinMeeting() async {
    controller = await meetingController.joinMeeting();
    isMeetingStarted = true;
  }

  @action
  Future<void> sendMessage(String message) async {
    await meetingController.sendMessage(message);
  }

  @action
  void listenToController() {
    controller?.listen((event) {
      if (event.method == PlatformMethod.onPeerUpdate) {
        HMSPeer peer = HMSPeer.fromMap(event.data['peer']);
        HMSPeerUpdate update =
            HMSPeerUpdateValues.getHMSPeerUpdateFromName(event.data['update']);
        if (peer.isLocal) {
          localPeer = peer;
        } else
          peerOperation(peer, update);
      } else if (event.method == PlatformMethod.onTrackUpdate) {
        print('track update');
        HMSPeer peer = HMSPeer.fromMap(event.data['peer']);
        HMSTrackUpdate update = HMSTrackUpdateValues.getHMSTrackUpdateFromName(
            event.data['update']);
        HMSTrack track = HMSTrack.fromMap(event.data['track'], peer);

        if (peer.isLocal) {
          localPeer = peer;
        } else
          peerOperationWithTrack(peer, update, track);
      } else if (event.method == PlatformMethod.onError) {
        if (Platform.isIOS) {
          HMSError error = HMSError.fromMap(event.data['error']);

          updateError(error);
        } else {
          HMSException exception = HMSException.fromMap(event.data['error']);
          print(exception.toString() + "event");
          updateException(exception);
        }
      } else if (event.method == PlatformMethod.onMessage) {
        HMSMessage message = HMSMessage.fromMap(event.data['message']);
        addMessage(message);
      }
    });
  }

  @action
  void updateException(HMSException hmsException) {
    this.exception = hmsException;
  }

  @action
  void updateError(HMSError error) {
    this.error = error;
  }

  void addMessage(HMSMessage message) {
    this.messages.add(message);
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
        peers[peers.indexOf(peer)] = peer;
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
    switch (update) {
      case HMSTrackUpdate.trackAdded:
        addTrack(track);
        break;
      case HMSTrackUpdate.trackRemoved:
        removeTrackWithTrackId(track.trackId);
        break;
      case HMSTrackUpdate.trackMuted:
        print('Muted');
        break;
      case HMSTrackUpdate.trackUnMuted:
        print('UnMuted');
        break;
      case HMSTrackUpdate.trackDescriptionChanged:
        print('trackDescriptionChanged');
        break;
      case HMSTrackUpdate.trackDegraded:
        print('trackDegraded');
        break;
      case HMSTrackUpdate.trackRestored:
        print('trackRestored');
        break;
      case HMSTrackUpdate.defaultUpdate:
        print("Some default update or untouched case");
        break;
      default:
        print("Some default update or untouched case");
    }
  }
}

class Listener implements HMSUpdateListener {
  void onJoin({required HMSRoom room}) {
    print('on join');
  }

  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    print('on room update');
  }

  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    print('on peer update');
  }

  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    print('on track update');
  }

  void onError({required HMSError error}) {
    print('on error');
  }

  void onMessage({required HMSMessage message}) {
    print('on message');
  }

  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    print('on role change request');
  }

  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    print('on role speker');
  }

  void onReconnecting() {
    print('on reconnecting');
  }

  void onReconnected() {
    print('on reconnected');
  }
}
