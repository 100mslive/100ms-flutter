import 'package:hmssdk_flutter/src/enum/hms_transcription_mode.dart';

class HMSTranscriptionPermission {
  final HMSTranscriptionMode mode;
  final bool admin;

  HMSTranscriptionPermission({required this.mode, required this.admin});

  factory HMSTranscriptionPermission.fromMap(Map map) {
    return HMSTranscriptionPermission(
        mode: HMSTranscriptionModeValues.getHMSTranscriptionModeFromString(
            map['mode']),
        admin: map['admin']);
  }
}
