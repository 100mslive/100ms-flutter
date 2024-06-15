import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_transcription_mode.dart';
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
      {required HMSTranscriptionMode mode}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startRealTimeTranscription,
        arguments: {'mode': mode.name});

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }

  static Future<HMSException?> stopTranscription() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.stopRealTimeTranscription);

    if (result != null) {
      return HMSException.fromMap(result["error"]);
    } else {
      return null;
    }
  }
}
