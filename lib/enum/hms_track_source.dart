enum HMSTrackSource {
  kHMSTrackSourceRegular,
  kHMSTrackSourceScreen,
  kHMSTrackSourcePlugin,
  unknown
}

extension HMSTrackSourceValue on HMSTrackSource {
  static HMSTrackSource getHMSTrackSourceFromName(String name) {
    switch (name) {
      case 'kHMSTrackSourceRegular':
        return HMSTrackSource.kHMSTrackSourceRegular;
      case 'kHMSTrackSourceScreen':
        return HMSTrackSource.kHMSTrackSourceScreen;
      case 'kHMSTrackSourcePlugin':
        return HMSTrackSource.kHMSTrackSourcePlugin;
      default:
        return HMSTrackSource.unknown;
    }
  }

  static String getValueFromHMSTrackSource(HMSTrackSource hmsTrackKind) {
    switch (hmsTrackKind) {
      case HMSTrackSource.kHMSTrackSourceRegular:
        return 'kHMSTrackSourceRegular';
      case HMSTrackSource.kHMSTrackSourceScreen:
        return 'kHMSTrackSourceScreen';
      case HMSTrackSource.kHMSTrackSourcePlugin:
        return 'kHMSTrackSourcePlugin';
      case HMSTrackSource.unknown:
        return '';
    }
  }
}
