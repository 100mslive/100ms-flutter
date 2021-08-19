enum HMSPreviewUpdateListenerMethod { onPreviewVideo, onError, unknown }

extension HMSPreviewUpdateListenerMethodValues
    on HMSPreviewUpdateListenerMethod {
  static HMSPreviewUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'preview_video':
        return HMSPreviewUpdateListenerMethod.onPreviewVideo;
      case 'on_error':
        return HMSPreviewUpdateListenerMethod.onError;
      default:
        return HMSPreviewUpdateListenerMethod.unknown;
    }
  }
}
