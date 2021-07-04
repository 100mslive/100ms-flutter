import 'package:hmssdk_flutter/meeting/meeting.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter_example/model/hms_message.dart';
import 'package:hmssdk_flutter_example/model/hms_sdk.dart';

class HMSSDKInteractor {
  late HMSConfig config;
  late HMSSdk _hmsSdk;
  late List<HMSMessage> messages;

  HMSSDKInteractor({required this.config});

  Future<void> setup() async {
    HMSMeeting().startMeeting(config: this.config);
  }
}
