enum HMSTrackUpdate {
  trackAdded,
  trackRemoved,
  trackMuted,
  trackUnMuted,
  trackDescriptionChanged,
  trackDegraded,
  trackRestored,
  defaultUpdate
}

extension HMSTrackUpdateValues on HMSTrackUpdate {
  static HMSTrackUpdate getHMSTrackUpdateFromName(String name) {
    switch (name) {
      case 'trackAdded':
        return HMSTrackUpdate.trackAdded;
      case 'trackRemoved':
        return HMSTrackUpdate.trackRemoved;
      case 'trackMuted':
        return HMSTrackUpdate.trackMuted;
      case 'trackUnMuted':
        return HMSTrackUpdate.trackUnMuted;
      case 'trackDescriptionChanged':
        return HMSTrackUpdate.trackDescriptionChanged;
      case 'trackDegraded':
        return HMSTrackUpdate.trackDegraded;
      case 'trackRestored':
        return HMSTrackUpdate.trackRestored;
      case 'defaultUpdate':
        return HMSTrackUpdate.defaultUpdate;
      default:
        return HMSTrackUpdate.defaultUpdate;
    }
  }

  static String getNameFromHMSTrackUpdate(HMSTrackUpdate hmsTrackUpdate) {
    switch (hmsTrackUpdate) {
      case HMSTrackUpdate.trackAdded:
        return 'trackAdded';

      case HMSTrackUpdate.trackRemoved:
        return 'trackRemoved';

      case HMSTrackUpdate.trackMuted:
        return 'trackMuted';

      case HMSTrackUpdate.trackUnMuted:
        return 'trackUnMuted';

      case HMSTrackUpdate.trackDescriptionChanged:
        return 'trackDescriptionChanged';

      case HMSTrackUpdate.trackDegraded:
        return 'trackDegraded';

      case HMSTrackUpdate.trackRestored:
        return 'trackRestored';

      case HMSTrackUpdate.defaultUpdate:
        return 'defaultUpdate';
    }
  }
}
