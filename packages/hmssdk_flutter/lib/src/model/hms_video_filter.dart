import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSVideoFilter {
  
  static Future<void> enable({required String imagePath}) async{
      PlatformService.invokeMethod(PlatformMethod.enableVirtualBackground, 
      arguments: {"image_path": imagePath});
  }

  static Future<void> disable() async{
      PlatformService.invokeMethod(PlatformMethod.disableVirtualBackground);
  }

  static Future<void> enableBlur({required int blurRadius}) async{
    assert(blurRadius >= 0 && blurRadius <= 100, "blurRadius should be between 0 and 100, current value is $blurRadius");
    PlatformService.invokeMethod(PlatformMethod.enableBlurBackground,arguments: {"blur_radius":blurRadius});
  }

  static Future<void> disableBlur() async{
    PlatformService.invokeMethod(PlatformMethod.disableBlurBackground);
  }

}
