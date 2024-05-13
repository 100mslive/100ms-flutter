///[hmsWhiteboardState] enum is used to define the state of the whiteboard
enum hmsWhiteboardState { started, stopped }

extension HMSWhiteboardStateValues on hmsWhiteboardState {
  static hmsWhiteboardState getWhiteboardStateFromName(String name) {
    switch (name) {
      case "started":
        return hmsWhiteboardState.started;
      case "stopped":
        return hmsWhiteboardState.stopped;
      default:
        return hmsWhiteboardState.stopped;
    }
  }
}
