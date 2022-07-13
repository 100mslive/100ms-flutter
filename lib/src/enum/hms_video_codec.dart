enum HMSVideoCodec { h264, vp8, vp9, h265, unknown }

///VideoCodec
extension HMSVideoCodecValues on HMSVideoCodec {
  static HMSVideoCodec getHMSCodecFromName(String name) {
    switch (name) {
      case 'h264':
        return HMSVideoCodec.h264;
      case 'vp8':
        return HMSVideoCodec.vp8;
      case 'vp9':
        return HMSVideoCodec.vp9;
      case 'h265':
        return HMSVideoCodec.h265;
      default:
        return HMSVideoCodec.unknown;
    }
  }

  static String getValueFromHMSVideoCodec(HMSVideoCodec hMSVideoCodec) {
    switch (hMSVideoCodec) {
      case HMSVideoCodec.h264:
        return 'h264';
      case HMSVideoCodec.vp8:
        return 'vp8';
      case HMSVideoCodec.vp9:
        return 'vp9';
      case HMSVideoCodec.h265:
        return 'h265';
      case HMSVideoCodec.unknown:
        return 'unknown';
    }
  }
}
