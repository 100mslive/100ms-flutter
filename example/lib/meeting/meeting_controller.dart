import 'package:hmssdk_flutter/model/hms_config.dart';
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

  Future<Stream> startMeeting() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig hmsConfig = HMSConfig(
        userId: Uuid().v1(),
        roomId: roomId,
        authToken: token,
        // endPoint: Constant.getTokenURL,
        userName: 'Flutter user');
    _hmssdkInteractor = HMSSDKInteractor(config: hmsConfig);
    return _hmssdkInteractor!.setup();
  }

  void endMeeting() {
    _hmssdkInteractor?.leaveMeeting();
  }
}
