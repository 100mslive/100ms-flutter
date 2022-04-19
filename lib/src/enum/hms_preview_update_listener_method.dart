enum HMSPreviewUpdateListenerMethod {
  onPreviewVideo,
  onError,
  onPeerUpdate,
  onRoomUpdate,
  unknown
}

extension HMSPreviewUpdateListenerMethodValues
    on HMSPreviewUpdateListenerMethod {
  static HMSPreviewUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'preview_video':
        return HMSPreviewUpdateListenerMethod.onPreviewVideo;
      case 'on_error':
        return HMSPreviewUpdateListenerMethod.onError;
      case 'on_peer_update':
        return HMSPreviewUpdateListenerMethod.onPeerUpdate;
      case 'on_room_update':
        return HMSPreviewUpdateListenerMethod.onRoomUpdate;
      default:
        return HMSPreviewUpdateListenerMethod.unknown;
    }
  }
}
