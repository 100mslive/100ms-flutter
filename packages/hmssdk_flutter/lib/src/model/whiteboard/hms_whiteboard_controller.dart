import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/whiteboard/hms_whiteboard_update_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSWhiteboardController {
  static Future<void> start(
      {required String title,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startWhiteboard,
        arguments: {"title": title});

    if (hmsActionResultListener != null) {
      if (result != null) {
        hmsActionResultListener.onException(
            hmsException: HMSException.fromMap(result["error"]),
            methodType: HMSActionResultListenerMethod.startWhiteboard);
      } else {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.startWhiteboard);
      }
    }
  }

  static Future<void> stop(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopWhiteboard);

    if (hmsActionResultListener != null) {
      if (result != null) {
        hmsActionResultListener.onException(
            hmsException: HMSException.fromMap(result["error"]),
            methodType: HMSActionResultListenerMethod.stopWhiteboard);
      } else {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.stopWhiteboard);
      }
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
