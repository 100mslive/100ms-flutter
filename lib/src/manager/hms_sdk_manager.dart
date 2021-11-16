import 'package:hmssdk_flutter/src/service/platform_service.dart';

import '../../hmssdk_flutter.dart';

class HmsSdkManager {
  Future<bool> createInstance(HMSTrackSetting? hmsTrackSetting) async {
    bool isCreated = await createHMSSdk(hmsTrackSetting);
    return isCreated;
  }

  Future<bool> createHMSSdk(HMSTrackSetting? hmsTrackSetting) async {
    return await PlatformService.invokeMethod(PlatformMethod.createSdk,
        arguments: {"hms_track_setting": hmsTrackSetting?.toMap()});
  }
}
