import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/exceptions/hms_exception.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSCameraControls] contains the common camera functions for android and iOS
class HMSCameraControls {
  ///[captureImageAtMaxSupportedResolution] is used to capture images at the original camera
  ///resolution.
  ///[withFlash] parameter is only supported for iOS
  static Future<dynamic> captureImageAtMaxSupportedResolution(
      {bool? withFlash = false}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.captureImageAtMaxSupportedResolution,
        arguments: {"with_flash": withFlash});
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }
}
