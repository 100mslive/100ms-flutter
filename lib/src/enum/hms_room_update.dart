enum HMSRoomUpdate {
  HMSRoomUpdateRoomTypeChanged,
  HMSRoomUpdateMetaDataUpdated,
  unknown
}

extension HMSRoomUpdateValues on HMSRoomUpdate {
  static HMSRoomUpdate getHMSRoomUpdateFromName(String name) {
    switch (name) {
      default:
        return HMSRoomUpdate.unknown;
    }
  }

  static String getValueFromHMSRoomUpdate(HMSRoomUpdate hmsRoomUpdate) {
    switch (hmsRoomUpdate) {
      case HMSRoomUpdate.HMSRoomUpdateRoomTypeChanged:
        return 'HMSRoomUpdateRoomTypeChanged';
      case HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated:
        return 'HMSRoomUpdate.HMSRoomUpdateMetaDataUpdated';
      case HMSRoomUpdate.unknown:
        return 'unknown';
    }
  }
}
