///Project imports
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll.dart';

///100ms HMSPollListener
///
///[HMSPollListener] provides callback related to poll state changes. If the application uses polls and quizzes then it is required
///to implement [HMSPollListener] to get updates related to polls.
abstract class HMSPollListener {
  ///This is called whenever there are any changes related to the poll
  ///i.e whether a poll is started or stopped or someone answered the poll
  ///
  /// - Parameters:
  ///   - poll: the poll object for which upgrade is triggered.
  ///   - pollUpdateType: pollUpdateType is an enum of [HMSPollUpdateType]
  void onPollUpdate(
      {required HMSPoll poll, required HMSPollUpdateType pollUpdateType});
}
