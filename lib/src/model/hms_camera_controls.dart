import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSCameraControls] contains the common camera functions for android and iOS
///
///Refer [camera controls guide here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/camera/camera-controls)
class HMSCameraControls {
  ///[captureImageAtMaxSupportedResolution] is used to capture images at the original camera
  ///resolution.
  ///
  /// **Parameters**:
  /// 
  /// **withFlash** - parameter turns flash ON if set to TRUE. Default value is FALSE
  ///
  ///Note: [withFlash] only works if current facing camera supports flash. If it doesn't support flash
  ///      then image will be captured without flash even if [withFlash] is set as TRUE
  ///      To avoid this consider checking the flash capabilities using [isFlashSupported] method
  ///      before calling [captureImageAtMaxSupportedResolution] method
  ///Refer: Read more about captureImageAtMaxSupportedResolution [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/camera/camera-controls#capture-at-the-highest-resolution-offered-by-the-camera)
  static Future<dynamic> captureImageAtMaxSupportedResolution(
      {bool withFlash = false}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.captureImageAtMaxSupportedResolution,
        arguments: {"with_flash": withFlash});
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///[isFlashSupported] is used to check whether the current facing camera supports
  /// flash or not.
  /// 
  ///Refer: Read more about isFlashSupported [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/camera/camera-controls#check-if-flash-feature-is-available)
  static Future<dynamic> isFlashSupported() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.isFlashSupported);
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///[toggleFlash] is used to toggle the flashlight.
  ///This works only if the current facing camera supports flash capabilities
  ///which can be checked using [isFlashSupported] method
  ///Although this method internally checks whether the current facing camera supports
  ///flash or not. If not it returns an [HMSException] object
  ///
  ///Note: [toggleFlash] only works if camera is turned ON
  ///      i.e. video is unmuted.
  ///Read more about toggleFlash [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/camera/camera-controls#toggle-flash)
  static Future<dynamic> toggleFlash() async {
    var result = await PlatformService.invokeMethod(PlatformMethod.toggleFlash);
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }
}
