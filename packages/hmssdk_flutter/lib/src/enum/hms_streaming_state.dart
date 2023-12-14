///Enum for the streaming state in room
enum HMSStreamingState {
  none,

  starting,

  started,

  stopped,

  failed,
}

extension HMSStreamingStateValues on HMSStreamingState {
  static HMSStreamingState getStreamingStateFromName(String name) {
    switch (name) {
      case 'NONE':
        return HMSStreamingState.none;
      case 'STARTING':
        return HMSStreamingState.starting;
      case 'STARTED':
        return HMSStreamingState.started;
      case 'STOPPED':
        return HMSStreamingState.stopped;
      case 'FAILED':
        return HMSStreamingState.failed;
      default:
        return HMSStreamingState.none;
    }
  }

  static String getNameFromStreamingState(HMSStreamingState state) {
    switch (state) {
      case HMSStreamingState.none:
        return 'NONE';

      case HMSStreamingState.starting:
        return 'STARTING';

      case HMSStreamingState.started:
        return 'STARTED';

      case HMSStreamingState.stopped:
        return 'STOPPED';

      case HMSStreamingState.failed:
        return 'FAILED';
    }
  }
}
