///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[HMSPollStore] is used to notify updates for the poll state
///
///This is useful in updating polls UI based on state in realtime
///without rebuilding the whole UI
class HMSPollStore extends ChangeNotifier {
  HMSPoll poll;

  HMSPollStore({required this.poll});

  ///Here we update the poll object with the new object
  ///and notify the listeners
  void updateState(HMSPoll poll) {
    this.poll = poll;
    notifyListeners();
  }
}
