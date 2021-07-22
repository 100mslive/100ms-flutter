import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:hmssdk_flutter/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/enum/hms_track_update.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase with Store {
  @observable
  bool isSpeakerOn = true;
  @observable
  HMSException? message;
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
  Future<void> toggleAudio() async {
    await meetingController.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
  }

  @action
  void removePeer(HMSPeer peer){

    if(peers.contains(peer)){

      debugPrint("removePeer "+peers.remove(peer).toString());
    }

  }

  @action
  void addPeer(HMSPeer peer){

    if(!peers.contains(peer)){
      peers.add(peer);
      debugPrint("addPeer "+peer.toString());
    }

  }

  @action
  void onRoleUpdated(int index,HMSPeer peer){
    peers[index]=peer;
  }

  @action
  Future<void> startMeeting() async {
    controller = await meetingController.startMeeting();
    isMeetingStarted = true;
    listenToController();
  }

  @action
  void listenToController() {
    controller?.listen((event) {
      debugPrint(event.data.toString()+"listenToController");
      if (event.method == PlatformMethod.onPeerUpdate) {
        debugPrint(event.data.toString());
        HMSPeer peer = HMSPeer.fromMap(event.data['peer']);
        HMSPeerUpdate update =
        HMSPeerUpdateValues.getHMSPeerUpdateFromName(event.data['update']);
        peerOperation(peer,update);
      }
      else if(event.method == PlatformMethod.onError){
        HMSException exception= HMSException.fromMap(event.data);
        debugPrint(exception.toString());
        changeException(exception);
      }
      else if (event.method == PlatformMethod.onTrackUpdate) {
        HMSPeer? peer = event.data['peer']!=null?HMSPeer.fromMap(event.data['peer']):null;
        HMSTrackUpdate update = HMSTrackUpdateValues.getHMSTrackUpdateFromName(
            event.data['update']);
        peerOperationWithTrack(peer!, update);
      }
    });
  }

  @action
  void changeException(HMSException exception){
    message=exception;
  }

  @action
  Future<void> toggleCamera() async {
    await meetingController.switchCamera();
  }

  @action
  void peerOperation(HMSPeer peer,HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        addPeer(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        removePeer(peer);
        break;
      case HMSPeerUpdate.peerKnocked:
        removePeer(peer);
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
  void peerOperationWithTrack(HMSPeer peer, HMSTrackUpdate update) {
    switch (update) {
      case HMSTrackUpdate.trackAdded:
        addPeer(peer);
        break;
      case HMSTrackUpdate.trackRemoved:
        removePeer(peer);
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
