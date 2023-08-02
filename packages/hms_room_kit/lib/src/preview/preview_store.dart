//Package imports
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/constants.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/service/app_secrets.dart';
import 'package:hms_room_kit/src/service/room_service.dart';

class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener, HMSUpdateListener {
  late HMSSDKInteractor hmsSDKInteractor;

  PreviewStore({required this.hmsSDKInteractor});

  List<HMSVideoTrack> localTracks = [];

  HMSPeer? peer;

  HMSException? error;

  bool isHLSLink = false;
  HMSRoom? room;

  bool isVideoOn = false;

  bool isAudioOn = false;

  bool isRecordingStarted = false;

  bool isHLSStreamingStarted = false;

  bool isRoomJoinedAndHLSStarted = false;

  bool isRoomJoined = false;

  bool isRTMPStreamingStarted = false;

  List<HMSPeer>? peers;

  int? networkQuality;

  String meetingUrl = "";

  bool isRoomMute = false;

  List<HMSRole> roles = [];

  List<HMSAudioDevice> availableAudioOutputDevices = [];

  HMSAudioDevice? currentAudioOutputDevice;

  HMSAudioDevice currentAudioDeviceMode = HMSAudioDevice.AUTOMATIC;

  int peerCount = 0;

  HMSConfig? roomConfig;

