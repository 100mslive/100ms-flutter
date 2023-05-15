enum HMSHLSPlaybackEventMethod {
  onPlaybackFailure,
  onPlaybackStateChanged,
  onCue,
  unknown
}

extension HMSHLSPlaybackEventMethodValues on HMSHLSPlaybackEventMethod {
  static HMSHLSPlaybackEventMethod getMethodFromName(String name) {
    switch (name) {
      case "on_playback_failure":
        return HMSHLSPlaybackEventMethod.onPlaybackFailure;
      case "on_playback_state_changed":
        return HMSHLSPlaybackEventMethod.onPlaybackStateChanged;
      case "on_cue":
        return HMSHLSPlaybackEventMethod.onCue;
      default:
        return HMSHLSPlaybackEventMethod.unknown;
    }
  }
}
