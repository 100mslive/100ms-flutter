import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// [HMSAndroidPIPController] is used to setup and start the PIP in android. To know more visit [here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode).
class HMSAndroidPIPController {
  ///setup PIP is used to setup PIP in Android devices.
  ///**parameters**:
  ///
  /// **autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized. Default value is `true`
  ///
  /// **aspectRatio** - Ratio for PIP window. List of int indicating ratio for PIP window as [width,height]. For example: [16, 9], [9, 16] ,[1, 1]. Default value is `[16, 9]`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> setup({
    bool? autoEnterPip,
    List<int>? aspectRatio,
  }) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.setupPIP, arguments: {
      "auto_enter_pip": autoEnterPip ?? true,
      "ratio": (aspectRatio != null && aspectRatio.length == 2)
          ? aspectRatio
          : [16, 9],
    });
    if (result != null) {
      return HMSException.fromMap(result["error"]);
    }
    return null;
  }

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
    final bool? result = await PlatformService.invokeMethod(
        PlatformMethod.enterPipMode,
        arguments: {
          "aspect_ratio": aspectRatio ?? [16, 9],
          "auto_enter_pip": autoEnterPip ?? true
        });
    return result ?? false;
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isActive() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipActive);
    return result ?? false;
  }

  ///Method to check whether pip mode is available for the current device
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isAvailable() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
    return result ?? false;
  }

  ///Method to destroy PIP View.
  ///
  ///This method can be call at time of changing role to hls-viewer role or while closing the application
  ///to disable entering in PIP mode.
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> destroy() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.destroyPIP);
    return result ?? false;
  }
}
