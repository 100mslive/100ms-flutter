library;

///Dart imports
import 'dart:async';
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

///[HLSPlayerStore] is a store that stores the state of the HLS Player
class HLSPlayerStore extends ChangeNotifier
    implements HMSHLSPlaybackEventsListener {
  ///This variable stores whether the application is in full screen or not
  bool isFullScreen = false;

  ///This variable stores whether the video is playing or not
  bool isStreamPlaying = false;

  ///This variable stores whether the buttons are visible or not
  bool areStreamControlsVisible = true;

  ///This variable stores whether the captions are enabled or not
  bool isCaptionEnabled = false;

  ///This variable stores whether the captions are supported or not
  bool areCaptionsSupported = false;

  ///This variable stores whether the chat is opened or not
  ///The initial value is taken from the [HMSRoomLayout.chatData]
  bool isChatOpened = (HMSRoomLayout.chatData?.isOpenInitially ?? false) &&
      (HMSRoomLayout.chatData?.isOverlay ?? false);

  ///This variable stores whether the timer is active or not
  ///
  ///This is done to avoid multiple timers running at the same time
  bool _isTimerActive = false;

  ///This variable stores whether there is some error in playing stream
  bool isPlayerFailed = false;

  ///HLS Player Stats

  HMSHLSPlayerStats? hlsPlayerStats;

  ///[hlsPlayerSize] stores the resolution of HLS Stream
  Size hlsPlayerSize = Size(1, 1);

  bool isHLSStatsEnabled = false;

  HMSHLSPlaybackState playerPlaybackState = HMSHLSPlaybackState.PLAYING;

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
        notifyListeners();
      }
      _isTimerActive = false;
    });
  }

  ///[toggleFullScreen] toggles the full screen mode
  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    notifyListeners();
  }

  ///This method sets the [isStreamPlaying] to true or false
  void setStreamPlaying(bool isStreamPlaying) {
    this.isStreamPlaying = isStreamPlaying;
    if (isStreamPlaying) {
      if (!_isTimerActive) {
        startTimerToHideButtons();
      }
      return;
    } else {
      areStreamControlsVisible = true;
      isFullScreen = false;
    }
    notifyListeners();
  }

  ///This method toggles the visibility of the chat
  void toggleIsChatOpened() {
    isChatOpened = !isChatOpened;
    notifyListeners();
  }

  ///This method toggles the visibility of the captions
  void toggleCaptions() {
    isCaptionEnabled = !isCaptionEnabled;
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

  ///[areClosedCaptionsSupported] checks if the closed captions are supported or not
  void areClosedCaptionsSupported() async {
    areCaptionsSupported =
        await HMSHLSPlayerController.areClosedCaptionsSupported();
    notifyListeners();
  }

  void setHLSPlayerStats(bool value) {
    isHLSStatsEnabled = value;
    if (!value) {
      HMSHLSPlayerController.removeHLSStatsListener();
    } else {
      HMSHLSPlayerController.addHLSStatsListener();
    }
    notifyListeners();
  }

  @override
  void onCue({required HMSHLSCue hlsCue}) {}

  @override
  void onHLSError({required HMSException hlsException}) {}

  @override
  void onHLSEventUpdate({required HMSHLSPlayerStats playerStats}) {
    log("onHLSEventUpdate-> bitrate:${playerStats.averageBitrate} buffered duration: ${playerStats.bufferedDuration}");
    hlsPlayerStats = playerStats;
    notifyListeners();
  }

  @override
  void onPlaybackFailure({required String? error}) {
    log("Playback failure $error");
    isPlayerFailed = true;
    notifyListeners();
  }

  @override
  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {
    log("Playback state changed to ${playbackState.name}");
    playerPlaybackState = playbackState;
    if (playerPlaybackState == HMSHLSPlaybackState.PLAYING) {
      isPlayerFailed = false;
      areClosedCaptionsSupported();
    }
    notifyListeners();
  }

  @override
  void onVideoSizeChanged({required Size size}) {
    log("onVideoSizeChanged -> height:${size.height} width:${size.width}");
    hlsPlayerSize = size;
    notifyListeners();
  }
}
