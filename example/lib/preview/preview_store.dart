//Package imports
import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hms_sdk_interactor.dart';
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

  Future<String> startPreview(
      {required String user, required String meetingLink}) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: meetingLink);

    if (token == null) return "Connection Error";
    if (token[0] == null) return "Token Error";
    FirebaseCrashlytics.instance.setUserIdentifier(token[0]!);
    HMSConfig config = HMSConfig(
      authToken: token[0]!,
      userName: user,
      captureNetworkQualityInPreview: true,
      // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
      endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init",
    );
    hmsSDKInteractor.addPreviewListener(this);
    hmsSDKInteractor.preview(config: config);
    hmsSDKInteractor.startHMSLogger(HMSLogLevel.ERROR,HMSLogLevel.ERROR);
    meetingUrl = meetingLink;
    return "";
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
