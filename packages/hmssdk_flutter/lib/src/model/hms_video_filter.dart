///Package imports
import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSVideoFilter] is used to apply video effects like virtual background and blur
abstract class HMSVideoFilter {
  static Future<HMSException?> enable({required Uint8List? image}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.enableVirtualBackground,
        arguments: {"image": image});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<void> changeVirtualBackground(
      {required Uint8List? image}) async {
    PlatformService.invokeMethod(PlatformMethod.changeVirtualBackground,
        arguments: {"image": image});
    return null;
  }

  static Future<bool> isSupported() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.isVirtualBackgroundSupported);
    if (result["success"]) {
      return result["data"];
    } else {
      return false;
    }
  }

  static Future<HMSException?> disable() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disableVirtualBackground);

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<HMSException?> enableBlur({required int blurRadius}) async {
    assert(blurRadius >= 0 && blurRadius <= 100,
        "blurRadius should be between 0 and 100, current value is $blurRadius");
    var result = await PlatformService.invokeMethod(
        PlatformMethod.enableBlurBackground,
        arguments: {"blur_radius": blurRadius});
    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<HMSException?> disableBlur() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disableBlurBackground);
    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }
}
