import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSPIPiOSController {
  Future<HMSException?> setupPIP(bool? autoEnterPip,
      {double? width, double? height}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.setupPIP,
        arguments: {
          "auto_enter_pip": autoEnterPip ?? false,
          "width": width,
          "height": height
        });
    if (result != null) {
      return HMSException.fromMap(result["error"]);
    }
    return null;
  }

  void startPIP() {
    PlatformService.invokeMethod(PlatformMethod.startPIP);
  }

  void stopPIP() {
    PlatformService.invokeMethod(PlatformMethod.stopPIP);
  }

  void changeTrackPIP(
      {required HMSVideoTrack track, double? width, double? height}) {
    PlatformService.invokeMethod(PlatformMethod.changeTrackPIP, arguments: {
      "track_id": track.trackId,
      "width": width,
      "height": height
    });
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  Future<bool> isPipActive() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipActive);
    return result ?? false;
  }

  ///Method to check whether pip mode is available for the current device
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  Future<bool> isPipAvailable() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
    return result ?? false;
  }
}
