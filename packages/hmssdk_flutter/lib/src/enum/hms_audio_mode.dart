/// Audio mode for the local user.
enum HMSAudioMode { VOICE, MUSIC }

/// Extension for [HMSAudioMode] enum
extension HMSAudioModeValues on HMSAudioMode {
  /// return value of enum
  static HMSAudioMode getAudioModeFromName(String name) {
    switch (name) {
      case "voice":
        return HMSAudioMode.VOICE;
      case "music":
        return HMSAudioMode.MUSIC;
      default:
        return HMSAudioMode.VOICE;
    }
  }

  /// return name of enum
  static String getNameFromHMSAudioMode(HMSAudioMode mode) {
    switch (mode) {
      case HMSAudioMode.VOICE:
        return "voice";
      case HMSAudioMode.MUSIC:
        return "music";
      default:
        return "voice";
    }
  }
}
