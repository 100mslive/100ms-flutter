enum HMSCodec { H264, VP8, VP9, unknown }

///HMSCodec
extension HMSCodecValues on HMSCodec {
  static HMSCodec getHMSCodecFromName(String name) {
    switch (name) {
      case 'h264':
        return HMSCodec.H264;
      case 'vp8':
        return HMSCodec.VP8;
      case 'vp9':
        return HMSCodec.VP9;
      default:
        return HMSCodec.unknown;
    }
  }

  static String getValueFromHMSCodec(HMSCodec hmsCodec) {
    switch (hmsCodec) {
      case HMSCodec.H264:
        return 'h264';
      case HMSCodec.VP8:
        return 'vp8';
      case HMSCodec.VP9:
        return 'vp9';
      case HMSCodec.unknown:
        return 'defaultCodec';
    }
  }
}
