library;

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[HMSPrebuiltOptions] is a class that is used to pass the options to the prebuilt
///It takes following parameters:
///[userName] - The name of the user
///[userId] - The id of the user
///[endPoints] - The token and init endpoints
///[debugInfo] - To enable the debug mode for the prebuilt
///[iOSScreenshareConfig] - Screen share Config, to enable screen share for iOS
class HMSPrebuiltOptions {
  //The name of the user
  final String? userName;

  //The id of the user
  final String? userId;

  //The token and init endpoints
  final Map<String, String>? endPoints;

  //To enable the debug mode for the prebuilt
  final bool debugInfo;

  ///This provides the img url of the user
  final String? userImgUrl;

  ///This sets whether it's a video call or audio call
  final bool isVideoCall;

  //Screen share Config, to enable screen share for iOS
  //If you wish to enable screen share for iOS, you need to pass
  //this config
  final HMSIOSScreenshareConfig? iOSScreenshareConfig;

  ///[HMSPrebuiltOptions] is a class that is used to pass the options to the prebuilt
  HMSPrebuiltOptions(
      {this.userName,
      this.userId,
      this.endPoints,
      this.debugInfo = false,
      this.iOSScreenshareConfig,
      this.userImgUrl,
      this.isVideoCall = true});
}
