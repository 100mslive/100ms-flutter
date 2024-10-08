///[HMSTranscriptionMode] is an enum class that defines the transcription mode of the meeting.
enum HMSTranscriptionMode { caption, live, unknown }

extension HMSTranscriptionModeValues on HMSTranscriptionMode {
  static HMSTranscriptionMode getHMSTranscriptionModeFromString(
      String transcription) {
    switch (transcription) {
      case "caption":
        return HMSTranscriptionMode.caption;
      case "live":
        return HMSTranscriptionMode.live;
      default:
        return HMSTranscriptionMode.unknown;
    }
  }
}
