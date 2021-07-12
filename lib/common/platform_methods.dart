enum PlatformMethod {
  joinMeeting,
  leaveMeeting,
  onLeaveMeeting,
  onJoinRoom,
  onUpdateRoom,
  onPeerUpdate,
  onTrackUpdate,
  onError,
  onMessage,
  onUpdateSpeaker,
  onReconnecting,
  onReconnected,
  unknown
}

extension PlatformMethodValues on PlatformMethod {
  static String getName(PlatformMethod method) {
    switch (method) {
      case PlatformMethod.joinMeeting:
        return 'join_meeting';
      case PlatformMethod.leaveMeeting:
        return 'leave_meeting';
      case PlatformMethod.onLeaveMeeting:
        return 'on_leave_meeting';
      case PlatformMethod.onJoinRoom:
        return 'on_join_room';
      case PlatformMethod.onUpdateRoom:
        return 'on_update_room';
      case PlatformMethod.onPeerUpdate:
        return 'on_peer_update';
      case PlatformMethod.onTrackUpdate:
        return 'on_track_update';
      case PlatformMethod.onError:
        return 'on_error';
      case PlatformMethod.onMessage:
        return 'on_message';
      case PlatformMethod.onUpdateSpeaker:
        return 'on_update_speaker';
      case PlatformMethod.onReconnecting:
        return 'on_re_connecting';
      case PlatformMethod.onReconnected:
        return 'on_re_connected';
      case PlatformMethod.unknown:
        return 'unknown';
    }
  }

  static PlatformMethod getMethodFromName(String name) {
    switch (name) {
      case 'join_meeting':
        return PlatformMethod.joinMeeting;
      case 'leave_meeting':
        return PlatformMethod.leaveMeeting;
      case 'on_leave_meeting':
        return PlatformMethod.onLeaveMeeting;
      case 'on_join_room':
        return PlatformMethod.onJoinRoom;
      case 'on_update_room':
        return PlatformMethod.onUpdateRoom;
      case 'on_peer_update':
        return PlatformMethod.onPeerUpdate;
      case 'on_track_update':
        return PlatformMethod.onTrackUpdate;
      case 'on_error':
        return PlatformMethod.onError;
      case 'on_message':
        return PlatformMethod.onMessage;
      case 'on_update_speaker':
        return PlatformMethod.onUpdateSpeaker;
      case 'on_re_connecting':
        return PlatformMethod.onReconnecting;
      case 'on_re_connected':
        return PlatformMethod.onReconnected;
      default:
        return PlatformMethod.unknown;
    }
  }
}
