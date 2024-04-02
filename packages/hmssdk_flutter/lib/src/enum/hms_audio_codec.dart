///[HMSAudioCodec] contains audio codec supported by HMSSDK
enum HMSAudioCodec { opus, unknown }

///Utility method to return audio codec from string and vice versa
extension HMSAudioCodecValues on HMSAudioCodec {
  static HMSAudioCodec getHMSCodecFromName(String name) {
    switch (name) {
      case 'opus':
        return HMSAudioCodec.opus;

      default:
        return HMSAudioCodec.unknown;
    }
  }

  static String getValueFromHMSAudioCodec(HMSAudioCodec hmsAudioCodec) {
    switch (hmsAudioCodec) {
      case HMSAudioCodec.opus:
        return 'opus';

      case HMSAudioCodec.unknown:
        return '';
    }
  }
}
