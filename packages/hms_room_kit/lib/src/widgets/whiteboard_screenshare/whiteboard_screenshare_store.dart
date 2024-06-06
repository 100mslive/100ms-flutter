library;

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[WhiteboardScreenshareStore] is a store that stores the state of the whiteboard screenshare
class WhiteboardScreenshareStore extends ChangeNotifier {
  MeetingStore meetingStore;
  bool isFullScreen = false;

  WhiteboardScreenshareStore({required this.meetingStore}) {
    isFullScreen = meetingStore.isScreenshareWhiteboardFullScreen;
  }

  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    meetingStore.isScreenshareWhiteboardFullScreen = isFullScreen;
    notifyListeners();
  }
}
