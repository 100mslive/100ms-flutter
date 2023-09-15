import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

class HLSPlayerStore extends ChangeNotifier {
  ///This variable stores whether the application is in full screen or not
  bool isFullScreen = false;

  ///This variable stores whether the video is playing or not
  bool isStreamPlaying = false;

  ///This variable stores whether the buttons are visible or not
  bool areStreamControlsVisible = true;

  ///This variable stores whether the chat is opened or not
  ///The initial value is taken from the [HMSRoomLayout.chatData]
  bool isChatOpened = (HMSRoomLayout.chatData?.isOpenInitially ?? false) &&
      (HMSRoomLayout.chatData?.isOverlay ?? false);

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
    Timer(const Duration(seconds: 3), () {
      if (isStreamPlaying) {
        areStreamControlsVisible = false;
        notifyListeners();
      }
      _isTimerActive = false;
    });
  }

  void setStreamPlaying(bool isStreamPlaying) {
    this.isStreamPlaying = isStreamPlaying;
    if (isStreamPlaying) {
      if (!_isTimerActive) {
        startTimerToHideButtons();
      }
      return;
    } else {
      areStreamControlsVisible = true;
    }
    notifyListeners();
  }

  void toggleIsChatOpened() {
    isChatOpened = !isChatOpened;
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
    if (isStreamPlaying) {
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
  }
}
