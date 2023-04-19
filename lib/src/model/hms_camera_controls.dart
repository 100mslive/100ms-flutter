import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSCameraControls] contains the common camera functions for android and iOS
class HMSCameraControls {
  ///[captureImageAtMaxSupportedResolution] is used to capture images at the original camera
  ///resolution.
  ///[withFlash] parameter turns flash ON if set to TRUE. Default value is FALSE
  ///
  ///Note: [withFlash] only works if current facing camera supports flash. If it doesn't support flash
  ///      then image will be captured without flash even if [withFlash] is set as TRUE
  ///      To avoid this consider checking the flash capabilities using [isFlashSupported] method
  ///      before calling [captureImageAtMaxSupportedResolution] method
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
  static Future<dynamic> isFlashSupported() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.isFlashSupported);
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///[enableFlash] is used to turn ON the flashlight.
  ///This works only if the current facing camera supports flash capabilities
  ///which can be checked using [isFlashSupported] method
  ///Although this method internally checks whether the current facing camera supports
  ///flash or not. If not it returns an [HMSException] object
  static Future<dynamic> enableFlash() async {
    var result = await PlatformService.invokeMethod(PlatformMethod.enableFlash);
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///[disableFlash] is used to turn OFF the flashlight.
  ///This works only if the current facing camera supports flash capabilities
  ///which can be checked using [isFlashSupported] method
  ///Although this method internally checks whether the current facing camera supports
  ///flash or not. If not it returns an [HMSException] object
  static Future<dynamic> disableFlash() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.disableFlash);
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }
}
