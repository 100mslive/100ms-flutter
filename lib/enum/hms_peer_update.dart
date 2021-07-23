enum HMSPeerUpdate {
  peerJoined,
  peerLeft,
  peerKnocked,
  audioToggled,
  videoToggled,
  roleUpdated,
  defaultUpdate
}

extension HMSPeerUpdateValues on HMSPeerUpdate {
  static HMSPeerUpdate getHMSPeerUpdateFromName(String name) {
    switch (name) {
      case 'peerJoined':
        return HMSPeerUpdate.peerJoined;
      case 'peerLeft':
        return HMSPeerUpdate.peerLeft;
      case 'peerKnocked':
        return HMSPeerUpdate.peerKnocked;
      case 'audioToggled':
        return HMSPeerUpdate.audioToggled;
      case 'videoToggled':
        return HMSPeerUpdate.videoToggled;
      case 'roleUpdated':
        return HMSPeerUpdate.roleUpdated;
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

      case HMSPeerUpdate.peerKnocked:
        return 'peerKnocked';

      case HMSPeerUpdate.audioToggled:
        return 'audioToggled';

      case HMSPeerUpdate.videoToggled:
        return 'videoToggled';

      case HMSPeerUpdate.roleUpdated:
        return 'roleUpdated';

      case HMSPeerUpdate.defaultUpdate:
        return 'defaultUpdate';
    }
  }
}