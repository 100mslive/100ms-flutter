enum HMSAudioCodec { opus, unknown }

extension HMSCodecValues on HMSAudioCodec {
  static HMSAudioCodec getHMSCodecFromName(String name) {
    switch (name) {
      case 'opus':
        return HMSAudioCodec.opus;

      default:
        return HMSAudioCodec.unknown;
    }
  }

  static String getValueFromHMSCodec(HMSAudioCodec hmsAudioCodec) {
    switch (hmsAudioCodec) {
      case HMSAudioCodec.opus:
        return 'kHMSCodecH264';

      case HMSAudioCodec.unknown:
        return '';
    }
  }
}
