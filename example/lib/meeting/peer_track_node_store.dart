import 'package:flutter/cupertino.dart';

class PeerTrackNodeStore extends ChangeNotifier {
  void handRaise() {
    notifyListeners();
  }
}
