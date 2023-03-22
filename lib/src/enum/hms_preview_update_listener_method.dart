enum HMSPreviewUpdateListenerMethod {
  onPreviewVideo,
  onError,
  onPeerUpdate,
  onRoomUpdate,
  onAudioDeviceChanged,
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
      case 'on_audio_device_changed':
        return HMSPreviewUpdateListenerMethod.onAudioDeviceChanged;
      default:
        return HMSPreviewUpdateListenerMethod.unknown;
    }
  }
}
