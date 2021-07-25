enum HMSCodec { kHMSCodecH264, kHMSCodecVP8, unknown }

extension HMSCodecValues on HMSCodec {
  static HMSCodec getHMSCodecFromName(String name) {
    switch (name) {
      case 'kHMSCodecH264':
        return HMSCodec.kHMSCodecH264;
      case 'kHMSCodecVP8':
        return HMSCodec.kHMSCodecVP8;

      default:
        return HMSCodec.unknown;
    }
  }

  static String getValueFromHMSCodec(HMSCodec hmsCodec) {
    switch (hmsCodec) {
      case HMSCodec.kHMSCodecH264:
        return 'kHMSCodecH264';
      case HMSCodec.kHMSCodecVP8:
        return 'kHMSCodecVP8';
      case HMSCodec.unknown:
        return '';
    }
  }
}
