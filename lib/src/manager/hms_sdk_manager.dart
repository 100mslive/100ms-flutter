// Project imports:
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

///100ms HmsSdkManager
class HmsSdkManager {
  Future<bool> createInstance(HMSTrackSetting? hmsTrackSetting,
      String? appGroup, String? preferredExtension) async {
    bool isCreated =
        await createHMSSdk(hmsTrackSetting, appGroup, preferredExtension);
    return isCreated;
  }

  Future<bool> createHMSSdk(HMSTrackSetting? hmsTrackSetting, String? appGroup,
      String? preferredExtension) async {
    return await PlatformService.invokeMethod(PlatformMethod.build, arguments: {
      "hms_track_setting": hmsTrackSetting?.toMap(),
      "app_group": appGroup,
      "preferred_extension": preferredExtension
    });
  }
}
