enum HMSVideoViewEvents { onFirstFrameRendered, onResolutionChanged, unknown }

extension HMSVideoViewEventsValues on HMSVideoViewEvents {
  static HMSVideoViewEvents getHMSVideoViewEventFromString(String eventName) {
    switch (eventName) {
      case "on_first_frame_rendered":
        return HMSVideoViewEvents.onFirstFrameRendered;
      case "on_resolution_changed":
        return HMSVideoViewEvents.onResolutionChanged;
      default:
        return HMSVideoViewEvents.unknown;
    }
  }
}
