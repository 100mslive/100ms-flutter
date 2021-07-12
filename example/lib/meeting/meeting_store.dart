import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase with Store {
  @observable
  bool isSpeakerOn = true;

  @observable
  bool isMeetingStarted = false;
  @observable
  bool isVideoOn = false;
  @observable
  bool isMicOn = false;

  late MeetingController meetingController;

  Stream<PlatformMethodResponse>? controller;

  @observable
  List<HMSPeer> peers = [];

  @action
  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
  }

  @action
  void toggleVideo() {
    isVideoOn = !isVideoOn;
  }

  @action
  void toggleAudio() {
    isMicOn = !isMicOn;
  }

  @action
  Future<void> startMeeting() async {
    controller = await meetingController.startMeeting();
    isMeetingStarted = true;
    listenToController();
  }

  void listenToController() {
    controller?.listen((event) {
      if (event.method == PlatformMethod.onPeerUpdate) {
        HMSPeer peer = HMSPeer.fromMap(event.data);
        peerOperation(peer);
      }
    });
  }

  @action
  void peerOperation(HMSPeer peer) {
    switch (peer.update) {
      case HMSPeerUpdate.peerJoined:
        peers.add(peer);
        break;

      case HMSPeerUpdate.peerLeft:
        peers.remove(peer);
        break;
      case HMSPeerUpdate.peerKnocked:
        peers.remove(peer);
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
}
