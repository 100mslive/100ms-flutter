///[HMSHLSPlaybackEventMethod] is an enum containing the HLS Player callbacks
enum HMSHLSPlaybackEventMethod {
  onPlaybackFailure,
  onPlaybackStateChanged,
  onCue,
  onHLSError,
  onHLSEventUpdate,
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
      case "on_hls_error":
        return HMSHLSPlaybackEventMethod.onHLSError;
      case "on_hls_event_update":
        return HMSHLSPlaybackEventMethod.onHLSEventUpdate;
      default:
        return HMSHLSPlaybackEventMethod.unknown;
    }
  }
}
