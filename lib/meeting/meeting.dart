import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSMeeting {
  Future<void> startMeeting({required HMSConfig config}) async {
    return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
        arguments: config.getJson());
  }

  Future<void> leaveMeeting() async {
    return await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
  }

  Future<void> switchAudio({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchAudio,
        arguments: {'is_on': isOn});
  }

  Future<void> switchVideo({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchVideo,
        arguments: {'is_on': isOn});
  }

  Future<void> switchCamera() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
  }

  Future<void> sendMessage(String message) async {
    return await PlatformService.invokeMethod(PlatformMethod.sendMessage,
        arguments: {"message": message});
  }

  Future<void> previewVideo({required HMSConfig config}) async {
    return await PlatformService.invokeMethod(PlatformMethod.previewVideo,
        arguments: config.getJson());
  }

  void addMeetingListener(HMSUpdateListener listener) {
    PlatformService.addMeetingListener(listener);
  }

  void removeMeetingListener(HMSUpdateListener listener) {
    PlatformService.removeMeetingListener(listener);
  }

  void addPreviewListener(HMSPreviewListener listener) {
    PlatformService.addPreviewListener(listener);
  }

  void removePreviewListener(HMSPreviewListener listener) {
    PlatformService.removePreviewListener(listener);
  }

  void acceptRoleChangerequest(){
    PlatformService.invokeMethod(PlatformMethod.acceptRoleChange);
  }
}
