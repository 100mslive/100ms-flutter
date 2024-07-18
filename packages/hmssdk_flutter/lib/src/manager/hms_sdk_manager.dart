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
      bool isPrebuilt,

      ///[Android Only]
      ///If set to true, the preview will be halted until the permission is granted.
      ///If set to false, the application will need to handle permissions.
      bool haltPreviewJoinForPermissionRequest) async {
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
            dartSDKVersion.isNotEmpty ? dartSDKVersion[0] : "null",
        "hmssdk_version": versions['flutter'],
        "is_prebuilt": isPrebuilt,
        "halt_preview_join_for_permission_request":
            haltPreviewJoinForPermissionRequest
      };
      return await PlatformService.invokeMethod(PlatformMethod.build,
          arguments: arguments);
    }
  }
}
