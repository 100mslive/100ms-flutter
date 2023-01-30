import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

/// [HMSIOSPIPController] is used to setup and start the PIP in iOS. To know more visit [here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode).
class HMSIOSPIPController {
  static bool _isPIPSetupDone = false;

  ///setup PIP is used to setup PIP in iOS devices.
  ///**parameters**:
  ///
  /// **autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized. Default value is `true`
  ///
  /// **aspectRatio** - Ratio for PIP window. List of int indicating ratio for PIP window as [width,height]. For example: [16, 9], [9, 16] ,[1, 1]. Default value is `[16, 9]`
  ///
  /// **scaleType** - To set the video scaling. scaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]. Default value is `ScaleType.SCALE_ASPECT_FILL`
  ///
  /// **backgroundColor** - To set the background colour when video is off that colour will be visible in background of PIP window. Default value is `Colors.black`.
  ///
  ///`Note: Use [changeVideoTrack] function to change track in PIP window. Default track is local peer video track if available.`
  ///
  ///setup PIP function can be called like - onJoin, or on click of a button, or when a Screenshare starts, etc
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> setup(
      {bool? autoEnterPip,
      List<int>? aspectRatio,
      ScaleType scaleType = ScaleType.SCALE_ASPECT_FILL,
      Color backgroundColor = Colors.black}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.setupPIP, arguments: {
      "auto_enter_pip": autoEnterPip ?? true,
      "ratio": (aspectRatio != null && aspectRatio.length == 2)
          ? aspectRatio
          : [16, 9],
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

  /// [start] is used to start PIP manually.
  ///
  /// `Note: [setupPIP] is required to call before calling [startPIP].`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static void start() {
    if (_isPIPSetupDone) {
      PlatformService.invokeMethod(PlatformMethod.startPIP);
    }
  }

  /// [stop] is used to stop PIP manually.
  ///
  /// `Note: [setupPIP] is required to call before calling [stopPIP].`
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static void stop() {
    if (_isPIPSetupDone) {
      PlatformService.invokeMethod(PlatformMethod.stopPIP);
    }
  }

  ///[changeVideoTrack] is used to change the track of PIP window.
  ///
  ///**Parameters**:
  ///
  /// **track** - [HMSVideoTrack] need to be passed for changing PIP window track.
  ///
  /// **aspectRatio** - Ratio for PIP window.List of int indicating ratio for PIP window as [width,height]. For example: [16, 9], [9, 16] ,[1, 1]. Default value is `[16, 9]`.
  ///
  /// **alternativeText** - Alternative text is a textual substitute if HMSVideoTrack is muted.This is the text which you wish to display when video for peer is OFF while in PIP
  ///
  /// **scaleType** - To set the video scaling. scaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]. Default value is `ScaleType.SCALE_ASPECT_FILL`
  ///
  /// **backgroundColor** - To set the background colour when video is off that colour will be visible in background of PIP window. Default value is `Colors.black`.
  ///
  /// `Note: [setupPIP] is required to call before calling [changeTrackPIP].`
  ///
  /// Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> changeVideoTrack(
      {required HMSVideoTrack track,
      List<int>? aspectRatio,
      required String alternativeText,
      ScaleType scaleType = ScaleType.SCALE_ASPECT_FILL,
      Color backgroundColor = Colors.black}) async {
    if (_isPIPSetupDone) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.changeTrackPIP,
          arguments: {
            "track_id": track.trackId,
            "ratio": (aspectRatio != null && aspectRatio.length == 2)
                ? aspectRatio
                : [16, 9],
            "alternative_text": alternativeText,
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
    } else if (!_isPIPSetupDone) {
      return HMSException(
          message:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          description:
              "[setupPIP] is required to call before calling [changeTrackPIP]",
          action: "",
          isTerminal: false);
    }
    return null;
  }

  ///[changeText] is used to change the Text of PIP window.
  ///
  ///It will remove the video track & only show the Text label
  ///
  ///**Parameters**:
  ///
  /// **text** - Text you want to show in PIP window. It will replace HMSVideoTrack if it playing in PIP window.
  ///
  /// **aspectRatio** - Ratio for PIP window.List of int indicating ratio for PIP window as [width,height]. For example: [16, 9], [9, 16] ,[1, 1]. Default value is `[16, 9]`.
  ///
  /// **scaleType** - To set the video scaling. scaleType can be one of the following: [SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED]. Default value is `ScaleType.SCALE_ASPECT_FILL`
  ///
  /// **backgroundColor** - To set the background colour when video is off that colour will be visible in background of PIP window. Default value is `Colors.black`.
  ///
  /// `Note: [setupPIP] is required to call before calling [changeTextPIP].`
  ///
  /// Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<HMSException?> changeText(
      {required String text,
      List<int>? aspectRatio,
      Color backgroundColor = Colors.black}) async {
    if (_isPIPSetupDone) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.changeTextPIP,
          arguments: {
            "text": text,
            "ratio": (aspectRatio != null && aspectRatio.length == 2)
                ? aspectRatio
                : [16, 9],
            "color": [
              backgroundColor.red,
              backgroundColor.green,
              backgroundColor.blue
            ]
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
    }
    return null;
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> isActive() async {
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
  static Future<bool> isAvailable() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
    return result ?? false;
  }

  ///Method to destroy PIP View.
  ///
  ///This method can be call at time of changing role to hls-viewer role.
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  static Future<bool> destroy() async {
    if (_isPIPSetupDone) {
      final bool? result =
          await PlatformService.invokeMethod(PlatformMethod.destroyPIP);
      if (result ?? false) {
        _isPIPSetupDone = false;
      }
      return result ?? false;
    }
    return true;
  }
}
