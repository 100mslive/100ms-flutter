enum HMSRoomUpdate {
  HMSRoomUpdateRoomTypeChanged,
  HMSRoomUpdateMetaDataUpdated,
  RTMP_STREAMING_STATE_UPDATED,
  HLS_STREAMING_STATE_UPDATED,
  BROWSER_RECORDING_STATE_UPDATED,
  unknown
}

extension HMSRoomUpdateValues on HMSRoomUpdate {
  static HMSRoomUpdate getHMSRoomUpdateFromName(String name) {
    switch (name) {
      case 'HMSRoomUpdateRoomTypeChanged':
        return HMSRoomUpdate.HMSRoomUpdateRoomTypeChanged;
      case 'HMSRoomUpdateMetaDataUpdated':
        return HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated;
      case 'RTMP_STREAMING_STATE_UPDATED':
        return HMSRoomUpdate.RTMP_STREAMING_STATE_UPDATED;
      case 'HLS_STREAMING_STATE_UPDATED':
        return HMSRoomUpdate.HLS_STREAMING_STATE_UPDATED;
      case 'BROWSER_RECORDING_STATE_UPDATED':
        return HMSRoomUpdate.BROWSER_RECORDING_STATE_UPDATED;
      default:
        return HMSRoomUpdate.unknown;
    }
  }

  static String getValueFromHMSRoomUpdate(HMSRoomUpdate hmsRoomUpdate) {
    switch (hmsRoomUpdate) {
      case HMSRoomUpdate.HMSRoomUpdateRoomTypeChanged:
        return 'HMSRoomUpdateRoomTypeChanged';
      case HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated:
        return 'HMSRoomUpdateMetaDataUpdated';
      case HMSRoomUpdate.unknown:
        return 'unknown';
      case HMSRoomUpdate.RTMP_STREAMING_STATE_UPDATED:
        return 'RTMP_STREAMING_STATE_UPDATED';
      case HMSRoomUpdate.HLS_STREAMING_STATE_UPDATED:
        return 'HLS_STREAMING_STATE_UPDATED';
      case HMSRoomUpdate.BROWSER_RECORDING_STATE_UPDATED:
        return 'BROWSER_RECORDING_STATE_UPDATED';
    }
  }
}
