///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSNoiseCancellationController] class exposes methods to control noise cancellation for the user
/// Checkout the Noise Cancellations Docs here: https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/noise-cancellation
abstract class HMSNoiseCancellationController {
  ///[enable] enables noise cancellation
  static Future<void> enable() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.enableNoiseCancellation);
  }

  ///[disable] disables noise cancellation
  static Future<void> disable() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.disableNoiseCancellation);
  }

  ///[isEnabled] retuns whether noise cancellation is enabled or not
  static Future<bool> isEnabled() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.isNoiseCancellationEnabled);

    if (result["success"]) {
      return result["data"];
    } else {
      return false;
    }
  }

  ///[isAvailable] retuns whether noise cancellation is available in room or not
  static Future<bool> isAvailable() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.isNoiseCancellationAvailable);

    if (result["success"]) {
      return result["data"];
    } else {
      return false;
    }
  }
}
