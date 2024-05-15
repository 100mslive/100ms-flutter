///[HMSWhiteboardState] enum is used to define the state of the whiteboard
enum HMSWhiteboardState { started, stopped }

extension HMSWhiteboardStateValues on HMSWhiteboardState {
  static HMSWhiteboardState getWhiteboardStateFromName(String name) {
    switch (name) {
      case "started":
        return HMSWhiteboardState.started;
      case "stopped":
        return HMSWhiteboardState.stopped;
      default:
        return HMSWhiteboardState.stopped;
    }
  }
}
