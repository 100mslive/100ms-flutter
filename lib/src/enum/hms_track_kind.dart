enum HMSTrackKind { kHMSTrackKindAudio, kHMSTrackKindVideo, unknown }

///Type of track [AUDIO,VIDEO]
extension HMSTrackKindValue on HMSTrackKind {
  static HMSTrackKind getHMSTrackKindFromName(String name) {
    switch (name) {

      ///IOS
      case 'kHMSTrackKindAudio':
        return HMSTrackKind.kHMSTrackKindAudio;

      ///IOS
      case 'kHMSTrackKindVideo':
        return HMSTrackKind.kHMSTrackKindVideo;

      ///Android
      case 'AUDIO':
        return HMSTrackKind.kHMSTrackKindAudio;

      ///Android
      case 'VIDEO':
        return HMSTrackKind.kHMSTrackKindVideo;
      default:
        return HMSTrackKind.unknown;
    }
  }

  static String getValueFromHMSTrackKind(HMSTrackKind hmsTrackKind) {
    switch (hmsTrackKind) {
      case HMSTrackKind.kHMSTrackKindAudio:
        return 'kHMSTrackKindAudio';
      case HMSTrackKind.kHMSTrackKindVideo:
        return 'kHMSTrackKindVideo';
      case HMSTrackKind.unknown:
        return '';
    }
  }
}
