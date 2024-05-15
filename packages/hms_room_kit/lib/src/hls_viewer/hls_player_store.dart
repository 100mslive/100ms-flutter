library;

///Dart imports
import 'dart:async';
import 'dart:developer';
import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:collection/collection.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

///[HLSPlayerStore] is a store that stores the state of the HLS Player
class HLSPlayerStore extends ChangeNotifier
    implements HMSHLSPlaybackEventsListener {
  ///[timeBeforeLive] is the time to show the go live button
  ///It is set to 10 seconds for Android and 1 second for iOS
  ///Basically `Go Live` will only be shown if the distance from live is greater than this value
  final int timeBeforeLive = Platform.isAndroid ? 10000 : 5000;

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

  ///This variable stores whether the stream is at live edge or not
  bool isLive = true;

  ///This variable stores the time from live edge
  Duration timeFromLive = Duration(milliseconds: 0);

  ///This variable stores the stream rolling window time
  Duration rollingWindow = Duration(milliseconds: 0);

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

  ///This variable stores whether the HLS Stats are enabled or not
  bool isHLSStatsEnabled = false;

  ///This variable stores the player playback state
  HMSHLSPlaybackState playerPlaybackState = HMSHLSPlaybackState.PLAYING;

  ///This variable handles the timer for fetching the stream properties
  Timer? _timer;

  String? caption;

  Map<String, HMSHLSLayer> layerMap = {};

  HMSHLSLayer? selectedLayer;

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

  ///[toggleStreamPlaying] toggles the stream playing
  void toggleStreamPlaying() {
    if (isStreamPlaying) {
      HMSHLSPlayerController.pause();
    } else {
      HMSHLSPlayerController.resume();
    }
    isStreamPlaying = !isStreamPlaying;
    notifyListeners();
  }

  ///This method toggles the visibility of the chat
  void toggleIsChatOpened() {
    isChatOpened = !isChatOpened;
    notifyListeners();
  }

  ///This method toggles the visibility of the captions
  void toggleCaptions() {
    if (isCaptionEnabled) {
      HMSHLSPlayerController.disableClosedCaptions();
    } else {
      HMSHLSPlayerController.enableClosedCaptions();
    }
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

    ///If isCaptionEnabled is true we enable the captions
    if (isCaptionEnabled) {
      HMSHLSPlayerController.enableClosedCaptions();
    }
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

  ///[startTimer] starts a timer to get the stream properties every 3 seconds
  void startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      getStreamProperties();
    });
  }

  ///[cancelTimer] cancels the timer
  void cancelTimer() {
    _timer?.cancel();
  }

  ///[getStreamProperties] gets the stream properties
  void getStreamProperties() async {
    HLSStreamProperties result =
        await HMSHLSPlayerController.getStreamProperties();

    ///If the [rollingWindowTime] is not null we set the [rollingWindow] to the value of [rollingWindowTime]
    ///If the [streamDuration] is not null we set the [rollingWindow] to the value of [streamDuration]
    ///If both are null we set the [rollingWindow] to 0
    if (result.rollingWindowTime != null && result.streamDuration == null) {
      rollingWindow = Duration(seconds: result.rollingWindowTime!.toInt());
    } else if (result.streamDuration != null) {
      rollingWindow = Duration(seconds: result.streamDuration!.toInt());
    }
    notifyListeners();
  }

  ///[getHLSLayers] gets the HLS Layers
  void getHLSLayers() async {
    var layers = await HMSHLSPlayerController.getHLSLayers();
    int layersSize = layers.length;
    if (layersSize > 0) {
      ///This sorts the layers in descending order of bitrate
      layers.sort((a, b) => (b.bitrate ?? 0).compareTo(a.bitrate ?? 0));

      ///This checks for layer with zero or null bitrate and sets it to
      ///"AUTO" key
      if (layers[layersSize - 1].bitrate == 0 ||
          layers[layersSize - 1].bitrate == null) {
        layerMap["AUTO"] = layers[layersSize - 1];
      }

      ///This picks up the highest bitrate layer from the sorted layers
      layerMap["HIGH"] = layers[0];

      ///This picks up the mid layer from the sorted layers
      layerMap["MEDIUM"] = layers[layersSize ~/ 2];

      ///This picks up the lowest bitrate layer from the sorted layers
      if (layersSize > 1) {
        layerMap["LOW"] = layers[layersSize - 2];
      }
    }
  }

  ///[getCurrentHLSLayer] gets the current HLS Layer
  void getCurrentHLSLayer() async {
    var layer = await HMSHLSPlayerController.getCurrentHLSLayer();

    ///Here we are finding the layer with the same bitrate as the current layer
    var layerSelected = layerMap.entries.firstWhereIndexedOrNull(
        (index, element) => (element.value.bitrate == layer?.bitrate));

    ///If the layer is found we set the selected layer to that layer
    if (layerSelected != null) {
      selectedLayer = layerSelected.value;
    }
    notifyListeners();
  }

  ///[setHLSLayer] sets the HLS Layer
  void setHLSLayer(HMSHLSLayer hmsHLSLayer) async {
    selectedLayer = hmsHLSLayer;
    HMSHLSPlayerController.setHLSLayer(hmsHLSLayer: hmsHLSLayer);
    notifyListeners();
  }

  @override
  void onCue({required HMSHLSCue hlsCue}) {}

  @override
  void onHLSError({required HMSException hlsException}) {}

  @override
  void onHLSEventUpdate({required HMSHLSPlayerStats playerStats}) {
    log("onHLSEventUpdate-> distanceFromLive: ${playerStats.distanceFromLive}ms buffered duration: ${playerStats.bufferedDuration}ms bitrate: ${playerStats.averageBitrate}");
    isLive = playerStats.distanceFromLive < timeBeforeLive;
    timeFromLive = Duration(milliseconds: playerStats.distanceFromLive.toInt());
    hlsPlayerStats = playerStats;
    notifyListeners();
  }

  @override
  void onPlaybackFailure({required String? error}) {
    log("Playback failure $error");
  }

  @override
  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {
    log("Playback state changed to ${playbackState.name}");
    playerPlaybackState = playbackState;
    switch (playbackState) {
      case HMSHLSPlaybackState.PLAYING:
        areClosedCaptionsSupported();
        setHLSPlayerStats(true);
        startTimer();
        getHLSLayers();
        getCurrentHLSLayer();
        isStreamPlaying = true;
        isPlayerFailed = false;
        break;
      case HMSHLSPlaybackState.STOPPED:
        break;
      case HMSHLSPlaybackState.PAUSED:
        isStreamPlaying = false;
        break;
      case HMSHLSPlaybackState.BUFFERING:
        break;
      case HMSHLSPlaybackState.FAILED:
        isPlayerFailed = true;
        break;
      case HMSHLSPlaybackState.UNKNOWN:
        break;
    }
    notifyListeners();
  }

  @override
  void onVideoSizeChanged({required Size size}) {
    log("onVideoSizeChanged -> height:${size.height} width:${size.width}");
    hlsPlayerSize = size;
    notifyListeners();
  }

  @override
  void onCues({required List<String> subtitles}) {
    log("onCues -> $subtitles");
    String newSubtitles = subtitles.join(" ");
    if (newSubtitles != caption) {
      caption = newSubtitles;
    }
    notifyListeners();
  }
}
