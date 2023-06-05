enum HMSHLSPlaybackState {
  PLAYING,
  STOPPED,
  PAUSED,
  BUFFERING,
  FAILED,
  UNKNOWN
}

extension HMSHLSPlaybackStateValues on HMSHLSPlaybackState {
  static HMSHLSPlaybackState getMethodFromName(String name) {
    switch (name) {
      case "playing":
        return HMSHLSPlaybackState.PLAYING;
      case "stopped":
        return HMSHLSPlaybackState.STOPPED;
      case "paused":
        return HMSHLSPlaybackState.PAUSED;
      case "buffering":
        return HMSHLSPlaybackState.BUFFERING;
      case "failed":
        return HMSHLSPlaybackState.FAILED;
      default:
        return HMSHLSPlaybackState.UNKNOWN;
    }
  }
}
