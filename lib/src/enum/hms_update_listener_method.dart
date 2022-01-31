enum HMSUpdateListenerMethod {
  onJoinRoom,
  onUpdateRoom,
  onPeerUpdate,
  onTrackUpdate,
  onError,
  onMessage,
  onUpdateSpeaker,
  onReconnecting,
  onReconnected,
  onRoleChangeRequest,
  onChangeTrackStateRequest,
  onRemovedFromRoom,
  onLocalAudioStats,
  onLocalVideoStats,
  onRemoteAudioStats,
  onRemoteVideoStats,
  onRtcStats,
  unknown
}

extension HMSUpdateListenerMethodValues on HMSUpdateListenerMethod {
  static HMSUpdateListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_join_room':
        return HMSUpdateListenerMethod.onJoinRoom;
      case 'on_room_update':
        return HMSUpdateListenerMethod.onUpdateRoom;
      case 'on_peer_update':
        return HMSUpdateListenerMethod.onPeerUpdate;
      case 'on_track_update':
        return HMSUpdateListenerMethod.onTrackUpdate;
      case 'on_error':
        return HMSUpdateListenerMethod.onError;
      case 'on_message':
        return HMSUpdateListenerMethod.onMessage;
      case 'on_update_speaker':
        return HMSUpdateListenerMethod.onUpdateSpeaker;
      case 'on_re_connecting':
        return HMSUpdateListenerMethod.onReconnecting;
      case 'on_re_connected':
        return HMSUpdateListenerMethod.onReconnected;
      case 'on_role_change_request':
        return HMSUpdateListenerMethod.onRoleChangeRequest;
      case 'on_change_track_state_request':
        return HMSUpdateListenerMethod.onChangeTrackStateRequest;
      case 'on_removed_from_room':
        return HMSUpdateListenerMethod.onRemovedFromRoom;
      case 'on_local_audio_stats':
        return HMSUpdateListenerMethod.onLocalAudioStats;
      case 'on_local_video_stats':
        return HMSUpdateListenerMethod.onLocalVideoStats;
      case 'on_remote_audio_stats':
        return HMSUpdateListenerMethod.onRemoteAudioStats;
      case 'on_remote_video_stats':
        return HMSUpdateListenerMethod.onRemoteVideoStats;
      case 'on_rtc_stats_report':
        return HMSUpdateListenerMethod.onRtcStats;
      default:
        return HMSUpdateListenerMethod.unknown;
    }
  }
}
