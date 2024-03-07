///Dart imports
library;

import 'dart:async';

///Package imports
import 'package:flutter/widgets.dart';

class MeetingNavigationVisibilityController extends ChangeNotifier {
  bool showControls = true;

  ///This variable stores whether the timer is active or not
  ///
  ///This is done to avoid multiple timers running at the same time
  bool _isTimerActive = false;

  ///This method toggles the visibility of the buttons
  void toggleControlsVisibility() {
    showControls = !showControls;

    ///If the controls are now visible and
    ///If the timer is not active, we start the timer
    if (showControls && !_isTimerActive) {
      startTimerToHideButtons();
    }
    notifyListeners();
  }

  ///This method starts a timer for 5 seconds and then hides the buttons
  void startTimerToHideButtons() {
    _isTimerActive = true;
    Timer(const Duration(seconds: 5), () {
      showControls = false;
      _isTimerActive = false;
      notifyListeners();
    });
  }
}
