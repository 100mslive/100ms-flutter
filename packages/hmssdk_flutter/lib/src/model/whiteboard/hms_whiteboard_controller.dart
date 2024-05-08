import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSWhiteboardController {
  static Future<HMSException?> start(
      {required String title}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startWhiteboard,
        arguments: {"title": title});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<HMSException?> stop() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopWhiteboard);

      if (result != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
  }

  static void addHMSWhiteboardUpdateListener(
      {required HMSWhiteboardUpdateListener listener}) {
    PlatformService.addWhiteboardUpdateListener(listener);
  }

  static void removeHMSWhiteboardUpdateListener() {
    PlatformService.removeWhiteboardUpdateListener();
  }
}
