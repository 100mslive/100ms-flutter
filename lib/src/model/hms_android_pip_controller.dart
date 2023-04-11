import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// [HMSAndroidPIPController] is used to setup and start the PIP in android. To know more visit [here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode).
class HMSAndroidPIPController {
  ///Method to activate pipMode in the application
  ///
  ///**Parameters**:
  ///
  ///**aspectRatio** - Ratio for PIP window, List of int indicating ratio for PIP window as [width,height]
  ///
  ///**autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized.
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  ///
  ///`Note: Minimum version required to support PiP is Android 8.0 (API level 26)`
  static Future<bool> start(
      {List<int>? aspectRatio, bool? autoEnterPip}) async {
    try {
      final bool? result = await PlatformService.invokeMethod(
          PlatformMethod.enterPipMode,
          arguments: {
            "aspect_ratio": aspectRatio ?? [16, 9],
            "auto_enter_pip": autoEnterPip ?? true
          });
      return result ?? false;
    } catch (e) {
      PlatformService.notifyLogsUpdateListeners(
          HMSLogsUpdateListenerMethod.onLogsUpdate, [
        "HMSException occured in HMSAndroidPIPController start exception: $e"
      ]);
      return false;
    }
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isActive() async {
    try {
      final bool? result =
          await PlatformService.invokeMethod(PlatformMethod.isPipActive);
      return result ?? false;
    } catch (e) {
      PlatformService.notifyLogsUpdateListeners(
          HMSLogsUpdateListenerMethod.onLogsUpdate, [
        "HMSException occured in HMSAndroidPIPController isActive exception: $e"
      ]);
      return false;
    }
  }

  ///Method to check whether pip mode is available for the current device
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isAvailable() async {
    try {
      final bool? result =
          await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
      return result ?? false;
    } catch (e) {
      PlatformService.notifyLogsUpdateListeners(
          HMSLogsUpdateListenerMethod.onLogsUpdate, [
        "HMSException occured in HMSAndroidPIPController isAvailable exception: $e"
      ]);
      return false;
    }
  }
}
