//Class contains the constants used throughout the application
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class Constant {
  static String defaultMeetingLink =
      "https://yogi.app.100ms.live/meeting/ssz-eqr-eaa";

  static String meetingUrl = defaultMeetingLink;
  static String meetingCode = "";
  static String streamingUrl = "";

  static HMSLogLevel webRTCLogLevel = HMSLogLevel.VERBOSE;
  static HMSLogLevel sdkLogLevel = HMSLogLevel.VERBOSE;
}
