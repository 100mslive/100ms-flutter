//Project imports
import 'package:hmssdk_flutter/src/model/transcription/hms_transcription.dart';

///[HMSTranscriptListener] is the listener interface which listens to the transcription of the meeting.
///
///Implement this listener in your class to get the transcription of the meeting.
abstract class HMSTranscriptListener {
  ///[onTranscripts] is called when the transcription is received.
  void onTranscripts({required List<HMSTranscription> transcriptions}) {}
}
