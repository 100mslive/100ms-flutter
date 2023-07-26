import 'package:hms_room_kit/hms_room_kit.dart';

class HMSPrebuiltOptions {
  //The name of the user
  final String? userName;

  //The id of the user
  final String? userId;

  //The token and init endpoints
  final Map<String, String>? endPoints;

  //To enable the debug mode for the prebuilt
  final bool debugInfo;

  //Screen share Config, to enable screen share for iOS
  //If you wish to enable screen share for iOS, you need to pass
  //this config
  final HMSIOSScreenshareConfig? iOSScreenshareConfig;

  HMSPrebuiltOptions(
      {this.userName,
      this.userId,
      this.endPoints,
      this.debugInfo = false,
      this.iOSScreenshareConfig});
}
