// Project imports:
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

///100ms HmsSdkManager
class HmsSdkManager {
  Future<bool> createInstance(
      HMSTrackSetting? hmsTrackSetting, String? appGroup) async {
    bool isCreated = await createHMSSdk(hmsTrackSetting, appGroup);
    return isCreated;
  }

  Future<bool> createHMSSdk(
      HMSTrackSetting? hmsTrackSetting, String? appGroup) async {
    return await PlatformService.invokeMethod(PlatformMethod.build, arguments: {
      "hms_track_setting": hmsTrackSetting?.toMap(),
      "app_group": appGroup
    });
  }
}
