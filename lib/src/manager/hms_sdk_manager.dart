//Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:flutter/services.dart' show rootBundle;
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

///100ms HmsSdkManager
class HmsSdkManager {
  Future<bool> createInstance(
      HMSTrackSetting? hmsTrackSetting,
      HMSIOSScreenshareConfig? hmsiosScreenshareConfig,
      HMSLogSettings? hmsLogSettings) async {
    bool isCreated = await createHMSSdk(
        hmsTrackSetting, hmsiosScreenshareConfig, hmsLogSettings);
    return isCreated;
  }

  Future<bool> createHMSSdk(
      HMSTrackSetting? hmsTrackSetting,
      HMSIOSScreenshareConfig? hmsiosScreenshareConfig,
      HMSLogSettings? hmsLogSettings) async {
    final String sdkVersions = await rootBundle
        .loadString('packages/hmssdk_flutter/lib/assets/sdk-versions.json');
    var versions = json.decode(sdkVersions);
    if (versions['flutter'] == null) {
      throw FormatException("flutter version not found");
    } else {
      List<String> dartSDKVersion = Platform.version.split(" ");
      return await PlatformService.invokeMethod(PlatformMethod.build,
          arguments: {
            "hms_track_setting": hmsTrackSetting?.toMap(),
            "app_group": hmsiosScreenshareConfig?.appGroup,
            "preferred_extension": hmsiosScreenshareConfig?.preferredExtension,
            "hms_log_settings": hmsLogSettings?.toMap(),
            "dart_sdk_version":
                dartSDKVersion.length > 0 ? dartSDKVersion[0] : "null",
            "hmssdk_version": versions['flutter']
          });
    }
  }
}
