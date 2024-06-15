import 'package:hmssdk_flutter/src/model/hms_transcription.dart';

abstract class HMSTranscriptListener {
  void onTranscripts({required List<HMSTranscription> transcriptions}) {}
}
