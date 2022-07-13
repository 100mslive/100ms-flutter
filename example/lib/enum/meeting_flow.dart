//enum to set the meeting flow
enum MeetingFlow { join, hlsStreaming, none }

extension MeetingFlowValues on MeetingFlow {
  static MeetingFlow getMeetingFlowfromName(String name) {
    switch (name) {
      case 'meeting':
        return MeetingFlow.join;
      case 'preview':
        return MeetingFlow.join;
      case 'hls-streaming':
        return MeetingFlow.hlsStreaming;
      default:
        return MeetingFlow.none;
    }
  }

  static String getNameFromMeetingFlow(MeetingFlow flow) {
    switch (flow) {
      case MeetingFlow.join:
        return 'meeting';
      case MeetingFlow.hlsStreaming:
        return 'hls-streaming';
      case MeetingFlow.none:
        return 'none';
    }
  }
}
