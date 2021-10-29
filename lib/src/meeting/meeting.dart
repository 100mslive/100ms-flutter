///HMSMeeting will contain all the functionalities related to meeting and preview.
///
///Just create instance of [HMSMeeting] and use the functionality which is present.
///
///All methods related to meeting, preview and their listeners are present here.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/enum/hms_log_level.dart';
import 'package:hmssdk_flutter/src/model/hms_logs_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSMeeting {
  ///join meeting by passing HMSConfig instance to it.
  Future<void> joinMeeting({required HMSConfig config}) async {
    bool isProdLink = true;
    if (config.endPoint != null) isProdLink = false;
    return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
        arguments: {...config.getJson(), 'is_prod': isProdLink});
  }

  ///just call this method to leave meeting.
  Future<void> leaveMeeting() async {
    return await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
  }

  ///switch local audio on/off.
  ///just pass false or true to switchAudio
  Future<void> switchAudio({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchAudio,
        arguments: {'is_on': isOn});
  }

  ///switch local video on/off.
  //////just pass false or true to switchVideo
  Future<void> switchVideo({bool isOn = false}) async {
    return await PlatformService.invokeMethod(PlatformMethod.switchVideo,
        arguments: {'is_on': isOn});
  }

  ///switch camera to front or rear.
  Future<void> switchCamera() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
  }

  ///send message to the room and the pass the [message].
  Future<void> sendMessage(String message) async {
    return await PlatformService.invokeMethod(PlatformMethod.sendMessage,
        arguments: {"message": message});
  }

  Future<void> sendGroupMessage(String message, String roleName) async {
    return await PlatformService.invokeMethod(PlatformMethod.sendGroupMessage,
        arguments: {"message": message, "role_name": roleName});
  }

  Future<void> sendDirectMessage(String message, String peerId) async {
    return await PlatformService.invokeMethod(PlatformMethod.sendDirectMessage,
        arguments: {"message": message, "peer_id": peerId});
  }

  Future<void> changeTrackReuest(
      String peerId, bool mute, bool isVideoTrack) async {
    return await PlatformService.invokeMethod(PlatformMethod.changeTrack,
        arguments: {
          "hms_peer_id": peerId,
          "mute": mute,
          "mute_video_kind": isVideoTrack
        });
  }

  Future<bool> endRoom(bool lock) async {
    return await PlatformService.invokeMethod(PlatformMethod.endRoom,
        arguments: {"lock": lock});
  }

  Future<void> removePeer(String peerId) async {
    return await PlatformService.invokeMethod(PlatformMethod.removePeer,
        arguments: {"peer_id": peerId});
  }

  Future<HMSPeer?> getLocalPeer() async {
    return HMSPeer.fromMap(
        await PlatformService.invokeMethod(PlatformMethod.getLocalPeer) as Map);
  }

  ///preview before joining the room pass [HMSConfig].
  Future<void> previewVideo({
    required HMSConfig config,
  }) async {

    bool isProdLink = true;
    if(config.endPoint != null)isProdLink = false;

    return await PlatformService.invokeMethod(PlatformMethod.previewVideo,
        arguments: {
          ...config.getJson(),
          'is_prod': isProdLink,
        });
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    PlatformService.invokeMethod(PlatformMethod.startHMSLogger, arguments: {
      "web_rtc_log_level":
          HMSLogLevelValue.getValueFromHMSLogLevel(webRtclogLevel),
      "log_level": HMSLogLevelValue.getValueFromHMSLogLevel(logLevel)
    });
  }

  void removeHMSLogger() {
    PlatformService.invokeMethod(PlatformMethod.removeHMSLogger);
  }

  void addLogListener(HMSLogListener hmsLogListener) {
    PlatformService.addLogsListener(hmsLogListener);
  }

  void removeLogListener(HMSLogListener hmsLogListener) {
    PlatformService.removeLogsListener(hmsLogListener);
  }

  ///add MeetingListener it will add all the listeners.
  void addMeetingListener(HMSUpdateListener listener) {
    PlatformService.addMeetingListener(listener);
  }

  ///remove a meetListener.
  void removeMeetingListener(HMSUpdateListener listener) {
    PlatformService.removeMeetingListener(listener);
  }

  ///add one or more previewListeners.
  void addPreviewListener(HMSPreviewListener listener) {
    PlatformService.addPreviewListener(listener);
  }

  ///remove a previewListener.
  void removePreviewListener(HMSPreviewListener listener) {
    PlatformService.removePreviewListener(listener);
  }

  ///accept the role changes.
  void acceptRoleChangerequest() {
    PlatformService.invokeMethod(PlatformMethod.acceptRoleChange);
  }

  ///it will stop capturing the local video.
  void stopCapturing() {
    PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  ///it will start capturing the local video.
  void startCapturing() {
    PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  ///you can change role of any peer in the room just pass [peerId] and [roleName], [forceChange] is optional.
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

  ///returns all the roles associated with the link used
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

  ///checks the audio is mute or unmute just pass [peer]
  Future<bool> isAudioMute(HMSPeer? peer) async {
    bool isMute = await PlatformService.invokeMethod(PlatformMethod.isAudioMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
    return isMute;
  }

  ///checks the video is mute or unmute just pass [peer]
  Future<bool> isVideoMute(HMSPeer? peer) async {
    bool isMute = await PlatformService.invokeMethod(PlatformMethod.isVideoMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
    return isMute;
  }

  void muteAll() async {
    await PlatformService.invokeMethod(PlatformMethod.muteAll);
  }

  void unMuteAll() async {
    await PlatformService.invokeMethod(PlatformMethod.unMuteAll);
  }

  Future<bool> changeTrackStateForRole(
      bool mute, String type, String source, List<String> roles) async {
    return await PlatformService.invokeMethod(
        PlatformMethod.changeTrackStateForRole,
        arguments: {
          "mute": mute,
          "type": type,
          "source": source,
          "roles": roles
        });
  }

  Future<HMSException?> startRtmpOrRecording(
      HMSRecordingConfig hmsRecordingConfig) async {
    Map? hmsException = await PlatformService.invokeMethod(
        PlatformMethod.startRtmpOrRecording,
        arguments: hmsRecordingConfig.getJson()) as Map?;
    if (hmsException == null) return null;
    return HMSException.fromMap(hmsException);
  }

  Future<HMSException?> stopRtmpAndRecording() async {
    Map<String, dynamic>? hmsException =
        await PlatformService.invokeMethod(PlatformMethod.stopRtmpAndRecording);
    if (hmsException == null) return null;
    return HMSException.fromMap(hmsException);
  }
}
