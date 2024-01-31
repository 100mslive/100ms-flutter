import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll.dart';

abstract class HMSPollListener {
  void onPollUpdate(
      {required HMSPoll poll, required HMSPollUpdateType pollUpdateType});
}
