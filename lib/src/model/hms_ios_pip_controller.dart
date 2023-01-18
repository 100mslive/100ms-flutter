import 'package:flutter/material.dart';
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
  ///**aspectRatio** - Ratio for PIP window. For example: [16,9], [9,16] ,[1,1]
  ///
  ///`Note: Use [changeTrackPIP] function to change track in PIP window. Default track is local peer video track if available.`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> setupPIP(bool? autoEnterPip,
      {List<int>? aspectRatio,
      ScaleType scaleType = ScaleType.SCALE_ASPECT_FILL,
      Color backgroundColor = Colors.black}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.setupPIP, arguments: {
      "auto_enter_pip": autoEnterPip ?? true,
      "ratio": aspectRatio ?? [16, 9],
      "scale_type": scaleType.value,
      "color": [
        backgroundColor.red,
        backgroundColor.green,
        backgroundColor.blue
      ]
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
  ///**aspectRatio** - Ratio for PIP window. For example: [16,9], [9,16] ,[1,1]
  ///
  /// `Note: [setupPIP] is required to call before calling [changeTrackPIP].`
  ///
  /// Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> changeTrackPIP(
      {required HMSVideoTrack track,
      required List<int> aspectRatio,
      required ScaleType scaleType}) async {
    if (_isPIPSetupDone && aspectRatio.length == 2) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.changeTrackPIP,
          arguments: {
            "track_id": track.trackId,
            "ratio": aspectRatio,
            "scale_type": scaleType.value
          });
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      }
    } else if (!_isPIPSetupDone) {
      return HMSException(
          message:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          description:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          action: "",
          isTerminal: false);
    } else if (aspectRatio.length != 2) {
      return HMSException(
          message: "ratio must be passed properly",
          description:
              "ratio must be passed properly. For example: [16,9], [9,16] ,[1,1]",
          action: "",
          isTerminal: false);
    }
    return null;
  }

  ///[changeTrackPIP] is used to change the track of PIP window.
  ///
  ///**Parameters**:
  ///
  ///**text** - [text] need to be passed for show text in PIP window.
  ///
  ///**aspectRatio** - Ratio for PIP window. For example: [16,9], [9,16] ,[1,1]
  ///
  /// `Note: [setupPIP] is required to call before calling [changeTextPIP].`
  ///
  /// Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> changeTextPIP(
      {required String text, required List<int> aspectRatio}) async {
    if (_isPIPSetupDone && aspectRatio.length == 2) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.changeTextPIP,
          arguments: {
            "text": text,
            "ratio": aspectRatio,
          });
      if (result != null) {
        return HMSException.fromMap(result["error"]);
      }
    } else if (!_isPIPSetupDone) {
      return HMSException(
          message:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          description:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          action: "",
          isTerminal: false);
    } else if (aspectRatio.length != 2) {
      return HMSException(
          message: "ratio must be passed properly",
          description:
              "ratio must be passed properly. For example: [16,9], [9,16] ,[1,1]",
          action: "",
          isTerminal: false);
    }
    return null;
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
