//Package imports
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/app_secrets.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/constant.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';

class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {
  late HMSSDKInteractor hmsSDKInteractor;

  PreviewStore({required HMSSDKInteractor hmsSDKInteractor}) {
    this.hmsSDKInteractor = hmsSDKInteractor;
  }

  List<HMSVideoTrack> localTracks = [];

  HMSPeer? peer;

  HMSException? error;

  bool isHLSLink = false;
  HMSRoom? room;

  bool isVideoOn = true;

  bool isAudioOn = true;

  bool isRecordingStarted = false;

  bool isHLSStreamingStarted = false;

  bool isRTMPStreamingStarted = false;

  List<HMSPeer> peers = [];

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
    Utilities.saveStringData(key: "meetingLink", value: this.meetingUrl);
    getRoles();
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();
  }

  Future<HMSException?> startPreview(
      {required String user, required String meetingLink}) async {
    List<String?>? _roomData = RoomService().getCode(meetingLink);

    //If the link is not valid then we might not get the code and whether the link is a
    //PROD or QA so we return the error in this case
    if (_roomData?.length == 0) {
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
    String? _endPoint = _roomData?[1] == "true" ? null : '$qaTokenEndPoint';

    Constant.meetingCode = _roomData?[0] ?? '';

    //We use this to get the auth token from room code
    dynamic _tokenData = await hmsSDKInteractor.getAuthTokenByRoomCode(
        Constant.meetingCode, user, _endPoint);

    if (_tokenData is HMSTokenResult && _tokenData.authToken != null) {
      roomConfig = HMSConfig(
        authToken: _tokenData.authToken!,
        userName: user,
        captureNetworkQualityInPreview: true,
        // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
        //This is only for 100ms internal testing, endPoint can be safely removed from
        //the HMSConfig for external usage
        endPoint: _roomData?[1] == "true" ? "" : '$qaInitEndPoint',
      );
      hmsSDKInteractor.addPreviewListener(this);
      hmsSDKInteractor.preview(config: roomConfig!);
      meetingUrl = meetingLink;
      return null;
    }

    FirebaseCrashlytics.instance.setUserIdentifier(_tokenData.toString());
    return _tokenData;
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    log("onPeerUpdate-> peer: ${peer.name} update: ${update.name}");
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        peers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        peers.remove(peer);
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        if (peer.isLocal) {
          networkQuality = peer.networkQuality?.quality;
          notifyListeners();
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        int index = peers.indexOf(peer);
        if (index != -1) peers[index] = peer;
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

  void addLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.addLogsListener(hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    hmsSDKInteractor.removeLogsListener(hmsLogListener);
  }

  @override
  void onLogMessage({required hmsLogList}) {
    FirebaseCrashlytics.instance.log(hmsLogList.toString());
  }

  void destroy() {
    hmsSDKInteractor.removePreviewListener(this);
    hmsSDKInteractor.destroy();
  }

  void leave() {
    hmsSDKInteractor.leave();
    destroy();
  }

  void toggleSpeaker() async {
    if (!this.isRoomMute) {
      hmsSDKInteractor.muteRoomAudioLocally();
    } else {
      hmsSDKInteractor.unMuteRoomAudioLocally();
    }
    this.isRoomMute = !this.isRoomMute;
    notifyListeners();
  }

  void getRoles() async {
    roles = await hmsSDKInteractor.getRoles();
    notifyListeners();
  }

  Future<void> getAudioDevicesList() async {
    availableAudioOutputDevices.clear();
    availableAudioOutputDevices
        .addAll(await hmsSDKInteractor.getAudioDevicesList());
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

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    if (currentAudioDevice != null &&
        this.currentAudioOutputDevice != currentAudioDevice) {
      Utilities.showToast(
          "Output Device changed to ${currentAudioDevice.name}");
      this.currentAudioOutputDevice = currentAudioDevice;
    }

    if (availableAudioDevice != null) {
      this.availableAudioOutputDevices.clear();
      this.availableAudioOutputDevices.addAll(availableAudioDevice);
    }
    notifyListeners();
  }
}
