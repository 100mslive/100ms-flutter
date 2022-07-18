//enum to set the meeting flow
enum MeetingFlow { meeting, hlsStreaming, none }

extension MeetingFlowValues on MeetingFlow {
  static MeetingFlow getMeetingFlowfromName(String name) {
    switch (name) {
      case 'meeting':
        return MeetingFlow.meeting;
      case 'preview':
        return MeetingFlow.meeting;
      case 'streaming':
        return MeetingFlow.hlsStreaming;
      default:
        return MeetingFlow.none;
    }
  }

  static String getNameFromMeetingFlow(MeetingFlow flow) {
    switch (flow) {
      case MeetingFlow.meeting:
        return 'meeting';
      case MeetingFlow.hlsStreaming:
        return 'streaming';
      case MeetingFlow.none:
        return 'none';
    }
  }
}
