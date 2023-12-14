///Enum for the recording state in room
enum HMSRecordingState {
  none,

  starting,

  started,

  paused,

  resumed,

  stopped,

  failed,
}

extension HMSRecordingStateValues on HMSRecordingState {
  static HMSRecordingState getRecordingStateFromName(String name) {
    switch (name) {
      case 'NONE':
        return HMSRecordingState.none;
      case 'STARTING':
        return HMSRecordingState.starting;
      case 'STARTED':
        return HMSRecordingState.started;
      case 'PAUSED':
        return HMSRecordingState.paused;
      case 'RESUMED':
        return HMSRecordingState.resumed;
      case 'STOPPED':
        return HMSRecordingState.stopped;
      case 'FAILED':
        return HMSRecordingState.failed;
      default:
        return HMSRecordingState.none;
    }
  }

  static String getNameFromRecordingState(HMSRecordingState state) {
    switch (state) {
      case HMSRecordingState.none:
        return 'NONE';

      case HMSRecordingState.starting:
        return 'STARTING';

      case HMSRecordingState.started:
        return 'STARTED';

      case HMSRecordingState.paused:
        return 'PAUSED';

      case HMSRecordingState.resumed:
        return 'RESUMED';

      case HMSRecordingState.stopped:
        return 'STOPPED';

      case HMSRecordingState.failed:
        return 'FAILED';
    }
  }
}
