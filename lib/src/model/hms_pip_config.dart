import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms pip config
///
///To use, import `package:hmssdk_flutter/model/hms_pip_config.dart`.
///
///[HMSPipConfig] contains configuration about the pip mode.This config is used to
///setup the pip functionality for the application.
class HMSPipConfig {
  ///[aspectRatio] defines the width and height ratio as [width,height]
  List<int>? aspectRatio;

  ///[autoEnterPip] flag to provide smoother transitions to PiP mode when swiping up to home in gesture navigation mode
  ///only works from Android 12
  bool? autoEnterPip;

  ///[addAudioMuteButton] flag to display local audio mute button while in pip
  bool? addAudioMuteButton;

  ///[addVideoMuteButton] flag to display local video mute button while in pip
  bool? addVideoMuteButton;

  ///[addLeaveRoomButton] flag to leave the room while in pip
  bool? addLeaveRoomButton;

  ///[leaveRoomListener] object to get update when the room is left from pip mode
  ///This should not be null while setting [addLeaveRoomButton] as true because this may lead to memory leak in application
  HMSActionResultListener? leaveRoomListener;

  HMSPipConfig(
      {this.aspectRatio = const [16, 9],
      this.autoEnterPip = false,
      this.addAudioMuteButton = false,
      this.addVideoMuteButton = false,
      this.addLeaveRoomButton = false,
      this.leaveRoomListener = null});

  @override
  String toString() {
    return 'HMSPipConfig{aspectRatio: $aspectRatio, autoEnterPip: $autoEnterPip, addAudioMuteButton: $addAudioMuteButton, addVideoMuteButton: $addVideoMuteButton, addLeaveRoomButton: $addLeaveRoomButton}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["aspect_ratio"] = aspectRatio;
    map["auto_enter_pip"] = autoEnterPip;
    map["add_audio_mute_button"] = addAudioMuteButton;
    map["add_video_mute_button"] = addVideoMuteButton;
    map["add_leave_room_button"] = addLeaveRoomButton;
    return map;
  }
}
