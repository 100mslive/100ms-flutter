import 'package:hmssdk_flutter/meeting/meeting.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';
import 'package:hmssdk_flutter_example/model/hms_message.dart';
import 'package:hmssdk_flutter_example/model/hms_sdk.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late HMSSdk _hmsSdk;
  late List<HMSMessage> messages;
  late HMSMeeting _meeting;

  HMSSDKInteractor({required this.config}) {
    _meeting = HMSMeeting();
  }

  Future<Stream<PlatformMethodResponse>> setup() async {
    await _meeting.startMeeting(config: this.config);
    return _meeting.startListening();
  }

  Future<void> leaveMeeting() async {
    return await _meeting.leaveMeeting();
  }
}
