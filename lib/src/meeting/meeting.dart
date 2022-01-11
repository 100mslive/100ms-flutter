///HMSMeeting will contain all the functionalities related to meeting and preview.
///
///Just create instance of [HMSMeeting] and use the functionality which is present.
///
///All methods related to meeting, preview and their listeners are present here.

// Project imports:
import 'dart:ffi';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_action_result_listener_method.dart';
import 'package:hmssdk_flutter/src/manager/hms_sdk_manager.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../../hmssdk_flutter.dart';

class HMSMeeting {
  ///join meeting by passing HMSConfig instance to it.

  HMSTrackSetting? hmsTrackSetting;

  HMSMeeting({this.hmsTrackSetting});

  Future<bool> build() async {
    return await HmsSdkManager().createHMSSdk(hmsTrackSetting);
  }

  Future<void> joinMeeting({required HMSConfig config}) async {
    return await PlatformService.invokeMethod(PlatformMethod.joinMeeting,
        arguments: {...config.getJson()});
  }

  ///just call this method to leave meeting.
  void leaveMeeting({HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.leaveMeeting);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.leaveMeeting);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.leaveMeeting,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  ///switch local audio on/off.
  ///just pass false or true to switchAudio
  Future<HMSException?> switchAudio({bool isOn = false}) async {
    bool result = await PlatformService.invokeMethod(PlatformMethod.switchAudio,
        arguments: {'is_on': isOn});

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Switch Audio failed",
          description: "Cannot toggle audio status",
          action: "AUDIO",
          params: {'is_on': isOn});
    }
  }

  ///switch local video on/off.
  //////just pass false or true to switchVideo
  Future<HMSException?> switchVideo({bool isOn = false}) async {
    bool result = await PlatformService.invokeMethod(PlatformMethod.switchVideo,
        arguments: {'is_on': isOn});

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Switch Video failed",
          description: "Cannot toggle video status",
          action: "VIDEO",
          params: {'is_on': isOn});
    }
  }

  ///switch camera to front or rear.
  Future<void> switchCamera() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
  }

  ///send message to the room and the pass the [message].
  void sendBroadcastMessage(
      {required String message,
      String? type,
      HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendBroadcastMessage,
        arguments: {"message": message, "type": type});

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

  void sendGroupMessage(
      {required String message,
      required String roleName,
      String? type,
      HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendGroupMessage,
        arguments: {"message": message, "role_name": roleName, "type": type});
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

  void sendDirectMessage(
      {required String message,
      required HMSPeer peer,
      String? type,
      HMSMessageResultListener? hmsMessageResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendDirectMessage,
        arguments: {"message": message, "peer_id": peer.peerId, "type": type});

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

  void changeTrackRequest(
      {required HMSPeer peer,
      required bool mute,
      required bool isVideoTrack,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.changeTrack,
        arguments: {
          "hms_peer_id": peer.peerId,
          "mute": mute,
          "mute_video_kind": isVideoTrack
        });

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.changeTrackRequest);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.changeTrackRequest,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  void raiseHand(
      {required String metadata,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.raiseHand,
        arguments: {"metadata": metadata});

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.raiseHand);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.raiseHand,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  void endRoom(
      {required bool lock,
      required String reason,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.endRoom,
        arguments: {"lock": lock, "reason": reason});

    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.endRoom,
            arguments: {"lock": lock, "reason": reason});
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.endRoom,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

// TODO: declare arguments as a val
  void removePeer(
      {required HMSPeer peer,
      required String reason,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.removePeer,
        arguments: {"peer_id": peer.peerId, "reason": reason});

    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            arguments: {"peer_id": peer.peerId, "reason": reason},
            methodType: HMSActionResultListenerMethod.removePeer);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.removePeer,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
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

  void startHMSLogger(
      {required HMSLogLevel webRtclogLevel, required HMSLogLevel logLevel}) {
    PlatformService.invokeMethod(PlatformMethod.startHMSLogger, arguments: {
      "web_rtc_log_level":
          HMSLogLevelValue.getValueFromHMSLogLevel(webRtclogLevel),
      "log_level": HMSLogLevelValue.getValueFromHMSLogLevel(logLevel)
    });
  }

  void removeHMSLogger() {
    PlatformService.invokeMethod(PlatformMethod.removeHMSLogger);
  }

  void addLogListener({required HMSLogListener hmsLogListener}) {
    PlatformService.addLogsListener(hmsLogListener);
  }

  void removeLogListener({required HMSLogListener hmsLogListener}) {
    PlatformService.removeLogsListener(hmsLogListener);
  }

  ///add MeetingListener it will add all the listeners.
  void addMeetingListener({required HMSUpdateListener listener}) {
    PlatformService.addMeetingListener(listener);
  }

  ///remove a meetListener.
  void removeMeetingListener({required HMSUpdateListener listener}) {
    PlatformService.removeMeetingListener(listener);
  }

  ///add one or more previewListeners.
  void addPreviewListener({required HMSPreviewListener listener}) {
    PlatformService.addPreviewListener(listener);
  }

  ///remove a previewListener.
  void removePreviewListener({required HMSPreviewListener listener}) {
    PlatformService.removePreviewListener(listener);
  }

  ///accept the role changes
  void acceptRoleChangeRequest(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.acceptRoleChange);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.acceptRoleChangeRequest);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.acceptRoleChangeRequest,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  ///it will stop capturing the local video.
  Future<bool> stopCapturing() async {
    return await PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  ///it will start capturing the local video.
  Future<bool> startCapturing() async {
    return await PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  ///you can change role of any peer in the room just pass [peerId] and [roleName], [forceChange] is optional.
  void changeRole(
      {required HMSPeer peer,
      required String roleName,
      bool forceChange = false,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.changeRole,
        arguments: {
          'peer_id': peer.peerId,
          'role_name': roleName,
          'force_change': forceChange
        });

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.changeRole);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.changeRole,
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
  Future<bool> isAudioMute({HMSPeer? peer}) async {
    return await PlatformService.invokeMethod(PlatformMethod.isAudioMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
  }

  ///checks the video is mute or unmute just pass [peer]
  Future<bool> isVideoMute({HMSPeer? peer}) async {
    return await PlatformService.invokeMethod(PlatformMethod.isVideoMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
  }

  Future<void> muteAll() async {
    return await PlatformService.invokeMethod(PlatformMethod.muteAll);
  }

  Future<void> unMuteAll() async {
    return await PlatformService.invokeMethod(PlatformMethod.unMuteAll);
  }

  Future<void> setPlayBackAllowed({required bool allow}) async {
    return await PlatformService.invokeMethod(PlatformMethod.setPlayBackAllowed,
        arguments: {"allowed": allow});
  }

  void changeTrackStateForRole(
      {required bool mute,
      required String type,
      required String source,
      required List<String> roles,
      HMSActionResultListener? hmsActionResultListener}) async {
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
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.changeTrackStateForRole);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.changeTrackStateForRole,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  void startRtmpOrRecording(
      {required HMSRecordingConfig hmsRecordingConfig,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startRtmpOrRecording,
        arguments: hmsRecordingConfig.getJson()) as Map?;

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.startRtmpOrRecording);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.startRtmpOrRecording,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  void stopRtmpAndRecording(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopRtmpAndRecording);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.stopRtmpAndRecording);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.stopRtmpAndRecording,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  Future<HMSRoom?> getRoom() async {
    var hmsRoomMap = await PlatformService.invokeMethod(PlatformMethod.getRoom);
    if (hmsRoomMap == null) return null;
    return HMSRoom.fromMap(hmsRoomMap);
  }
}
