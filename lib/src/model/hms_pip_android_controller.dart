import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSPIPAndroidController {
  ///Method to activate pipMode in the application
  ///
  ///**Parameters**:
  ///
  ///**aspectRatio** - Ratio for PIP window
  ///
  ///**autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized.
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  ///
  ///`Note: Minimum version required to support PiP is Android 8.0 (API level 26)`
  Future<bool> enterPipMode(
      {List<int>? aspectRatio, bool? autoEnterPip}) async {
    final bool? result = await PlatformService.invokeMethod(
        PlatformMethod.enterPipMode,
        arguments: {
          "aspect_ratio": aspectRatio ?? [16, 9],
          "auto_enter_pip": autoEnterPip ?? false
        });
    return result ?? false;
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
