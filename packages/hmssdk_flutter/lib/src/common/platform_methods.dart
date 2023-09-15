///platformmethods to use to interact with specific platform
enum PlatformMethod {
  ///join meeting using this.
  join,

  ///leave meeting
  leave,
  onLeave,

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

  ///when you want to send a broadcast message.
  sendBroadcastMessage,

  ///when you want to send a direct message.
  sendDirectMessage,

  ///when you want to send a group message.
  sendGroupMessage,
  onUpdateSpeaker,

  ///when reconnecting update method is called.
  onReconnecting,

  ///when reconnected update method is called.
  onReconnected,

  ///switch mic on/off.
  switchAudio,

  ///switch video on/off
  switchVideo,

  ///switch your camera.
  switchCamera,

  ///check whether audio is mute or not.
  isAudioMute,

  ///check whether video is mute or not.
  isVideoMute,

  ///get tracks for preview.
  preview,

  ///accept role changes suggestedBy any peer.
  acceptChangeRole,

  ///change your peer role.
  changeRole,

  ///change role for peer.
  changeRoleOfPeer,

// turn on screen share start
  startScreenShare,

// turn off screen share
  stopScreenShare,

// check if screen share is active
  isScreenShareActive,

  ///get list of roles using this.
  getRoles,
  changeTrackState,

  ///end room
  endRoom,

  ///remove peer from room
  removePeer,
  //mute all peers in room for yourself
  muteRoomAudioLocally,
  //unMute all peers in room for yourself
  unMuteRoomAudioLocally,
  //mute all peers video in room for yourself
  muteRoomVideoLocally,
  //unMute all peers video in room for yourself
  unMuteRoomVideoLocally,
  //get local peer
  getLocalPeer,
  //get list of all remote peers
  getRemotePeers,
  //get list of all peers
  getPeers,
  unknown,
  startHMSLogger,
  removeHMSLogger,
  changeTrackStateForRole,

  ///start rtmp or recording
  startRtmpOrRecording,

  ///stop rtmp and recording
  stopRtmpAndRecording,
  build,
  getRoom,

  ///change metadata for local peer
  changeMetadata,
  setVolume,

  ///change name of local peer
  changeName,

  ///start HLS Streaming
  startHlsStreaming,

  ///stop HLS Streaming
  stopHlsStreaming,

  ///Get List all tracks
  getAllTracks,

  ///Get track with the help of trackId
  getTrackById,
  startStatsListener,
  removeStatsListener,
  getAudioDevicesList,
  getCurrentAudioDevice,
  switchAudioOutput,
  startAudioShare,
  stopAudioShare,
  setAudioMixingMode,
  pauseAudioShare,
  playAudioShare,
  resumeAudioShare,
  setAudioShareVolume,
  audioSharePlaying,
  audioShareCurrentTime,
  audioShareDuration,
  getTrackSettings,
  destroy,
  setPlaybackAllowedForTrack,
  enterPipMode,
  isPipActive,
  isPipAvailable,
  changeRoleOfPeersWithRoles,
  setSimulcastLayer,
  getLayer,
  getLayerDefinition,
  setupPIP,
  startPIP,
  stopPIP,
  changeTrackPIP,
  changeTextPIP,
  destroyPIP,
  toggleMicMuteState,
  toggleCameraMuteState,
  captureSnapshot,
  getAllLogs,
  getAuthTokenByRoomCode,
  captureImageAtMaxSupportedResolution,
  isFlashSupported,
  toggleFlash,
  getSessionMetadataForKey,
  setSessionMetadataForKey,
  addKeyChangeListener,
  removeKeyChangeListener,
  start,
  stop,
  pause,
  resume,
  seekToLivePosition,
  seekForward,
  seekBackward,
  setHLSPlayerVolume,
  addHLSStatsListener,
  removeHLSStatsListener,
  switchAudioOutputUsingiOSUI,
  sendHLSTimedMetadata,
  toggleAlwaysScreenOn,
  getRoomLayout,
  previewForRole,
  cancelPreview
}

