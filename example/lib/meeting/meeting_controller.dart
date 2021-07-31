import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class MeetingController {
  final String roomId;
  final String user;
  final MeetingFlow flow;
  HMSSDKInteractor? _hmsSdkInteractor;

  MeetingController(
      {required this.roomId, required this.user, required this.flow});

  Future<void> joinMeeting() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig hmsConfig = HMSConfig(
        userId: Uuid().v1(),
        roomId: roomId,
        authToken: token,
        // endPoint: Constant.getTokenURL,
        userName: user);
    _hmsSdkInteractor = HMSSDKInteractor(config: hmsConfig);
    await _hmsSdkInteractor!.setup();
  }

  void leaveMeeting() {
    _hmsSdkInteractor?.leaveMeeting();
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await _hmsSdkInteractor?.switchAudio(isOn: isOn);
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await _hmsSdkInteractor?.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await _hmsSdkInteractor?.switchCamera();
  }

  Future<void> sendMessage(String message) async {
    return await _hmsSdkInteractor?.sendMessage(message);
  }
  
    void addMeetingListener(HMSUpdateListener listener) {
     _hmsSdkInteractor?.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
      _hmsSdkInteractor?.removeMeetingListener(listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
      _hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
      _hmsSdkInteractor?.removePreviewListener(listener);
  }
}
