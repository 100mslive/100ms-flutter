enum HMSPreviewUpdateListenerMethod { onPreviewVideo, unknown }

extension HMSPreviewUpdateListenerMethodValues
    on HMSPreviewUpdateListenerMethod {
  static HMSPreviewUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'preview_video':
        return HMSPreviewUpdateListenerMethod.onPreviewVideo;
      default:
        return HMSPreviewUpdateListenerMethod.unknown;
    }
  }
}
