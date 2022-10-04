///Enum to set the audio/video initial track state to be passed with HMSTrackSetting
enum HMSTrackInitState {
  MUTED,
  UNMUTED,
}

extension HMSTrackInitStateValue on HMSTrackInitState {
  static HMSTrackInitState getHMSTrackInitStateFromName(String name) {
    switch (name) {
      case 'MUTED':
        return HMSTrackInitState.MUTED;
      case 'UNMUTED':
        return HMSTrackInitState.UNMUTED;
      default:
        return HMSTrackInitState.MUTED;
    }
  }

  static String getValuefromHMSTrackInitState(
      HMSTrackInitState hmsTrackInitState) {
    switch (hmsTrackInitState) {
      case HMSTrackInitState.MUTED:
        return 'MUTED';
      case HMSTrackInitState.UNMUTED:
        return 'UNMUTED';
      default:
        return "MUTED";
    }
  }
}
