import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/model/hms_message.dart';
import 'package:hmssdk_flutter_example/model/hms_sdk.dart';

class HMSSDKInteractor {
  final String user;
  final String room;
  final MeetingFlow meetingFlow;
  late HMSSdk _hmsSdk;
  late List<HMSMessage> messages;

  HMSSDKInteractor(
      {required this.user, required this.room, required this.meetingFlow});
}
