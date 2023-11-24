import 'package:flutter/widgets.dart';

class MeetingNavigationVisibilityController extends ChangeNotifier {
  bool showControls = true;

  void toggleControlsVisibility() {
    showControls = !showControls;
    notifyListeners();
  }
}
