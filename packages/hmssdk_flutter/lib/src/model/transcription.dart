import 'package:hmssdk_flutter/src/enum/hms_transcription_mode.dart';
import 'package:hmssdk_flutter/src/enum/hms_transcription_state.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

class Transcription {
  final TranscriptionError? error;
  final DateTime? startedAt;
  final DateTime? stoppedAt;
  final DateTime? updatedAt;
  final HMSTranscriptionState? state;
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

class TranscriptionError {
  final int? code;
  final String? message;

  TranscriptionError({required this.code, required this.message});

  factory TranscriptionError.fromMap(Map map) {
    return TranscriptionError(code: map['code'], message: map['message']);
  }
}
