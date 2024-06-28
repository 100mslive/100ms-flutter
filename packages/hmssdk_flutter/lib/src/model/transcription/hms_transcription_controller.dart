//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

///[HMSTranscriptionController] is used to control transcription in the meeting.
abstract class HMSTranscriptionController {
  ///[addListener] is used to add a listener to get the transcription of the meeting.
  /// **parameters**:
  ///
  /// **listener** - [HMSTranscriptListener] instance to be attached
  /// Learn more about [addListener] [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/live-captions#step-1-add-hmstranscriptlistener-to-the-class-to-start-getting-transcriptions)
  static void addListener({required HMSTranscriptListener listener}) {
    PlatformService.addTranscriptListener(listener);
    PlatformService.invokeMethod(PlatformMethod.addTranscriptListener);
  }

  ///[removeListener] is used to remove the listener that was previously added.
  ///Learn more about [removeListener] [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/live-captions#step-3-to-stop-getting-transcriptions-remove-hmstranscriptlistener)
  static void removeListener() {
    PlatformService.removeTranscriptListener();
    PlatformService.invokeMethod(PlatformMethod.removeTranscriptListener);
  }

  ///[startTranscription] is used to start the transcription of the meeting.
  ///
  /// **parameters**:
  ///
  /// **mode** - [HMSTranscriptionMode] to start the transcription in the meeting. Default is [HMSTranscriptionMode.caption]
  ///
  /// Refer [startTranscription](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/live-captions#start-transcription)
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

  ///[stopTranscription] is used to stop the transcription of the meeting.
  ///
  /// **parameters**:
  ///
  /// **mode** - [HMSTranscriptionMode] to stop the transcription in the meeting. Default is [HMSTranscriptionMode.caption]
  ///
  /// Refer [stopTranscription](https://www.100ms.live/docs/flutter/v2/how-to-guides/extend-capabilities/live-captions#stop-transcription)
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
