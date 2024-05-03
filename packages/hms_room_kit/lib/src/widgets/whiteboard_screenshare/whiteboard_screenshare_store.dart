library;

///Package imports
import 'package:flutter/material.dart';

///[WhiteboardScreenshareStore] is a store that stores the state of the whiteboard screenshare
class WhiteboardScreenshareStore extends ChangeNotifier {
  bool isFullScreen = false;

  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    notifyListeners();
  }
}
