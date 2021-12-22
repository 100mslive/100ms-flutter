///HMSMeeting will contain all the functionalities related to meeting and preview.
///
///Just create instance of [HMSMeeting] and use the functionality which is present.
///
///All methods related to meeting, preview and their listeners are present here.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/enum/hms_log_level.dart';
import 'package:hmssdk_flutter/src/manager/hms_sdk_manager.dart';
import 'package:hmssdk_flutter/src/model/hms_actions_result_listener.dart';
import 'package:hmssdk_flutter/src/model/hms_logs_listener.dart';
import 'package:hmssdk_flutter/src/model/hms_message_result_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

import '../../hmssdk_flutter.dart';

class HMSMeeting {
  ///join meeting by passing HMSConfig instance to it.
  HMSTrackSetting? hmsTrackSetting;

  HMSMeeting({this.hmsTrackSetting});

  Future<bool> build() async {
    bool created = await HmsSdkManager().createHMSSdk(hmsTrackSetting);
    return false;
  }

  Future<void> joinMeeting({required HMSConfig config}) async {
    bool isProdLink = true;
    return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
        arguments: {...config.getJson()});
  }

  ///just call this method to leave meeting.
  Future<void> leaveMeeting(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
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
  Future<void> sendMessage(String message,
      {HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.sendMessage,
        arguments: {"message": message});

    if (hmsMessageResultListener != null) {
      if (result["event_name"] == "on_error") {
        hmsMessageResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsMessageResultListener.onSuccess(
            hmsMessage: HMSMessage.fromMap(result["message"]));
      }
    }
  }

  Future<void> sendGroupMessage(String message, String roleName,
      {HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendGroupMessage,
        arguments: {"message": message, "role_name": roleName});
    if (hmsMessageResultListener != null) {
      if (result["event_name"] == "on_error") {
        hmsMessageResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsMessageResultListener.onSuccess(
            hmsMessage: HMSMessage.fromMap(result["message"]));
      }
    }
  }

  Future<void> sendDirectMessage(String message, String peerId,
      {HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendDirectMessage,
        arguments: {"message": message, "peer_id": peerId});

    if (hmsMessageResultListener != null) {
      if (result["event_name"] == "on_error") {
        hmsMessageResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsMessageResultListener.onSuccess(
            hmsMessage: HMSMessage.fromMap(result["message"]));
      }
    }
  }

  Future<void> changeTrackRequest(String peerId, bool mute, bool isVideoTrack,
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.changeTrack,
        arguments: {
          "hms_peer_id": peerId,
          "mute": mute,
          "mute_video_kind": isVideoTrack
        });
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  Future<void> raiseHand({HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.raiseHand);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  Future<bool> endRoom(bool lock,
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.endRoom,
        arguments: {"lock": lock});
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess();
        return true;
      } else {
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
        return false;
      }
    }
    return result == null;
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
    return await PlatformService.invokeMethod(PlatformMethod.previewVideo,
        arguments: {
          ...config.getJson(),
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
  void acceptRoleChangerequest(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.acceptRoleChange);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
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
      bool forceChange = false,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.changeRole,
        arguments: {
          'peer_id': peerId,
          'role_name': roleName,
          'force_change': forceChange
        });
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
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

  Future<bool> startScreenShare() async {
    bool isScreenShareEnabled =
        await PlatformService.invokeMethod(PlatformMethod.startScreenShare);
    return isScreenShareEnabled;
  }

  void stopScreenShare() async {
    await PlatformService.invokeMethod(PlatformMethod.stopScreenShare);
  }

  void muteAll() async {
    await PlatformService.invokeMethod(PlatformMethod.muteAll);
  }

  void unMuteAll() async {
    await PlatformService.invokeMethod(PlatformMethod.unMuteAll);
  }

  Future<void> setPlayBackAllowed(bool allow) async{
    await PlatformService.invokeMethod(PlatformMethod.setPlayBackAllowed,arguments: {"allowed":allow});
  }

  Future<bool> changeTrackStateForRole(
      bool mute, String type, String source, List<String> roles,
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeTrackStateForRole,
        arguments: {
          "mute": mute,
          "type": type,
          "source": source,
          "roles": roles
        });

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
    return result == null;
  }

  Future<HMSException?> startRtmpOrRecording(
      HMSRecordingConfig hmsRecordingConfig,
      {HMSActionResultListener? hmsActionResultListener}) async {
    Map? result = await PlatformService.invokeMethod(
        PlatformMethod.startRtmpOrRecording,
        arguments: hmsRecordingConfig.getJson()) as Map?;

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
    if (result == null) return null;
    return HMSException.fromMap(result);
  }

  Future<HMSException?> stopRtmpAndRecording(
      {HMSActionResultListener? hmsActionResultListener}) async {
    Map<String, dynamic>? result =
        await PlatformService.invokeMethod(PlatformMethod.stopRtmpAndRecording);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess();
      else
        hmsActionResultListener.onError(
            hmsException: HMSException.fromMap(result["error"]));
    }
    if (result == null) return null;
    return HMSException.fromMap(result);
  }

  Future<HMSRoom?> getRoom() async {
    var hmsRoomMap = await PlatformService.invokeMethod(PlatformMethod.getRoom);
    if (hmsRoomMap == null) return null;
    return HMSRoom.fromMap(hmsRoomMap);
  }
}
