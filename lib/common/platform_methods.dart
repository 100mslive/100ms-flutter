enum PlatformMethods { joinMeeting, leaveMeeting }

extension PlatformMethodValues on PlatformMethods {
  static String getName(PlatformMethods method) {
    switch (method) {
      case PlatformMethods.joinMeeting:
        return 'join_meeting';

      case PlatformMethods.leaveMeeting:
        return 'leave_meeting';
    }
  }
}
