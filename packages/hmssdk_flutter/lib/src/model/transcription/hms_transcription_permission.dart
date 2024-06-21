//Project imports
import 'package:hmssdk_flutter/src/enum/hms_transcription_mode.dart';

///[HMSTranscriptionPermission] contains the permission of the user for transcription.
class HMSTranscriptionPermission {
  ///[mode] is the transcription mode of the meeting.
  final HMSTranscriptionMode mode;

  ///[admin] is a boolean value that defines if the user has admin permission for transcription.
  ///i.e permissions to start/stop the transcription.
  final bool admin;

  HMSTranscriptionPermission({required this.mode, required this.admin});

  factory HMSTranscriptionPermission.fromMap(Map map) {
    return HMSTranscriptionPermission(
        mode: HMSTranscriptionModeValues.getHMSTranscriptionModeFromString(
            map['mode']),
        admin: map['admin']);
  }
}
