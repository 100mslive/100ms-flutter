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

  Stream? controller;

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
  }
}
