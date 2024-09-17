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
///[enableNoiseCancellation] - To enable noise cancellation in prebuilt
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

  ///To enable noise cancellation in prebuilt.
  ///Default value is false
  final bool enableNoiseCancellation;

  ///To enable automatic gain control in prebuilt.
  ///Default value is false
  final bool isAutomaticGainControlEnabled;

  ///To enable noise suppression in prebuilt.
  ///Default value is false
  final bool isNoiseSuppressionEnabled;

  ///[HMSPrebuiltOptions] is a class that is used to pass the options to the prebuilt
  HMSPrebuiltOptions(
      {this.userName,
      this.userId,
      this.endPoints,
      this.debugInfo = false,
      this.iOSScreenshareConfig,
      this.enableNoiseCancellation = false,
      this.isAutomaticGainControlEnabled = false,
      this.isNoiseSuppressionEnabled = false});
}
