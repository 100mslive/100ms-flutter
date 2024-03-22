import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSNoiseCancellationController {

  static Future<void> enable() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.enableNoiseCancellation);
  }

  static Future<void> disable() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.disableNoiseCancellation);
  }

  static Future<bool> isEnabled() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.isNoiseCancellationEnabled);
  }

  static Future<bool> isAvailable() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.isNoiseCancellationAvailable);
  }

}
