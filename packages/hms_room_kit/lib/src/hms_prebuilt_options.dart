import 'package:hms_room_kit/hms_room_kit.dart';

/// [HMSPrebuiltOptions] is a class that contains the options for the prebuilt
/// - [userName] is the name of the user
/// - [userId] is the id of the user
/// - [endPoints] is the token and init endpoints
/// - [debugInfo] is to enable the debug mode for the prebuilt
/// - [iOSScreenshareConfig] is the screen share config, to enable screen share for iOS
/// If you wish to enable screen share for iOS, you need to pass this config
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
