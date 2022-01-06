enum HMSRoomUpdate {
  roomMuted,
  roomUnmuted,
  serverRecordingStateUpdated,
  browserRecordingStateUpdated,
  rtmpStreamingStateUpdated,
  hlsStreamingStateUpdated,
  defaultUpdate
}

extension HMSRoomUpdateValues on HMSRoomUpdate {
  static HMSRoomUpdate getHMSRoomUpdateFromName(String name) {
    switch (name) {
      case 'roomMuted':
        return HMSRoomUpdate.roomMuted;

      case 'roomUnmuted':
        return HMSRoomUpdate.roomUnmuted;

      case 'serverRecordingStateUpdated':
        return HMSRoomUpdate.serverRecordingStateUpdated;

      case 'browserRecordingStateUpdated':
        return HMSRoomUpdate.browserRecordingStateUpdated;

      case 'rtmpStreamingStateUpdated':
        return HMSRoomUpdate.rtmpStreamingStateUpdated;

      case 'hlsStreamingStateUpdated':
        return HMSRoomUpdate.hlsStreamingStateUpdated;

      default:
        return HMSRoomUpdate.defaultUpdate;
    }
  }

  static String getValueFromHMSRoomUpdate(HMSRoomUpdate hmsRoomUpdate) {
    switch (hmsRoomUpdate) {
      case HMSRoomUpdate.roomMuted:
        return 'roomMuted';

      case HMSRoomUpdate.roomUnmuted:
        return 'roomUnmuted';

      case HMSRoomUpdate.serverRecordingStateUpdated:
        return 'serverRecordingStateUpdated';

      case HMSRoomUpdate.browserRecordingStateUpdated:
        return 'browserRecordingStateUpdated';

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        return 'rtmpStreamingStateUpdated';

      case HMSRoomUpdate.hlsStreamingStateUpdated:
        return 'hlsStreamingStateUpdated';

      default:
        return 'defaultUpdate';
    }
  }
}
