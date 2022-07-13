///PeerUpdates in a room.
enum HMSPeerUpdate {
  ///When new peer joins the room.
  peerJoined,

  ///When peer left the room.
  peerLeft,

  ///when peer's role is changed
  roleUpdated,

  ///when peer's metadata changed
  metadataChanged,

  ///when peer's name change
  nameChanged,
  defaultUpdate,

  ///Peer's network quality updates
  networkQualityUpdated
}

extension HMSPeerUpdateValues on HMSPeerUpdate {
  static HMSPeerUpdate getHMSPeerUpdateFromName(String name) {
    switch (name) {
      case 'peerJoined':
        return HMSPeerUpdate.peerJoined;
      case 'peerLeft':
        return HMSPeerUpdate.peerLeft;
      case 'roleUpdated':
        return HMSPeerUpdate.roleUpdated;
      case 'metadataChanged':
        return HMSPeerUpdate.metadataChanged;
      case 'nameChanged':
        return HMSPeerUpdate.nameChanged;
      case 'networkQualityUpdated':
        return HMSPeerUpdate.networkQualityUpdated;
      case 'defaultUpdate':
        return HMSPeerUpdate.defaultUpdate;
      default:
        return HMSPeerUpdate.defaultUpdate;
    }
  }

  static String getNameFromHMSPeerUpdate(HMSPeerUpdate hmsPeerUpdate) {
    switch (hmsPeerUpdate) {
      case HMSPeerUpdate.peerJoined:
        return 'peerJoined';

      case HMSPeerUpdate.peerLeft:
        return 'peerLeft';

      case HMSPeerUpdate.roleUpdated:
        return 'roleUpdated';

      case HMSPeerUpdate.metadataChanged:
        return 'metadataChanged';

      case HMSPeerUpdate.nameChanged:
        return 'nameChanged';

      case HMSPeerUpdate.defaultUpdate:
        return 'defaultUpdate';
      case HMSPeerUpdate.networkQualityUpdated:
        return 'networkQualityUpdated';
    }
  }
}
