enum HMSWhiteboardListenerMethod {
  onWhiteboardStart,
  onWhiteboardStop,
  unknown
}

extension HMSWhiteboardListenerMethodValues on HMSWhiteboardListenerMethod {
  static HMSWhiteboardListenerMethod getHMSWhiteboardListenerMethodFromString(
      String whiteboardMethod) {
    switch (whiteboardMethod) {
      case 'on_whiteboard_start':
        return HMSWhiteboardListenerMethod.onWhiteboardStart;
      case 'on_whiteboard_stop':
        return HMSWhiteboardListenerMethod.onWhiteboardStop;
      default:
        return HMSWhiteboardListenerMethod.unknown;
    }
  }
}
