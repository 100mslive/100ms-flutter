import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class HLSPlayerStore extends ChangeNotifier {
  ///This variable stores whether the application is in full screen or not
  bool isFullScreen = false;

  ///This variable stores whether the video is playing or not
  bool isStreamPlaying = true;

  ///This variable stores whether the buttons are visible or not
  bool areStreamControlsVisible = true;

  ///This variable stores whether the timer is active or not
  ///
  ///This is done to avoid multiple timers running at the same time
  bool _isTimerActive = false;

  ///This method starts a timer for 5 seconds and then hides the buttons
  ///
  ///[isStreamPlaying] is used to check if the video is playing or not
  ///If video is paused we don't hide the buttons
  ///In other case we hide th buttons after 5 seconds
  void startTimerToHideButtons() {
    _isTimerActive = true;
    Timer(const Duration(seconds: 5), () {
      if (isStreamPlaying) {
        areStreamControlsVisible = false;
        _isTimerActive = false;
        notifyListeners();
      }
    });
  }

  ///This method toggles the fullscreen mode of the app
  ///
  ///[isFullScreen] is used to check if the app is in fullscreen mode or not
  ///The application is in full screen if it's in landscape mode
  ///
  ///If the app is in fullscreen mode we set the orientation to portraitUp
  ///and set the system UI mode to manual and set the overlays to bottom and top i.e. the status bar and the navigation bar
  ///
  ///Similarly if the app is not in fullscreen mode we set the orientation to landscapeRight and landscapeLeft
  ///and set the system UI mode to immersive i.e. the status bar and the navigation bar are hidden
  void toggleFullScreen(BuildContext context) {
    isFullScreen = MediaQuery.of(context).orientation == Orientation.landscape;
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
    isFullScreen = !isFullScreen;
    notifyListeners();
  }

  ///This method toggles the visibility of the buttons
  ///
  ///If the buttons are not visible we set the [areStreamControlsVisible] to true
  ///and start a timer to hide the buttons if the video is playing and another timer is not active already
  ///
  ///If the buttons are visible we set the [areStreamControlsVisible] to false
  ///and notify the listeners
  void toggleButtonsVisibility() {
    if (!areStreamControlsVisible) {
      areStreamControlsVisible = true;
      notifyListeners();
      if (!_isTimerActive) {
        startTimerToHideButtons();
      }
    } else {
      areStreamControlsVisible = false;
      notifyListeners();
    }
  }

  ///This method toggles the play/pause of the video
  ///
  ///If [isStreamPlaying] is true we pause the video and set [areStreamControlsVisible] to true
  ///This is done to keep showing the controls until the user plays the video again
  ///The controls get hidden if you touch the screen again.
  ///
  void togglePlayPause() {
    if (isStreamPlaying) {
      HMSHLSPlayerController.pause();
      areStreamControlsVisible = true;
    } else {
      HMSHLSPlayerController.resume();
      startTimerToHideButtons();
    }
    isStreamPlaying = !isStreamPlaying;
    notifyListeners();
  }
}
