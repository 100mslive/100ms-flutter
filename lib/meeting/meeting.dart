import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_role.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';

class HMSMeeting {
  Future<void> joinMeeting({required HMSConfig config}) async {
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

  void acceptRoleChangerequest() {
    PlatformService.invokeMethod(PlatformMethod.acceptRoleChange);
  }

  void stopCapturing() {
    PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  void startCapturing() {
    PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  void changeRole(
      {required String peerId,
      required String roleName,
      bool forceChange = false}) {
    PlatformService.invokeMethod(PlatformMethod.changeRole, arguments: {
      'peer_id': peerId,
      'role_name': roleName,
      'force_change': forceChange
    });
  }

  Future<List<HMSRole>> getRoles() async {
    List<HMSRole> roles = [];
    var result = await PlatformService.invokeMethod(PlatformMethod.getRoles);
    if (result is Map && result.containsKey('roles')) {
      if (result['roles'] is List) {
        for (var each in (result['roles'] as List)) {
          HMSRole role = HMSRole.fromMap(each);
          roles.add(role);
        }
      }
    }
    return roles;
  }
}
