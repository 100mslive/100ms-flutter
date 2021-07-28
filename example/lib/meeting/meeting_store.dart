import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/enum/hms_track_update.dart';
import 'package:hmssdk_flutter/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/meeting/meeting.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';

import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase with Store {
  @observable
  bool isSpeakerOn = true;

  @observable
  HMSException? exception;


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
  Future<void> startMeeting() async {
    controller = await meetingController.startMeeting();
    isMeetingStarted = true;
    listenToController();
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
        HMSException exception = HMSException.fromMap(event.data['error']);
        print(exception.toString() + "event");
        updateException(exception);
      } else if (event.method == PlatformMethod.onMessage) {
        //print("onMessageFlutter"+event.data['message']['sender'].toString());
        HMSMessage message=HMSMessage.fromMap(event.data['message']);
        addMessage(message);
      }
    });
  }

  void updateException(HMSException hmsException) {
    this.exception = hmsException;
  }

  void addMessage(HMSMessage message){
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