  @override
  void onHMSError({required HMSException error}) {
    this.error = error;
    notifyListeners();
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    log("onPreview-> room: ${room.toString()}");
    this.room = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        peer = each;
        if (each.role.name.indexOf("hls-") == 0) {
          isHLSLink = true;
        }
        if (!each.role.publishSettings!.allowed.contains("video")) {
          isVideoOn = false;
        }
        peerCount = room.peerCount;
        notifyListeners();
        break;
      }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        isVideoOn = !(track.isMute);
        videoTracks.add(track as HMSVideoTrack);
      }
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
        isAudioOn = !(track.isMute);
      }
    }
    this.localTracks = videoTracks;
    Utilities.saveStringData(key: "meetingLink", value: meetingUrl);
    getRoles();
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();
  }

  Future<HMSException?> startPreview(
      {required String userName, required String meetingLink}) async {
    String? tokenEndPoint;
    String? initEndPoint;

    if (meetingLink.contains("app.100ms.live")) {
      List<String?>? roomData = RoomService().getCode(meetingLink);

      //If the link is not valid then we might not get the code and whether the link is a
      //PROD or QA so we return the error in this case
      if (roomData == null || roomData.isEmpty) {
        return HMSException(
            message: "Invalid meeting URL",
            description: "Provided meeting URL is invalid",
            action: "Please Check the meeting URL",
            isTerminal: false);
      }

      //qaTokenEndPoint is only required for 100ms internal testing
      //It can be removed and should not affect the join method call
      //For _endPoint just pass it as null
      //the endPoint parameter in getAuthTokenByRoomCode can be passed as null
      tokenEndPoint = roomData[1] == "true" ? null : qaTokenEndPoint;
      initEndPoint = roomData[1] == "true" ? "" : qaInitEndPoint;

      Constant.meetingCode = roomData[0] ?? '';
    } else {
      Constant.meetingCode = meetingLink;
    }

    //We use this to get the auth token from room code
    dynamic tokenData = await hmsSDKInteractor.getAuthTokenByRoomCode(
        roomCode: Constant.meetingCode, endPoint: tokenEndPoint);

    if ((tokenData is String?) && tokenData != null) {
      roomConfig = HMSConfig(
          authToken: tokenData,
          userName: userName,
          captureNetworkQualityInPreview: true,
          // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
          //This is only for 100ms internal testing, endPoint can be safely removed from
          //the HMSConfig for external usage
          endPoint: initEndPoint);
      hmsSDKInteractor.startHMSLogger(
          Constant.webRTCLogLevel, Constant.sdkLogLevel);
      hmsSDKInteractor.addPreviewListener(this);
      hmsSDKInteractor.preview(config: roomConfig!);
      meetingUrl = meetingLink;
      return null;
    }
    return tokenData;
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    log("onPeerUpdate-> peer: ${peer.name} update: ${update.name}");
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        peers ??= [];
        peers?.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        peers?.remove(peer);
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        if (peer.isLocal) {
          networkQuality = peer.networkQuality?.quality;
          notifyListeners();
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        if (peers != null) {
          int index = peers!.indexOf(peer);
          if (index != -1) {
            peers![index] = peer;
          }
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    this.room = room;
    log("onRoomUpdate-> room: ${room.toString()} update: ${update.name}");
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        isRecordingStarted = room.hmsBrowserRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.serverRecordingStateUpdated:
        isRecordingStarted = room.hmsServerRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.hlsRecordingStateUpdated:
        isRecordingStarted = room.hmshlsRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        isRTMPStreamingStarted = room.hmsRtmpStreamingState?.running ?? false;
        break;
      case HMSRoomUpdate.hlsStreamingStateUpdated:
        isHLSStreamingStarted = room.hmshlsStreamingState?.running ?? false;
        isRoomJoinedAndHLSStarted =
            (room.hmshlsStreamingState?.running ?? false) && isRoomJoined;
        break;
      case HMSRoomUpdate.roomPeerCountUpdated:
        peerCount = room.peerCount;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void removePreviewListener() {
    hmsSDKInteractor.removePreviewListener(this);
  }

  void toggleCameraMuteState() {
    hmsSDKInteractor.toggleCameraMuteState();
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  void toggleMicMuteState() {
    hmsSDKInteractor.toggleMicMuteState();
    isAudioOn = !isAudioOn;
    notifyListeners();
  }

  void switchCamera() {
    if (isVideoOn) {
      hmsSDKInteractor.switchCamera();
    }
  }

  void addLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.addLogsListener(hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.removeLogsListener(hmsLogListener);
  }

  @override
  void onLogMessage({required HMSLogList hmsLogList}) {}

  void destroy() {
    hmsSDKInteractor.removePreviewListener(this);
    hmsSDKInteractor.destroy();
  }

  void leave() {
    hmsSDKInteractor.leave();
    destroy();
  }

  void toggleSpeaker() async {
    if (!isRoomMute) {
      hmsSDKInteractor.muteRoomAudioLocally();
    } else {
      hmsSDKInteractor.unMuteRoomAudioLocally();
    }
    isRoomMute = !isRoomMute;
    notifyListeners();
  }

  void getRoles() async {
    roles = await hmsSDKInteractor.getRoles();
    notifyListeners();
  }

  Future<void> getAudioDevicesList() async {
    var devices = await hmsSDKInteractor.getAudioDevicesList();
    availableAudioOutputDevices.clear();
    availableAudioOutputDevices.addAll(devices);
    notifyListeners();
  }

  Future<void> getCurrentAudioDevice() async {
    currentAudioOutputDevice = await hmsSDKInteractor.getCurrentAudioDevice();
    notifyListeners();
  }

  void switchAudioOutput({required HMSAudioDevice audioDevice}) {
    currentAudioDeviceMode = audioDevice;
    hmsSDKInteractor.switchAudioOutput(audioDevice: audioDevice);
    notifyListeners();
  }

  void switchAudioOutputUsingiOSUI() {
    hmsSDKInteractor.switchAudioOutputUsingiOSUI();
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    if (currentAudioDevice != null &&
        currentAudioOutputDevice != currentAudioDevice) {
      Utilities.showToast(
          "Output Device changed to ${currentAudioDevice.name}");
      currentAudioOutputDevice = currentAudioDevice;
    }

    if (availableAudioDevice != null) {
      availableAudioOutputDevices.clear();
      availableAudioOutputDevices.addAll(availableAudioDevice);
    }
    notifyListeners();
  }

  void toggleIsRoomJoinedAndHLSStarted() {
    isRoomJoinedAndHLSStarted = (!isRoomJoinedAndHLSStarted && isRoomJoined);
    notifyListeners();
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onJoin({required HMSRoom room}) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {}

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}
}
