//Class contains the constants used throughout the application
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// This class contains the constants used throughout the application
class Constant {
  /// [Constant.defaultMeetingLink] is the default meeting link that will be used
  static String defaultMeetingLink =
      "https://public.app.100ms.live/meeting/xvm-wxwo-gbl";

  /// [Constant.meetingUrl] is the meeting link that will be used
  static String meetingUrl = defaultMeetingLink;

  /// [Constant.meetingCode] is the meeting code that will be used
  static String meetingCode = "";

  /// [Constant.streamingUrl] is the streaming url that will be used
  static String streamingUrl = "";

  /// [Constant.webRTCLogLevel] is the log level for the WebRTC SDK
  static HMSLogLevel webRTCLogLevel = HMSLogLevel.ERROR;

  /// [Constant.sdkLogLevel] is the log level for the HMS SDK
  static HMSLogLevel sdkLogLevel = HMSLogLevel.VERBOSE;

  /// [Constant.debugMode] is the debug mode for the application
  static bool debugMode = false;

  /// [Constant.options] is the prebuilt options for the application
  /// This is saved for later usages in the application
  static HMSPrebuiltOptions? prebuiltOptions;
}
