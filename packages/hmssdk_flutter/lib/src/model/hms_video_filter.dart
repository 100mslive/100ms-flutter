///Package imports
import 'package:flutter/foundation.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSVideoFilter] is used to apply video effects like virtual background and blur
///This is an internal library class and should not be used by the user
///To use the video filters, use the [HMSVideoPlugin] package
abstract class HMSVideoFilter {
  ///[enable] enables virtual background with the given image
  ///
  ///**parameters
  ///
  ///**image** - is the image to be used as virtual background
  ///
  ///Refer [enable] Docs [here](Add link)
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

  ///[changeVirtualBackground] changes the virtual background with the given image
  ///
  ///**parameters**
  ///
  ///**image** - is the new image to be used as virtual background
  ///
  ///Note: This method can be used only if virtual background is already enabled
  ///Refer [changeVirtualBackground] Docs [here](Add link)
  static Future<void> changeVirtualBackground(
      {required Uint8List? image}) async {
    PlatformService.invokeMethod(PlatformMethod.changeVirtualBackground,
        arguments: {"image": image});
    return null;
  }

  ///[isSupported] returns whether virtual background is supported or not
  ///
  ///Refer [isSupported] Docs [here](Add link)
  static Future<bool> isSupported() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.isVirtualBackgroundSupported);
    if (result["success"]) {
      return result["data"];
    } else {
      return false;
    }
  }

  ///[disable] disables virtual background
  ///
  ///Refer [disable] Docs [here](Add link)
  static Future<HMSException?> disable() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.disableVirtualBackground);

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  ///[enableBlur] enables blur with the given blur radius
  ///
  ///**parameters**
  ///
  ///**blurRadius** - is the radius of the blur effect
  ///
  ///Refer [enableBlur] Docs [here](Add link)
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

  ///[disableBlur] disables blur
  ///
  ///Refer [disableBlur] Docs [here](Add link)
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
