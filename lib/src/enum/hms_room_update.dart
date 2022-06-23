enum HMSRoomUpdate {
  ///When room is muted
  roomMuted,

  ///When room is unmuted
  roomUnmuted,

  ///When server recording state is updated
  serverRecordingStateUpdated,

  ///When RTMP is started or stopped
  rtmpStreamingStateUpdated,

  ///When HLS is started or stopped
  hlsStreamingStateUpdated,

  ///When hls recording state is updated
  hlsRecordingStateUpdated,

  ///When browser recording state is changed
  browserRecordingStateUpdated,

  ///When room name changed
  RoomNameUpdated,

  ///Default Update
  defaultUpdate
}

extension HMSRoomUpdateValues on HMSRoomUpdate {
  static HMSRoomUpdate getHMSRoomUpdateFromName(String name) {
    switch (name) {
      case 'room_muted':
        return HMSRoomUpdate.roomMuted;

      case 'room_unmuted':
        return HMSRoomUpdate.roomUnmuted;

      case 'server_recording_state_updated':
        return HMSRoomUpdate.serverRecordingStateUpdated;

      case 'browser_recording_state_updated':
        return HMSRoomUpdate.browserRecordingStateUpdated;

      case 'rtmp_streaming_state_updated':
        return HMSRoomUpdate.rtmpStreamingStateUpdated;

      case 'hls_streaming_state_updated':
        return HMSRoomUpdate.hlsStreamingStateUpdated;

      case 'hls_recording_state_updated':
        return HMSRoomUpdate.hlsRecordingStateUpdated;

      case "room_name_updated":
        return HMSRoomUpdate.RoomNameUpdated;

      default:
        return HMSRoomUpdate.defaultUpdate;
    }
  }

  static String getValueFromHMSRoomUpdate(HMSRoomUpdate hmsRoomUpdate) {
    switch (hmsRoomUpdate) {
      case HMSRoomUpdate.roomMuted:
        return 'room_muted';

      case HMSRoomUpdate.roomUnmuted:
        return 'room_unmuted';

      case HMSRoomUpdate.serverRecordingStateUpdated:
        return 'server_recording_state_updated';

      case HMSRoomUpdate.browserRecordingStateUpdated:
        return 'browser_recording_state_updated';

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        return 'rtmp_streaming_state_updated';

      case HMSRoomUpdate.hlsStreamingStateUpdated:
        return 'hls_streaming_state_updated';

      case HMSRoomUpdate.hlsRecordingStateUpdated:
        return 'hls_recording_state_updated';

      case HMSRoomUpdate.RoomNameUpdated:
        return "room_name_updated";

      default:
        return 'defaultUpdate';
    }
  }
}
