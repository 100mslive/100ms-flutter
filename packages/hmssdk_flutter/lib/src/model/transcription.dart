//Project imports
import 'package:hmssdk_flutter/src/enum/hms_transcription_mode.dart';
import 'package:hmssdk_flutter/src/enum/hms_transcription_state.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///[Transcription] is a class which includes the properties of a transcription
class Transcription {
  ///[error] is the error object which contains the error code and message if any error occurs.
  final TranscriptionError? error;

  ///[startedAt] is the time when the transcription started.
  final DateTime? startedAt;

  ///[stoppedAt] is the time when the transcription stopped.
  final DateTime? stoppedAt;

  ///[updatedAt] is the time when the transcription was last updated.
  final DateTime? updatedAt;

  ///[state] is an enum of type [HMSTranscriptionState] which tells the state of the transcription.
  final HMSTranscriptionState? state;

  ///[mode] is an enum of type [HMSTranscriptionMode] which tells the mode of the transcription.
  final HMSTranscriptionMode? mode;

  Transcription(
      {this.error,
      this.startedAt,
      this.stoppedAt,
      this.updatedAt,
      this.state,
      this.mode});

  factory Transcription.fromMap(Map map) {
    return Transcription(
        error: map["error"] != null
            ? TranscriptionError.fromMap(map["error"])
            : null,
        startedAt: map["started_at"] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        stoppedAt: map["stopped_at"] != null
            ? HMSDateExtension.convertDateFromEpoch(map['stopped_at'])
            : null,
        updatedAt: map["updated_at"] != null
            ? HMSDateExtension.convertDateFromEpoch(map['updated_at'])
            : null,
        state: map["state"] != null
            ? HMSTranscriptionStateValues.getHMSTranscriptionStateFromString(
                map["state"])
            : null,
        mode: map["mode"] != null
            ? HMSTranscriptionModeValues.getHMSTranscriptionModeFromString(
                map["mode"])
            : null);
  }
}

///[TranscriptionError] is a class which includes the properties of an error in transcription
class TranscriptionError {
  ///[code] is the error code.
  final int? code;

  ///[message] is the error message.
  final String? message;

  TranscriptionError({required this.code, required this.message});

  factory TranscriptionError.fromMap(Map map) {
    return TranscriptionError(code: map['code'], message: map['message']);
  }
}
