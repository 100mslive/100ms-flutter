import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class MeetingController {
  final String roomId;
  final String user;
  final MeetingFlow flow;
  HMSSDKInteractor? _hmssdkInteractor;

  MeetingController(
      {required this.roomId, required this.user, required this.flow});

  Future<Stream<PlatformMethodResponse>> startMeeting() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig hmsConfig = HMSConfig(
        userId: Uuid().v1(),
        roomId: roomId,
        authToken: token,
        // endPoint: Constant.getTokenURL,
        userName: user);
    _hmssdkInteractor = HMSSDKInteractor(config: hmsConfig);
    return _hmssdkInteractor!.setup();
  }

  void leaveMeeting() {
    _hmssdkInteractor?.leaveMeeting();
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await _hmssdkInteractor?.switchAudio(isOn: isOn);
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await _hmssdkInteractor?.switchVideo(isOn: isOn);
  }

  Future<void> switchCamera() async {
    return await _hmssdkInteractor?.switchCamera();
  }

  Future<void> sendMessage(String message) async{
    return await _hmssdkInteractor?.sendMessage(message);
  }

}
