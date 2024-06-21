///[HMSTranscriptionListenerMethod] contains method for `HMSTranscriptionListener`
enum HMSTranscriptionListenerMethod { onTranscripts, unknown }

extension HMSTranscriptionListenerMethodValues
    on HMSTranscriptionListenerMethod {
  static HMSTranscriptionListenerMethod
      getHMSTranscriptionListenerMethodFromString(String transcription) {
    switch (transcription) {
      case "on_transcripts":
        return HMSTranscriptionListenerMethod.onTranscripts;
      default:
        return HMSTranscriptionListenerMethod.unknown;
    }
  }
}
