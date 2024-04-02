///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[ParticipantsStore] is a store that is used to store the participant
///It is used to update the participant list
class ParticipantsStore extends ChangeNotifier {
  late HMSPeer peer;

  ParticipantsStore({required this.peer});

  void updatePeer(HMSPeer newPeer) {
    peer = newPeer;
    notifyListeners();
  }
}
