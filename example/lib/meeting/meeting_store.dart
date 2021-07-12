import 'package:hmssdk_flutter/common/platform_methods.dart';
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
        peers.add(HMSPeer.fromMap(event.data));
      }
    });
  }
}
