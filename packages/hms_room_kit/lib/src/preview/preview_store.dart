//Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';

class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {
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

  bool isRTMPStreamingStarted = false;

  List<HMSPeer>? peers;

  int? networkQuality;

  bool isRoomMute = false;

  List<HMSRole> roles = [];

  List<HMSAudioDevice> availableAudioOutputDevices = [];

  HMSAudioDevice? currentAudioOutputDevice;

  HMSAudioDevice currentAudioDeviceMode = HMSAudioDevice.AUTOMATIC;

  int peerCount = 0;

  bool isNoiseCancellationAvailable = false;

  bool isNoiseCancellationEnabled = false;

  @override
  void onHMSError({required HMSException error}) {
    this.error = error;
    notifyListeners();
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    log("onPreview-> room: ${room.toString()}");
    this.room = room;
    checkNoiseCancellationAvailablility();
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        HMSRoomLayout.resetLayout(each.role.name);
        notifyListeners();
        peer = each;
        if (HMSRoomLayout
                .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
            null) {
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
    getRoles();
    getCurrentAudioDevice();
    getAudioDevicesList();
    toggleCameraMuteState();
    toggleMicMuteState();
    notifyListeners();
  }

  void startPreview(
      {required String userName, required String tokenData}) async {
    HMSConfig joinRoomConfig = HMSConfig(
        authToken: tokenData,
        userName: userName,
        captureNetworkQualityInPreview: true,
        // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
        //This is only for 100ms internal testing, endPoint can be safely removed from
        //the HMSConfig for external usage
        endPoint: Constant.initEndPoint);
    hmsSDKInteractor.startHMSLogger(
        Constant.webRTCLogLevel, Constant.sdkLogLevel);
    hmsSDKInteractor.addPreviewListener(this);
    hmsSDKInteractor.preview(config: joinRoomConfig);
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
    log("preview onRoomUpdate-> room: ${room.toString()} update: ${update.name} streamingState: ${room.hmshlsStreamingState?.state.name}");
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        isRecordingStarted =
            room.hmsBrowserRecordingState?.state == HMSRecordingState.started;
        break;

      case HMSRoomUpdate.serverRecordingStateUpdated:
        isRecordingStarted =
            room.hmsServerRecordingState?.state == HMSRecordingState.started;

      case HMSRoomUpdate.hlsRecordingStateUpdated:
        isRecordingStarted =
            room.hmshlsRecordingState?.state == HMSRecordingState.started;
        break;

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        isRTMPStreamingStarted =
            room.hmsRtmpStreamingState?.state == HMSStreamingState.started;
        break;
      case HMSRoomUpdate.hlsStreamingStateUpdated:
        isHLSStreamingStarted =
            room.hmshlsStreamingState?.state == HMSStreamingState.started;
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

  void checkNoiseCancellationAvailablility() async {
    isNoiseCancellationAvailable =
        await hmsSDKInteractor.isNoiseCancellationAvailable();

    ///Here we check if noise cancellation is available, if its available
    ///then we check if its enabled from dashboard in preview
    ///If yes we enable it.
    ///Else we check the noise cancellation status to update the UI
    if (isNoiseCancellationAvailable) {
      if (HMSRoomLayout.roleLayoutData?.screens?.preview?.noiseCancellation
              ?.enabledByDefault ??
          false) {
        hmsSDKInteractor.enableNoiseCancellation();
        isNoiseCancellationEnabled = true;
      } else {
        isNoiseCancellationEnabled =
            await hmsSDKInteractor.isNoiseCancellationEnabled();
      }
    }
    notifyListeners();
  }

  void toggleNoiseCancellation() async {
    if (isNoiseCancellationEnabled) {
      hmsSDKInteractor.disableNoiseCancellation();
    } else {
      hmsSDKInteractor.enableNoiseCancellation();
    }
    isNoiseCancellationEnabled = !isNoiseCancellationEnabled;
    notifyListeners();
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

    ///Here we call the method passed by the user in HMSPrebuilt as a callback
    if (Constant.onLeave != null) {
      Constant.onLeave!();
    }
    HMSThemeColors.resetLayoutColors();
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
    roles.removeWhere((element) => element.name == "__internal_recorder");
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
    if (isRoomMute) {
      toggleSpeaker();
    }
    currentAudioDeviceMode = audioDevice;
    hmsSDKInteractor.switchAudioOutput(audioDevice: audioDevice);
    notifyListeners();
  }

  void switchAudioOutputUsingiOSUI() {
    if (isRoomMute) {
      toggleSpeaker();
    }
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

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    log("onPeerListUpdate -> addedPeers: $addedPeers removedPeers: $removedPeers");
  }
}
