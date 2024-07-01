///[HMSTranscriptionState] is an enum class which defines the state of the transcription
enum HMSTranscriptionState { started, stopped, initialized, failed, unknown }

extension HMSTranscriptionStateValues on HMSTranscriptionState {
  static HMSTranscriptionState getHMSTranscriptionStateFromString(
      String transcription) {
    switch (transcription) {
      case "started":
        return HMSTranscriptionState.started;
      case "stopped":
        return HMSTranscriptionState.stopped;
      case "initialized":
        return HMSTranscriptionState.initialized;
      case "failed":
        return HMSTranscriptionState.failed;
      default:
        return HMSTranscriptionState.unknown;
    }
  }
}
