//Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:flutter/services.dart' show rootBundle;
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

///100ms HmsSdkManager
class HmsSdkManager {
  Future<bool> createHMSSdk(
      HMSTrackSetting? hmsTrackSetting,
      HMSIOSScreenshareConfig? iOSScreenshareConfig,
      String? appGroup,
      String? preferredExtension,
      HMSLogSettings? hmsLogSettings,
      bool isPrebuilt) async {
    final String sdkVersions = await rootBundle
        .loadString('packages/hmssdk_flutter/lib/assets/sdk-versions.json');
    var versions = json.decode(sdkVersions);
    if (versions['flutter'] == null) {
      throw FormatException("flutter version not found");
    } else {
      List<String> dartSDKVersion = Platform.version.split(" ");
      Map<String, dynamic> arguments = {
        "hms_track_setting": hmsTrackSetting?.toMap(),
        "app_group": appGroup,
        "preferred_extension": preferredExtension,
        "ios_screenshare_config": iOSScreenshareConfig?.toMap(),
        "hms_log_settings": hmsLogSettings?.toMap(),
        "dart_sdk_version":
            dartSDKVersion.length > 0 ? dartSDKVersion[0] : "null",
        "hmssdk_version": versions['flutter'],
        "is_prebuilt": isPrebuilt
      };
      return await PlatformService.invokeMethod(PlatformMethod.build,
          arguments: arguments);
    }
  }
}
