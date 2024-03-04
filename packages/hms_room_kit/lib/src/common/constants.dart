//Class contains the constants used throughout the application
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// This class contains the constants used throughout the application
class Constant {
  /// [Constant.defaultMeetingLink] is the default meeting link that will be used
  static String defaultMeetingLink =
      "https://public.app.100ms.live/meeting/xvm-wxwo-gbl";

  /// [Constant.roomCode] is the meeting code that will be used
  static String? roomCode = "";

  ///[Constant.authToken] is auth token to join the room
  static String? authToken = "";

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

  ///[Constant.tokenEndPoint] is the token end point for the QA environment
  static String? tokenEndPoint;

  ///[Constant.initEndPoint] is the init end point for the QA environment
  static String? initEndPoint;

  ///[Constant.layoutAPIEndPoint] is the layout api end point for the QA environment
  static String? layoutAPIEndPoint;

  ///[Constant.tokenEndPointKey] is the key for the token end point
  static String tokenEndPointKey = "tokenEndPoint";

  ///[Constant.initEndPointKey] is the key for the init end point
  static String initEndPointKey = "initEndPoint";

  ///[Constant.layoutAPIEndPointKey] is the key for the layout api end point
  static String layoutAPIEndPointKey = "layoutAPIEndPoint";

  ///[Constant.onLeave] is the function that you wish to execute while leaving the room
  static Function? onLeave;
}
