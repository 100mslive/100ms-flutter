//Dart imports:
import 'dart:io';

// Project imports:
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

///100ms HmsSdkManager
class HmsSdkManager {
  Future<bool> createInstance(
      HMSTrackSetting? hmsTrackSetting,
      String? appGroup,
      String? preferredExtension,
      HMSLogSettings? hmsLogSettings) async {
    bool isCreated = await createHMSSdk(
        hmsTrackSetting, appGroup, preferredExtension, hmsLogSettings);
    return isCreated;
  }

  Future<bool> createHMSSdk(HMSTrackSetting? hmsTrackSetting, String? appGroup,
      String? preferredExtension, HMSLogSettings? hmsLogSettings) async {
    List<String> dartSDKVersion = Platform.version.split(" ");
    return await PlatformService.invokeMethod(PlatformMethod.build, arguments: {
      "hms_track_setting": hmsTrackSetting?.toMap(),
      "app_group": appGroup,
      "preferred_extension": preferredExtension,
      "hms_log_settings": hmsLogSettings?.toMap(),
      "dart_sdk_version":
          dartSDKVersion.length > 0 ? dartSDKVersion[0] : "null",
      "hmssdk_version": "0.7.8"
    });
  }
}