extension PlatformMethodValues on PlatformMethod {
  static String getName(PlatformMethod method) {
    switch (method) {
      case PlatformMethod.join:
        return 'join';

      case PlatformMethod.leave:
        return 'leave';

      case PlatformMethod.onLeave:
        return 'on_leave';

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

      case PlatformMethod.getRoom:
        return "get_room";

      case PlatformMethod.sendBroadcastMessage:
        return 'send_broadcast_message';

      case PlatformMethod.sendDirectMessage:
        return 'send_direct_message';

      case PlatformMethod.sendGroupMessage:
        return 'send_group_message';

      case PlatformMethod.preview:
        return 'preview';

      case PlatformMethod.acceptChangeRole:
        return 'accept_change_role';

      case PlatformMethod.changeRole:
        return 'change_role';

      case PlatformMethod.changeRoleOfPeer:
        return 'change_role_of_peer';

      case PlatformMethod.getRoles:
        return 'get_roles';

      case PlatformMethod.changeTrackState:
        return 'on_change_track_state_request';

      case PlatformMethod.endRoom:
        return 'end_room';

      case PlatformMethod.removePeer:
        return 'remove_peer';

      case PlatformMethod.muteRoomAudioLocally:
        return 'mute_room_audio_locally';

      case PlatformMethod.unMuteRoomAudioLocally:
        return 'un_mute_room_audio_locally';

      case PlatformMethod.muteRoomVideoLocally:
        return 'mute_room_video_locally';

      case PlatformMethod.unMuteRoomVideoLocally:
        return 'un_mute_room_video_locally';

      case PlatformMethod.getLocalPeer:
        return 'get_local_peer';

      case PlatformMethod.getRemotePeers:
        return 'get_remote_peers';

      case PlatformMethod.getPeers:
        return 'get_peers';

      case PlatformMethod.startHMSLogger:
        return "start_hms_logger";

      case PlatformMethod.removeHMSLogger:
        return "remove_hms_logger";

      case PlatformMethod.changeTrackStateForRole:
        return "change_track_state_for_role";

      case PlatformMethod.startRtmpOrRecording:
        return "start_rtmp_or_recording";

      case PlatformMethod.stopRtmpAndRecording:
        return "stop_rtmp_and_recording";

      case PlatformMethod.build:
        return 'build';

      case PlatformMethod.changeMetadata:
        return "change_metadata";

      case PlatformMethod.setVolume:
        return "set_volume";

      case PlatformMethod.changeName:
        return "change_name";

      case PlatformMethod.startHlsStreaming:
        return "hls_start_streaming";
      case PlatformMethod.stopHlsStreaming:
        return "hls_stop_streaming";

      case PlatformMethod.startScreenShare:
        return "start_screen_share";

      case PlatformMethod.stopScreenShare:
        return "stop_screen_share";

      case PlatformMethod.previewForRole:
        return "preview_for_role";

      case PlatformMethod.cancelPreview:
        return "cancel_preview";

      case PlatformMethod.isScreenShareActive:
        return 'is_screen_share_active';
      case PlatformMethod.getAllTracks:
        return "get_all_tracks";
      case PlatformMethod.getTrackById:
        return "get_track_by_id";
      case PlatformMethod.startStatsListener:
        return "start_stats_listener";
      case PlatformMethod.removeStatsListener:
        return "remove_stats_listener";
      case PlatformMethod.getAudioDevicesList:
        return "get_audio_devices_list";
      case PlatformMethod.getCurrentAudioDevice:
        return "get_current_audio_device";
      case PlatformMethod.switchAudioOutput:
        return "switch_audio_output";
      case PlatformMethod.startAudioShare:
        return "start_audio_share";
      case PlatformMethod.stopAudioShare:
        return "stop_audio_share";
      case PlatformMethod.setAudioMixingMode:
        return "set_audio_mixing_mode";
      case PlatformMethod.pauseAudioShare:
        return "pause_audio_share";
      case PlatformMethod.playAudioShare:
        return "play_audio_share";
      case PlatformMethod.resumeAudioShare:
        return "resume_audio_share";
      case PlatformMethod.setAudioShareVolume:
        return "set_audio_share_volume";
      case PlatformMethod.audioSharePlaying:
        return "audio_share_playing";
      case PlatformMethod.audioShareCurrentTime:
        return "audio_share_current_time";
      case PlatformMethod.audioShareDuration:
        return "audio_share_duration";
      case PlatformMethod.getTrackSettings:
        return "get_track_settings";
      case PlatformMethod.destroy:
        return "destroy";
      case PlatformMethod.setPlaybackAllowedForTrack:
        return "set_playback_allowed_for_track";
      case PlatformMethod.enterPipMode:
        return "enter_pip_mode";
      case PlatformMethod.isPipActive:
        return "is_pip_active";
      case PlatformMethod.isPipAvailable:
        return "is_pip_available";
      case PlatformMethod.setSimulcastLayer:
        return "set_simulcast_layer";
      case PlatformMethod.changeRoleOfPeersWithRoles:
        return "change_role_of_peers_with_roles";
      case PlatformMethod.getLayer:
        return "get_layer";
      case PlatformMethod.getLayerDefinition:
        return "get_layer_definition";
      case PlatformMethod.setupPIP:
        return "setup_pip";
      case PlatformMethod.stopPIP:
        return "stop_pip";
      case PlatformMethod.startPIP:
        return "start_pip";
      case PlatformMethod.changeTrackPIP:
        return "change_track_pip";
      case PlatformMethod.changeTextPIP:
        return "change_text_pip";
      case PlatformMethod.destroyPIP:
        return "destroy_pip";
      case PlatformMethod.toggleMicMuteState:
        return "toggle_mic_mute_state";
      case PlatformMethod.toggleCameraMuteState:
        return "toggle_camera_mute_state";
      case PlatformMethod.captureSnapshot:
        return "capture_snapshot";
      case PlatformMethod.getAllLogs:
        return "get_all_logs";
      case PlatformMethod.getAuthTokenByRoomCode:
        return "get_auth_token_by_room_code";
      case PlatformMethod.captureImageAtMaxSupportedResolution:
        return "capture_image_at_max_supported_resolution";
      case PlatformMethod.isFlashSupported:
        return "is_flash_supported";
      case PlatformMethod.toggleFlash:
        return "toggle_flash";
      case PlatformMethod.getSessionMetadataForKey:
        return "get_session_metadata_for_key";
      case PlatformMethod.setSessionMetadataForKey:
        return "set_session_metadata_for_key";
      case PlatformMethod.addKeyChangeListener:
        return "add_key_change_listener";
      case PlatformMethod.removeKeyChangeListener:
        return "remove_key_change_listener";
      case PlatformMethod.start:
        return "start_hls_player";
      case PlatformMethod.stop:
        return "stop_hls_player";
      case PlatformMethod.pause:
        return "pause_hls_player";
      case PlatformMethod.resume:
        return "resume_hls_player";
      case PlatformMethod.seekToLivePosition:
        return "seek_to_live_position";
      case PlatformMethod.seekForward:
        return "seek_forward";
      case PlatformMethod.seekBackward:
        return "seek_backward";
      case PlatformMethod.setHLSPlayerVolume:
        return "set_hls_player_volume";
      case PlatformMethod.addHLSStatsListener:
        return "add_hls_stats_listener";
      case PlatformMethod.removeHLSStatsListener:
        return "remove_hls_stats_listener";
      case PlatformMethod.switchAudioOutputUsingiOSUI:
        return "switch_audio_output_using_ios_ui";
      case PlatformMethod.sendHLSTimedMetadata:
        return "send_hls_timed_metadata";
      case PlatformMethod.toggleAlwaysScreenOn:
        return "toggle_always_screen_on";
      case PlatformMethod.getRoomLayout:
        return "get_room_layout";
      default:
        return 'unknown';
    }
  }

