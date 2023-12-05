enum HMSVideoViewEvent { onResolutionChanged, unknown }

extension HMSVideoViewValues on HMSVideoViewEvent {
  static HMSVideoViewEvent getHMSVideoViewEventFromString(String event) {
    switch (event) {
      case "on_resolution_changed":
        return HMSVideoViewEvent.onResolutionChanged;
      default:
        return HMSVideoViewEvent.unknown;
    }
  }
}
