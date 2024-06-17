import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSTranscriptionController {
  static void addListener({required HMSTranscriptListener listener}) {
    PlatformService.addTranscriptListener(listener);
    PlatformService.invokeMethod(PlatformMethod.addTranscriptListener);
  }

  static void removeListener() {
    PlatformService.removeTranscriptListener();
    PlatformService.invokeMethod(PlatformMethod.removeTranscriptListener);
  }

  static Future<HMSException?> startTranscription(
      {HMSTranscriptionMode mode = HMSTranscriptionMode.caption}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startRealTimeTranscription,
        arguments: {'mode': mode.name});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<HMSException?> stopTranscription(
      {HMSTranscriptionMode mode = HMSTranscriptionMode.caption}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.stopRealTimeTranscription,
        arguments: {'mode': mode.name});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }
}
