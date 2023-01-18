import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// [HMSIOSPIPController] is used to setup and start the PIP in iOS. To know more visit [here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode).
class HMSIOSPIPController {
  static bool _isPIPSetupDone = false;

  ///setup PIP is used to setup PIP in iOS devices.
  ///**parameters**:
  ///
  ///**autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized.
  ///
  ///**aspectRatio** - Ratio for PIP window
  ///
  ///`Note: Use [changeTrackPIP] function to change track in PIP window. Default track is local peer video track if available.`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> setupPIP(bool? autoEnterPip,
      {List<int>? ratio}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.setupPIP, arguments: {
      "auto_enter_pip": autoEnterPip ?? true,
      "ratio": ratio ?? [16, 9]
    });
    if (result != null) {
      return HMSException.fromMap(result["error"]);
    }
    _isPIPSetupDone = true;
    return null;
  }

  /// [startPIP] is used to start PIP manually.
  ///
  /// `Note: [setupPIP] is required to call before calling [startPIP].`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static void startPIP() {
    if (_isPIPSetupDone) {
      PlatformService.invokeMethod(PlatformMethod.startPIP);
    }
  }

  /// [stopPIP] is used to stop PIP manually.
  ///
  /// `Note: [setupPIP] is required to call before calling [stopPIP].`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static void stopPIP() {
    if (_isPIPSetupDone) {
      PlatformService.invokeMethod(PlatformMethod.stopPIP);
    }
  }

  ///[changeTrackPIP] is used to change the track of PIP window.
  ///
  ///**Parameters**:
  ///
  ///**track** - [HMSVideoTrack] need to be passed for changing PIP window track.
  ///
  ///**aspectRatio** - Ratio for PIP window
  ///
  /// `Note: [setupPIP] is required to call before calling [changeTrackPIP].`
  ///
  /// Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static void changeTrackPIP(
      {required HMSVideoTrack track, required List<int> ratio}) {
    if (_isPIPSetupDone && ratio.length == 2) {
      PlatformService.invokeMethod(PlatformMethod.changeTrackPIP,
          arguments: {"track_id": track.trackId, "ratio": ratio});
    }
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isPipActive() async {
    if (_isPIPSetupDone) {
      final bool? result =
          await PlatformService.invokeMethod(PlatformMethod.isPipActive);
      return result ?? false;
    }
    return false;
  }

  ///Method to check whether pip mode is available for the current device
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isPipAvailable() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
    return result ?? false;
  }
}
