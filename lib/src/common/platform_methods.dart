///platformmethods to use to interact with specific platform
enum PlatformMethod {
  ///join meeting using this.
  joinMeeting,
  ///leave meeting
  leaveMeeting,
  onLeaveMeeting,
  ///when onJoin callback is called
  onJoinRoom,
  ///when room is updated.
  onUpdateRoom,
  ///when there is any change in peer in a room.
  onPeerUpdate,
  ///when there is track updates
  onTrackUpdate,
  ///when onError update is called
  onError,
  onMessage,
  ///when you want to send a message.
  sendMessage,
  sendDirectMessage,
  sendGroupMessage,
  onUpdateSpeaker,
  ///when reconnecting update method is called.
  onReconnecting,
  ///when reconnected update method is called.
  onReconnected,
  ///switch mic on/off.
  switchAudio,
  switchVideo,
  ///switch your camera.
  switchCamera,
  ///check whether audio is mute or not.
  isAudioMute,
  ///check whether video is mute or not.
  isVideoMute,
  ///start capturing your video from your camera.
  startCapturing,
  ///stop capturing your video from your camera.
  stopCapturing,
  ///get tracks for previewVideo.
  previewVideo,
  ///accept role changes suggestedBy any peer.
  acceptRoleChange,
  ///change your peer role.
  changeRole,
  ///get list of roles using this.
  getRoles,
  changeTrack,
  endRoom,
  removePeer,
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
      case PlatformMethod.switchAudio:
        return 'switch_audio';
      case PlatformMethod.switchVideo:
        return 'switch_video';
      case PlatformMethod.switchCamera:
        return 'switch_camera';
      case PlatformMethod.isAudioMute:
        return 'is_audio_mute';
      case PlatformMethod.isVideoMute:
        return 'is_video_mute';
      case PlatformMethod.startCapturing:
        return 'start_capturing';
      case PlatformMethod.stopCapturing:
        return 'stop_capturing';
      case PlatformMethod.sendMessage:
        return 'send_message';
      case PlatformMethod.sendDirectMessage:
        return 'send_direct_message';
      case PlatformMethod.sendGroupMessage:
        return 'send_group_message';
      case PlatformMethod.previewVideo:
        return 'preview_video';
      case PlatformMethod.acceptRoleChange:
        return 'accept_role_change';
      case PlatformMethod.changeRole:
        return 'change_role';
      case PlatformMethod.getRoles:
        return 'get_roles';
      case PlatformMethod.changeTrack:
        return 'on_change_track_state_request';
      case PlatformMethod.endRoom:
        return 'end_room';
      case PlatformMethod.removePeer:
        return 'remove_peer';
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
      case 'switch_audio':
        return PlatformMethod.switchAudio;
      case 'switch_video':
        return PlatformMethod.switchVideo;
      case 'switch_camera':
        return PlatformMethod.switchCamera;
      case 'is_audio_mute':
        return PlatformMethod.isAudioMute;
      case 'is_video_mute':
        return PlatformMethod.isVideoMute;
      case 'stop_capturing':
        return PlatformMethod.stopCapturing;
      case 'start_capturing':
        return PlatformMethod.startCapturing;
      case 'send_message':
        return PlatformMethod.sendMessage;
      case 'send_direct_message':
        return PlatformMethod.sendDirectMessage;
      case 'send_group_message':
        return PlatformMethod.sendGroupMessage;
      case 'preview_video':
        return PlatformMethod.previewVideo;
      case 'accept_role_change':
        return PlatformMethod.acceptRoleChange;
      case 'change_role':
        return PlatformMethod.changeRole;
      case 'get_roles':
        return PlatformMethod.getRoles;
      case 'on_change_track_state_request':
        return PlatformMethod.changeTrack;
      case 'end_room':
        return PlatformMethod.endRoom;
      case 'remove_peer':
        return PlatformMethod.removePeer;
      default:
        return PlatformMethod.unknown;
    }
  }
}
