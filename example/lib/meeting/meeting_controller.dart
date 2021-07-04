import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/model/hms_config.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';

class MeetingController {
  final String roomId;
  final String user;
  final MeetingFlow flow;

  MeetingController(
      {required this.roomId, required this.user, required this.flow});

  void startMeeting() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig hmsConfig = HMSConfig(
        userId: user,
        roomId: roomId,
        authToken: token,
        endpoint: Constant.getTokenURL);
  }
}
