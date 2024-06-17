import 'package:hmssdk_flutter/src/model/transcription/hms_transcription.dart';

abstract class HMSTranscriptListener {
  void onTranscripts({required List<HMSTranscription> transcriptions}) {}
}
