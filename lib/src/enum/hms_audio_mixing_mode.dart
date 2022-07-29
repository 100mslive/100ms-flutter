enum HMSAudioMixingMode { TALK_ONLY, TALK_AND_MUSIC, MUSIC_ONLY, UNKNOWN }

///Camera facing
extension HMSAudiosMixingModeValues on HMSAudioMixingMode {
  static HMSAudioMixingMode getHMSAudioDeviceFromName(String name) {
    switch (name) {
      case 'TALK_ONLY':
        return HMSAudioMixingMode.TALK_ONLY;

      case 'TALK_AND_MUSIC':
        return HMSAudioMixingMode.TALK_AND_MUSIC;

      case 'MUSIC_ONLY':
        return HMSAudioMixingMode.MUSIC_ONLY;

      default:
        return HMSAudioMixingMode.UNKNOWN;
    }
  }

  static String getValueFromHMSAudiosMixingMode(
      HMSAudioMixingMode hmsAudiosMixingMode) {
    switch (hmsAudiosMixingMode) {
      case HMSAudioMixingMode.TALK_ONLY:
        return "TALK_ONLY";
      case HMSAudioMixingMode.TALK_AND_MUSIC:
        return "TALK_AND_MUSIC";
      case HMSAudioMixingMode.MUSIC_ONLY:
        return "MUSIC_ONLY";
      case HMSAudioMixingMode.UNKNOWN:
        return "UNKNOWN";
    }
  }
}