  static PlatformMethod getMethodFromName(String name) {
    switch (name) {
      case 'join':
        return PlatformMethod.join;

      case 'leave':
        return PlatformMethod.leave;

      case 'on_leave':
        return PlatformMethod.onLeave;

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

      case 'send_broadcast_message':
        return PlatformMethod.sendBroadcastMessage;

      case 'send_direct_message':
        return PlatformMethod.sendDirectMessage;

      case 'send_group_message':
        return PlatformMethod.sendGroupMessage;

      case 'preview':
        return PlatformMethod.preview;

      case 'preview_for_role':
        return PlatformMethod.previewForRole;

      case "cancel_preview":
        return PlatformMethod.cancelPreview;

      case 'accept_change_role':
        return PlatformMethod.acceptChangeRole;

      case 'change_role':
        return PlatformMethod.changeRole;

      case 'change_role_of_peer':
        return PlatformMethod.changeRoleOfPeer;

      case 'get_roles':
        return PlatformMethod.getRoles;

      case 'on_change_track_state_request':
        return PlatformMethod.changeTrackState;

      case 'end_room':
        return PlatformMethod.endRoom;

      case 'remove_peer':
        return PlatformMethod.removePeer;

      case 'mute_room_audio_locally':
        return PlatformMethod.muteRoomAudioLocally;

      case 'un_mute_room_audio_locally':
        return PlatformMethod.unMuteRoomAudioLocally;

      case 'mute_room_video_locally':
        return PlatformMethod.muteRoomVideoLocally;

      case 'un_mute_room_video_locally':
        return PlatformMethod.unMuteRoomVideoLocally;

      case 'get_local_peer':
        return PlatformMethod.getLocalPeer;

      case 'get_remote_peers':
        return PlatformMethod.getRemotePeers;

      case 'get_peers':
        return PlatformMethod.getPeers;

      case 'start_hms_logger':
        return PlatformMethod.startHMSLogger;

      case 'remove_hms_logger':
        return PlatformMethod.removeHMSLogger;

      case 'change_track_state_for_role':
        return PlatformMethod.changeTrackStateForRole;

      case 'start_rtmp_or_recording':
        return PlatformMethod.startRtmpOrRecording;

      case 'stop_rtmp_and_recording':
        return PlatformMethod.stopRtmpAndRecording;

      case 'build':
        return PlatformMethod.build;

      case "get_room":
        return PlatformMethod.getRoom;

      case "change_metadata":
        return PlatformMethod.changeMetadata;

      case "set_volume":
        return PlatformMethod.setVolume;

      case "change_name":
        return PlatformMethod.changeName;

      case "hls_stop_streaming":
        return PlatformMethod.stopHlsStreaming;

      case "hls_start_streaming":
        return PlatformMethod.startHlsStreaming;

      case "start_screen_share":
        return PlatformMethod.startScreenShare;

      case "stop_screen_share":
        return PlatformMethod.stopScreenShare;

      case 'is_screen_share_active':
        return PlatformMethod.isScreenShareActive;
      case "get_track_by_id":
        return PlatformMethod.getTrackById;
      case "get_all_tracks":
        return PlatformMethod.getAllTracks;
      case "start_stats_listener":
        return PlatformMethod.startStatsListener;
      case "remove_stats_listener":
        return PlatformMethod.removeStatsListener;
      case "get_audio_devices_list":
        return PlatformMethod.getAudioDevicesList;
      case "get_current_audio_device":
        return PlatformMethod.getCurrentAudioDevice;
      case "switch_audio_output":
        return PlatformMethod.switchAudioOutput;
      case "start_audio_share":
        return PlatformMethod.startAudioShare;
      case "stop_audio_share":
        return PlatformMethod.stopAudioShare;
      case "set_audio_mixing_mode":
        return PlatformMethod.setAudioMixingMode;
      case "pause_audio_share":
        return PlatformMethod.pauseAudioShare;
      case "play_audio_share":
        return PlatformMethod.playAudioShare;
      case "resume_audio_share":
        return PlatformMethod.resumeAudioShare;
      case "set_audio_share_volume":
        return PlatformMethod.setAudioShareVolume;
      case "audio_share_playing":
        return PlatformMethod.audioSharePlaying;
      case "audio_share_current_time":
        return PlatformMethod.audioShareCurrentTime;
      case "audio_share_duration":
        return PlatformMethod.audioShareDuration;
      case "get_track_settings":
        return PlatformMethod.getTrackSettings;
      case "destroy":
        return PlatformMethod.destroy;
      case "set_playback_allowed_for_track":
        return PlatformMethod.setPlaybackAllowedForTrack;
      case "enter_pip_mode":
        return PlatformMethod.enterPipMode;
      case "is_pip_active":
        return PlatformMethod.isPipActive;
      case "is_pip_available":
        return PlatformMethod.isPipAvailable;
      case "set_simulcast_layer":
        return PlatformMethod.setSimulcastLayer;
      case "change_role_of_peers_with_roles":
        return PlatformMethod.changeRoleOfPeersWithRoles;
      case "get_layer":
        return PlatformMethod.getLayer;
      case "get_layer_definition":
        return PlatformMethod.getLayerDefinition;
      case "setup_pip":
        return PlatformMethod.setupPIP;
      case "change_track_pip":
        return PlatformMethod.changeTrackPIP;
      case "change_text_pip":
        return PlatformMethod.changeTextPIP;
      case "destroy_pip":
        return PlatformMethod.destroyPIP;
      case "toggle_mic_mute_state":
        return PlatformMethod.toggleMicMuteState;
      case "toggle_camera_mute_state":
        return PlatformMethod.toggleCameraMuteState;
      case "capture_snapshot":
        return PlatformMethod.captureSnapshot;
      case "get_all_logs":
        return PlatformMethod.getAllLogs;
      case "get_auth_token_by_room_code":
        return PlatformMethod.getAuthTokenByRoomCode;
      case "capture_image_at_max_supported_resolution":
        return PlatformMethod.captureImageAtMaxSupportedResolution;
      case "is_flash_supported":
        return PlatformMethod.isFlashSupported;
      case "toggle_flash":
        return PlatformMethod.toggleFlash;
      case "get_session_metadata_for_key":
        return PlatformMethod.getSessionMetadataForKey;
      case "set_session_metadata_for_key":
        return PlatformMethod.setSessionMetadataForKey;
      case "add_key_change_listener":
        return PlatformMethod.addKeyChangeListener;
      case "remove_key_change_listener":
        return PlatformMethod.removeKeyChangeListener;
      case "start_hls_player":
        return PlatformMethod.start;
      case "stop_hls_player":
        return PlatformMethod.stop;
      case "pause_hls_player":
        return PlatformMethod.pause;
      case "resume_hls_player":
        return PlatformMethod.resume;
      case "seek_to_live_position":
        return PlatformMethod.seekToLivePosition;
      case "seek_forward":
        return PlatformMethod.seekForward;
      case "seek_backward":
        return PlatformMethod.seekBackward;
      case "set_hls_player_volume":
        return PlatformMethod.setHLSPlayerVolume;
      case "add_hls_stats_listener":
        return PlatformMethod.addHLSStatsListener;
      case "remove_hls_stats_listener":
        return PlatformMethod.removeHLSStatsListener;
      case "switch_audio_output_using_ios_ui":
        return PlatformMethod.switchAudioOutputUsingiOSUI;
      case "send_hls_timed_metadata":
        return PlatformMethod.sendHLSTimedMetadata;
      case "toggle_always_screen_on":
        return PlatformMethod.toggleAlwaysScreenOn;
      case "get_room_layout":
        return PlatformMethod.getRoomLayout;
      default:
        return PlatformMethod.unknown;
    }
  }
}
