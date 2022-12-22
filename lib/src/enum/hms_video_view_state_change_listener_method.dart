enum HMSVideoViewStateChangeListenerMethod{
    onFirstFrameRendered,
    onResolutionChange,
    unknown
}

extension HMSVideoViewStateChangeListenerMethodValues on HMSVideoViewStateChangeListenerMethod {
  static HMSVideoViewStateChangeListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_first_frame_rendered':
        return HMSVideoViewStateChangeListenerMethod.onFirstFrameRendered;
      case 'on_resolution_change':
        return HMSVideoViewStateChangeListenerMethod.onResolutionChange;
      default:
        return HMSVideoViewStateChangeListenerMethod.unknown;
    }
  }
}