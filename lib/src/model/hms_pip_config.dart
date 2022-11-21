import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

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

  ///[showAudioButton] flag to display local audio mute button while in pip
  bool? showAudioButton;

  ///[showVideoButton] flag to display local video mute button while in pip
  bool? showVideoButton;

  ///[showLeaveRoomButton] flag to leave the room while in pip
  bool? showLeaveRoomButton;

  ///[leaveRoomListener] object to get update when the room is left from pip mode
  ///This should not be null while setting [showLeaveRoomButton] as true because this may lead to memory leak in application
  HMSActionResultListener? leaveRoomListener;

  HMSPipConfig(
      {this.aspectRatio = const [16, 9],
      this.autoEnterPip = false,
      this.showAudioButton = false,
      this.showVideoButton = false,
      this.showLeaveRoomButton = false,
      this.leaveRoomListener = null});

  @override
  String toString() {
    return 'HMSPipConfig{aspectRatio: $aspectRatio, autoEnterPip: $autoEnterPip, addAudioMuteButton: $showAudioButton, addVideoMuteButton: $showVideoButton, addLeaveRoomButton: $showLeaveRoomButton}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["aspect_ratio"] = aspectRatio;
    map["auto_enter_pip"] = autoEnterPip;
    map["show_audio_button"] = showAudioButton;
    map["show_video_button"] = showVideoButton;
    map["show_leave_room_button"] = showLeaveRoomButton;
    return map;
  }

//To update pip video button
  Future<HMSException?> switchVideoButtonStatus() async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.switchVideoButtonStatus);
    if (result != null) {
      return HMSException(
          message: "Error in updating video button status",
          description: "Failed while updating video button status",
          action: "VIDEO",
          isTerminal: false);
    }
    return null;
  }

//To update pip mic button
  Future<HMSException?> switchAudioButtonStatus() async{
    var result = await PlatformService.invokeMethod(
        PlatformMethod.switchAudioButtonStatus);
    if (result != null) {
      return HMSException(
          message: "Error in updating audio button status",
          description: "Failed while updating audio button status",
          action: "AUDIO",
          isTerminal: false);
    }
    return null;
  }

//To update pip config
  Future<HMSException?> updatePipConfig({required HMSPipConfig hmsPipConfig}) async{
    var result = await PlatformService.invokeMethod(
        PlatformMethod.updatePipConfig
        ,arguments: {"pip_config": hmsPipConfig.toMap()});
    if (result != null) {
      return HMSException(
          message: "Error in updating PIP config",
          description: "Failed while updating PIP config",
          action: "PIP_CONFIG",
          isTerminal: false);
    }
    return null;
  }
}
