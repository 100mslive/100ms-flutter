enum HMSAudioMode { VOICE, MUSIC }

extension HMSAudioModeValues on HMSAudioMode {
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
