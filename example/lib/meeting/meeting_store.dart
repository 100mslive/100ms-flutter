//Package imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:video_player/video_player.dart';

class MeetingStore extends ChangeNotifier
    with WidgetsBindingObserver
    implements HMSUpdateListener, HMSActionResultListener, HMSStatsListener {
  late HMSSDKInteractor _hmsSDKInteractor;

  MeetingStore({required HMSSDKInteractor hmsSDKInteractor}) {
    _hmsSDKInteractor = hmsSDKInteractor;
  }

  // HMSLogListener

  bool isSpeakerOn = true;

  int screenShareCount = 0;

  HMSException? hmsException;

  bool hasHlsStarted = false;

  bool isHLSLoading = false;

  String streamUrl = "";

  bool isHLSLink = false;

  HMSRoleChangeRequest? currentRoleChangeRequest;

  bool isMeetingStarted = false;

  bool isVideoOn = true;

  bool isMicOn = true;

  bool isScreenShareOn = false;

  List<HMSTrack?> screenShareTrack = [];

  HMSTrack? curentScreenShareTrack;

  bool reconnecting = false;

  bool reconnected = false;

  bool isRoomEnded = false;

  Map<String, bool> recordingType = {
    "browser": false,
    "server": false,
    "hls": false
  };

  Map<String, bool> streamingType = {"rtmp": false, "hls": false};

  String description = "Meeting Ended";

  HMSTrackChangeRequest? hmsTrackChangeRequest;

  List<HMSRole> roles = [];

  late int highestSpeakerIndex = -1;

  List<HMSPeer> peers = [];

  List<HMSPeer> filteredPeers = [];

  String selectedRoleFilter = "Everyone";

  HMSPeer? localPeer;

  bool isActiveSpeakerMode = true;

  List<HMSTrack> audioTracks = [];

  List<HMSMessage> messages = [];

  List<PeerTrackNode> peerTracks = [];

  Map<String, int> activeSpeakerIds = {};

  HMSRoom? hmsRoom;

  int? localPeerNetworkQuality;

  bool isStatsVisible = false;

  bool isNewMessageReceived = false;

  String? highestSpeaker;
  int firstTimeBuild = 0;

  String message = "";

  final DateFormat formatter = DateFormat('d MMM y h:mm:ss a');

  bool isMirror = false;

  ScrollController controller = ScrollController();

  MeetingMode meetingMode = MeetingMode.Video;

  bool isLandscapeLocked = false;

  bool isMessageInfoShown = true;

  String meetingUrl = "";
  bool isAudioShareStarted = false;

  List<HMSAudioDevice> availableAudioOutputDevices = [];

  HMSAudioDevice? currentAudioOutputDevice;

  HMSAudioDevice currentAudioDeviceMode = HMSAudioDevice.AUTOMATIC;

  bool showAudioDeviceChangePopup = false;

  bool selfChangeAudioDevice = false;

  bool isRaisedHand = false;

  int trackChange = -1;

  VideoPlayerController? hlsVideoController;

  bool hlsStreamingRetry = false;

  bool isTrackSettingApplied = false;

  double audioPlayerVolume = 1.0;

  Future<bool> join(String user, String roomUrl) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init",
        captureNetworkQualityInPreview: true);

    _hmsSDKInteractor.addUpdateListener(this);
    WidgetsBinding.instance!.addObserver(this);
    _hmsSDKInteractor.join(config: config);
    this.meetingUrl = roomUrl;
    return true;
  }

  //HMSSDK Methods

  void leave() async {
    _hmsSDKInteractor.removeStatsListener(this);
    WidgetsBinding.instance!.removeObserver(this);
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
    _hmsSDKInteractor.destroy();
  }

  Future<void> switchAudio() async {
    await _hmsSDKInteractor.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
    notifyListeners();
  }

  Future<void> switchVideo() async {
    await _hmsSDKInteractor.switchVideo(isOn: isVideoOn);
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (isVideoOn) {
      await _hmsSDKInteractor.switchCamera();
    }
  }

  void sendBroadcastMessage(String message) {
    _hmsSDKInteractor.sendBroadcastMessage(message, this);
  }

  void sendDirectMessage(String message, HMSPeer peer) async {
    _hmsSDKInteractor.sendDirectMessage(message, peer, this);
  }

  void sendGroupMessage(String message, List<HMSRole> roles) async {
    _hmsSDKInteractor.sendGroupMessage(message, roles, this);
  }

  void endRoom(bool lock, String? reason) {
    _hmsSDKInteractor.endRoom(lock, reason == null ? "" : reason, this);
    _hmsSDKInteractor.destroy();
  }

  void removePeerFromRoom(HMSPeer peer) {
    _hmsSDKInteractor.removePeer(peer, this);
  }

  void startScreenShare() {
    _hmsSDKInteractor.startScreenShare(hmsActionResultListener: this);
  }

  void stopScreenShare() {
    _hmsSDKInteractor.stopScreenShare(hmsActionResultListener: this);
  }

  void muteAll() {
    _hmsSDKInteractor.muteAll();
  }

  void unMuteAll() {
    _hmsSDKInteractor.unMuteAll();
  }

  void startAudioShare() {
    _hmsSDKInteractor.startAudioShare(hmsActionResultListener: this);
  }

  void stopAudioShare() {
    _hmsSDKInteractor.stopAudioShare(hmsActionResultListener: this);
  }

  void setAudioMixingMode(HMSAudioMixingMode audioMixingMode) {
    _hmsSDKInteractor.setAudioMixingMode(audioMixingMode);
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isAudioMute(peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isVideoMute(peer);
  }

  Future<bool> startCapturing() async {
    isVideoOn = true;
    notifyListeners();
    return await _hmsSDKInteractor.startCapturing();
  }

  void stopCapturing() {
    isVideoOn = false;
    notifyListeners();
    _hmsSDKInteractor.stopCapturing();
  }

  Future<void> isScreenShareActive() async {
    this.isScreenShareOn = await _hmsSDKInteractor.isScreenShareActive();
  }

  void changeStatsVisible() {
    if (!isStatsVisible) {
      _hmsSDKInteractor.addStatsListener(this);
    } else {
      _hmsSDKInteractor.removeStatsListener(this);
    }
    isStatsVisible = !isStatsVisible;
    notifyListeners();
  }

  void changeRole(
      {required HMSPeer peer,
      required HMSRole roleName,
      bool forceChange = false}) {
    _hmsSDKInteractor.changeRole(
        toRole: roleName,
        forPeer: peer,
        force: forceChange,
        hmsActionResultListener: this);
  }

  Future<List<HMSRole>> getRoles() async {
    return await _hmsSDKInteractor.getRoles();
  }

  void changeTrackState(HMSTrack track, bool mute) {
    return _hmsSDKInteractor.changeTrackState(track, mute, this);
  }

  Future<HMSLocalPeer?> getLocalPeer() async {
    return await _hmsSDKInteractor.getLocalPeer();
  }

  void startRtmpOrRecording(
      {required String meetingUrl,
      required bool toRecord,
      List<String>? rtmpUrls}) async {
    HMSRecordingConfig hmsRecordingConfig = new HMSRecordingConfig(
        meetingUrl: meetingUrl, toRecord: toRecord, rtmpUrls: rtmpUrls);

    _hmsSDKInteractor.startRtmpOrRecording(hmsRecordingConfig, this);
  }

  void stopRtmpAndRecording() async {
    _hmsSDKInteractor.stopRtmpAndRecording(this);
  }

  Future<HMSRoom?> getRoom() async {
    HMSRoom? room = await _hmsSDKInteractor.getRoom();
    return room;
  }

  Future<HMSPeer?> getPeer({required String peerId}) async {
    return await _hmsSDKInteractor.getPeer(peerId: peerId);
  }

  void changeMetadata() {
    isRaisedHand = !isRaisedHand;
    isBRB = false;
    String value = isRaisedHand ? "true" : "false";
    _hmsSDKInteractor.changeMetadata(
        metadata: "{\"isHandRaised\":$value,\"isBRBOn\":false}",
        hmsActionResultListener: this);
  }

  bool isBRB = false;

  void changeMetadataBRB() {
    isBRB = !isBRB;
    isRaisedHand = false;
    String value = isBRB ? "true" : "false";
    _hmsSDKInteractor.changeMetadata(
        metadata: "{\"isHandRaised\":false,\"isBRBOn\":$value}",
        hmsActionResultListener: this);
    if (isMicOn) {
      switchAudio();
    }
    if (isVideoOn) {
      switchVideo();
    }
    notifyListeners();
  }

  void setPlayBackAllowed(bool allow) {
    _hmsSDKInteractor.setPlayBackAllowed(allow);
  }

  void acceptChangeRole(HMSRoleChangeRequest hmsRoleChangeRequest) {
    _hmsSDKInteractor.acceptChangeRole(hmsRoleChangeRequest, this);
  }

  void changeName({required String name}) {
    _hmsSDKInteractor.changeName(name: name, hmsActionResultListener: this);
  }

  HMSHLSRecordingConfig? hmshlsRecordingConfig;
  void startHLSStreaming(bool singleFile, bool videoOnDemand) {
    hmshlsRecordingConfig = HMSHLSRecordingConfig(
        singleFilePerLayer: singleFile, videoOnDemand: videoOnDemand);
    _hmsSDKInteractor.startHLSStreaming(this,
        hmshlsRecordingConfig: hmshlsRecordingConfig!);
  }

  void stopHLSStreaming() {
    _hmsSDKInteractor.stopHLSStreaming(hmsActionResultListener: this);
  }

  void changeTrackStateForRole(bool mute, List<HMSRole>? roles) {
    _hmsSDKInteractor.changeTrackStateForRole(
        true, HMSTrackKind.kHMSTrackKindAudio, "regular", roles, this);
  }

  void setSettings() {
    isMirror = _hmsSDKInteractor.mirrorCamera;
    isStatsVisible = _hmsSDKInteractor.showStats;
    if (isStatsVisible) {
      _hmsSDKInteractor.addStatsListener(this);
    }
  }

  Future<List<HMSPeer>?> getPeers() async {
    return await _hmsSDKInteractor.getPeers();
  }

  Future<void> getAudioDevicesList() async {
    availableAudioOutputDevices.clear();
    availableAudioOutputDevices
        .addAll(await _hmsSDKInteractor.getAudioDevicesList());
    notifyListeners();
  }

  Future<void> getCurrentAudioDevice() async {
    currentAudioOutputDevice = await _hmsSDKInteractor.getCurrentAudioDevice();
    notifyListeners();
  }

  void switchAudioOutput(HMSAudioDevice audioDevice) {
    selfChangeAudioDevice = true;
    currentAudioDeviceMode = audioDevice;
    _hmsSDKInteractor.switchAudioOutput(audioDevice);
  }

// Override Methods

  @override
  void onJoin({required HMSRoom room}) async {
    isMeetingStarted = true;
    hmsRoom = room;
    if (room.hmshlsStreamingState?.running ?? false) {
      hasHlsStarted = true;
      streamUrl = room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl ?? "";
    } else {
      hasHlsStarted = false;
    }
    if (room.hmsBrowserRecordingState?.running == true) {
      recordingType["browser"] = true;
    }
    if (room.hmsServerRecordingState?.running == true) {
      recordingType["server"] = true;
    }
    if (room.hmshlsRecordingState?.running == true) {
      recordingType["hls"] = true;
    }
    if (room.hmsRtmpStreamingState?.running == true) {
      streamingType["rtmp"] = true;
    }
    if (room.hmshlsStreamingState?.running == true) {
      streamingType["hls"] = true;
    }
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index = peerTracks
            .indexWhere((element) => element.uid == each.peerId + "mainVideo");
        if (index == -1)
          peerTracks.add(PeerTrackNode(
              peer: each,
              uid: each.peerId + "mainVideo",
              networkQuality: localPeerNetworkQuality,
              stats: RTCStats()));
        localPeer = each;
        addPeer(localPeer!);
        if (localPeer!.role.name.contains("hls-") == true) isHLSLink = true;
        index = peerTracks
            .indexWhere((element) => element.uid == each.peerId + "mainVideo");
        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            peerTracks[index].track = each.videoTrack!;
            if (each.videoTrack!.isMute) {
              this.isVideoOn = false;
            }
          }
        }
        if (each.audioTrack != null) {
          if (each.audioTrack!.kind == HMSTrackKind.kHMSTrackKindAudio) {
            peerTracks[index].audioTrack = each.audioTrack!;
            if (each.audioTrack!.isMute) {
              this.isMicOn = false;
            }
          }
        }
        break;
      }
    }
    roles = await getRoles();
    Utilities.saveStringData(key: "meetingLink", value: this.meetingUrl);
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        recordingType["browser"] =
            room.hmsBrowserRecordingState?.running ?? false;
        break;
      case HMSRoomUpdate.serverRecordingStateUpdated:
        recordingType["server"] =
            room.hmsServerRecordingState?.running ?? false;
        break;
      case HMSRoomUpdate.hlsRecordingStateUpdated:
        recordingType["hls"] = room.hmshlsRecordingState?.running ?? false;
        break;
      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        streamingType["rtmp"] = room.hmsRtmpStreamingState?.running ?? false;
        break;
      case HMSRoomUpdate.hlsStreamingStateUpdated:
        isHLSLoading = false;
        streamingType["hls"] = room.hmshlsStreamingState?.running ?? false;
        hasHlsStarted = room.hmshlsStreamingState?.running ?? false;
        streamUrl = hasHlsStarted
            ? room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl ?? ""
            : "";
        Utilities.showToast(room.hmshlsStreamingState?.running ?? false
            ? "HLS Streaming Started"
            : "HLS Streaming Stopped");
        break;
      default:
        break;
    }
    hmsRoom = room;
    notifyListeners();
  }

  @override
  void onPeerUpdate(
      {required HMSPeer peer, required HMSPeerUpdate update}) async {
    peerOperation(peer, update);
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (isSpeakerOn) {
      unMuteAll();
    } else {
      muteAll();
    }

    if (peer.isLocal) {
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio &&
          track.source == "REGULAR") {
        this.isMicOn = !track.isMute;
      }
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo &&
          track.source == "REGULAR") {
        this.isVideoOn = !track.isMute;
      }
      notifyListeners();
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      int index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.audioTrack = track as HMSAudioTrack;
        peerTrackNode.notify();
      }
      return;
    }

    if (track.source == "REGULAR") {
      int index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.track = track as HMSVideoTrack;
        peerTrackNode.notify();
        if (meetingMode == MeetingMode.Single) {
          rearrangeTile(peerTrackNode, index);
        }
      } else {
        return;
      }
    }
    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onHMSError({required HMSException error}) {
    this.hmsException = error;

    notifyListeners();
  }

  @override
  void onMessage({required HMSMessage message}) {
    addMessage(message);
    isNewMessageReceived = true;
    notifyListeners();
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    this.currentRoleChangeRequest = roleChangeRequest;
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    if (updateSpeakers.isNotEmpty) {
      highestSpeaker = updateSpeakers[0].peer.name;
    } else {
      highestSpeaker = null;
    }
    activeSpeakerIds.clear();
    updateSpeakers.forEach((element) {
      activeSpeakerIds[element.peer.peerId + "mainVideo"] = element.audioLevel;
    });
    int firstScreenPeersCount = (meetingMode == MeetingMode.Audio) ? 6 : 4;
    if ((isActiveSpeakerMode && peerTracks.length > firstScreenPeersCount) ||
        meetingMode == MeetingMode.Hero) {
      List<HMSSpeaker> activeSpeaker = [];
      if (updateSpeakers.length > firstScreenPeersCount) {
        activeSpeaker.addAll(updateSpeakers.sublist(0, firstScreenPeersCount));
      } else {
        activeSpeaker.addAll(updateSpeakers);
      }
      for (int i = activeSpeaker.length - 1; i > -1; i--) {
        if (isActiveSpeakerMode) {
          List<PeerTrackNode> tempTracks = peerTracks.sublist(
              screenShareCount, screenShareCount + firstScreenPeersCount);
          int indexTrack = tempTracks.indexWhere(
              (peer) => activeSpeaker[i].peer.peerId + "mainVideo" == peer.uid);
          if (indexTrack != -1) {
            continue;
          }
        }
        int index = peerTracks.indexWhere(
            (peer) => activeSpeaker[i].peer.peerId + "mainVideo" == peer.uid);
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks.removeAt(index);
          peerTracks.insert(screenShareCount, peerTrackNode);
        }
      }
    }
    notifyListeners();
  }

  @override
  void onReconnecting() {
    reconnected = false;
    reconnecting = true;
  }

  @override
  void onReconnected() {
    reconnecting = false;
    reconnected = true;
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    if (!hmsTrackChangeRequest.mute) {
      this.hmsTrackChangeRequest = hmsTrackChangeRequest;
    } else {
      if (hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        isVideoOn = false;
      } else {
        isMicOn = false;
      }
    }
    notifyListeners();
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    description = "Removed by ${hmsPeerRemovedFromPeer.peerWhoRemoved?.name}";
    peerTracks.clear();
    isRoomEnded = true;

    notifyListeners();
  }

  @override
  void onLocalAudioStats(
      {required HMSLocalAudioStats hmsLocalAudioStats,
      required HMSLocalAudioTrack track,
      required HMSPeer peer}) {
    int index = -1;
    if (track.source != "REGULAR") {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + track.trackId);
    } else {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
    }
    if (index != -1) {
      peerTracks[index].stats?.hmsLocalAudioStats = hmsLocalAudioStats;
      peerTracks[index].notify();
    }
  }

  @override
  void onLocalVideoStats(
      {required HMSLocalVideoStats hmsLocalVideoStats,
      required HMSLocalVideoTrack track,
      required HMSPeer peer}) {
    int index = -1;
    if (track.source != "REGULAR") {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + track.trackId);
    } else {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
    }
    if (index != -1) {
      peerTracks[index].stats?.hmsLocalVideoStats = hmsLocalVideoStats;
      peerTracks[index].notify();
    }
  }

  @override
  void onRemoteAudioStats(
      {required HMSRemoteAudioStats hmsRemoteAudioStats,
      required HMSRemoteAudioTrack track,
      required HMSPeer peer}) {
    int index = -1;
    if (track.source != "REGULAR") {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + track.trackId);
    } else {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
    }
    if (index != -1) {
      peerTracks[index].stats?.hmsRemoteAudioStats = hmsRemoteAudioStats;
      peerTracks[index].notify();
    }
  }

  @override
  void onRemoteVideoStats(
      {required HMSRemoteVideoStats hmsRemoteVideoStats,
      required HMSRemoteVideoTrack track,
      required HMSPeer peer}) {
    int index = -1;
    if (track.source != "REGULAR") {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + track.trackId);
    } else {
      index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
    }
    if (index != -1) {
      peerTracks[index].stats?.hmsRemoteVideoStats = hmsRemoteVideoStats;
      peerTracks[index].notify();
    }
  }

  @override
  void onRTCStats({required HMSRTCStatsReport hmsrtcStatsReport}) {}

  void toggleSpeaker() {
    if (isSpeakerOn) {
      muteAll();
    } else {
      unMuteAll();
    }
    isSpeakerOn = !isSpeakerOn;
    notifyListeners();
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    if (currentAudioDeviceMode != HMSAudioDevice.AUTOMATIC &&
        !selfChangeAudioDevice) {
      this.showAudioDeviceChangePopup = true;
    }
    if (selfChangeAudioDevice) {
      selfChangeAudioDevice = false;
    }
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

// Helper Methods

  void toggleScreenShare() {
    if (!isScreenShareOn) {
      startScreenShare();
    } else {
      stopScreenShare();
    }
  }

  void removePeer(HMSPeer peer) {
    peers.remove(peer);
    if (filteredPeers.contains(peer)) filteredPeers.remove(peer);
  }

  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
    if (checkForFilteredList(peer)) filteredPeers.add(peer);
  }

  void addMessage(HMSMessage message) {
    this.messages.add(message);
  }

  void updatePeerAt(HMSPeer peer) {
    int index = this.peers.indexOf(peer);
    this.peers.removeAt(index);
    this.peers.insert(index, peer);
    // notifyListeners();
  }

  void updateFilteredList(HMSPeerUpdate peerUpdate, HMSPeer peer) {
    String currentRole = this.selectedRoleFilter;
    int index =
        filteredPeers.indexWhere((element) => element.peerId == peer.peerId);

    if (index != -1) {
      this.filteredPeers.removeAt(index);
      if ((peerUpdate == HMSPeerUpdate.nameChanged)) {
        this.filteredPeers.insert(index, peer);
      } else if (peerUpdate == HMSPeerUpdate.metadataChanged) {
        if ((peer.metadata?.contains("\"isHandRaised\":true") ?? false) ||
            ((currentRole == "Everyone") || (currentRole == peer.role.name))) {
          this.filteredPeers.insert(index, peer);
        }
      } else if (peerUpdate == HMSPeerUpdate.roleUpdated &&
          ((currentRole == "Everyone") || (currentRole == "Raised Hand"))) {
        this.filteredPeers.insert(index, peer);
      }
    } else {
      if ((peerUpdate == HMSPeerUpdate.metadataChanged &&
              currentRole == "Raised Hand") ||
          (peerUpdate == HMSPeerUpdate.roleUpdated &&
              currentRole == peer.role.name)) {
        this.filteredPeers.add(peer);
      }
    }
  }

  void setLandscapeLock(bool value) {
    if (value) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
    isLandscapeLocked = value;
    notifyListeners();
  }

  void changeTracks(HMSTrackChangeRequest hmsTrackChangeRequest) {
    if (hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switchVideo();
    } else {
      switchAudio();
    }
  }

  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (peer.role.name.contains("hls-") == false) {
          int index = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + "mainVideo");
          if (index == -1)
            peerTracks.add(new PeerTrackNode(
                peer: peer, uid: peer.peerId + "mainVideo", stats: RTCStats()));
          notifyListeners();
        }
        addPeer(peer);
        break;

      case HMSPeerUpdate.peerLeft:
        peerTracks.removeWhere(
            (leftPeer) => leftPeer.uid == peer.peerId + "mainVideo");
        int index = peerTracks
            .indexWhere((element) => element.peer.peerId == peer.peerId);
        if (index != -1) {
          peerTracks.removeAt(index);
          screenShareCount--;
        }
        removePeer(peer);
        notifyListeners();
        break;

      case HMSPeerUpdate.roleUpdated:
        if (peer.isLocal) localPeer = peer;
        if (peer.role.name.contains("hls-")) {
          isHLSLink = peer.isLocal;
          peerTracks.removeWhere(
              (leftPeer) => leftPeer.uid == peer.peerId + "mainVideo");
        } else {
          if (peer.isLocal) {
            isHLSLink = false;
          }
          int index = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + "mainVideo");
          if (index == -1)
            peerTracks.add(new PeerTrackNode(
                peer: peer, uid: peer.peerId + "mainVideo", stats: RTCStats()));
        }
        Utilities.showToast("${peer.name}'s role changed to " + peer.role.name);
        updatePeerAt(peer);
        updateFilteredList(update, peer);

        notifyListeners();
        break;

      case HMSPeerUpdate.metadataChanged:
        if (peer.isLocal) localPeer = peer;
        int index = peerTracks
            .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks[index];
          peerTrackNode.peer = peer;
          peerTrackNode.notify();
        }
        updatePeerAt(peer);
        updateFilteredList(update, peer);
        break;

      case HMSPeerUpdate.nameChanged:
        if (peer.isLocal) {
          int localPeerIndex = peerTracks.indexWhere(
              (element) => element.uid == localPeer!.peerId + "mainVideo");
          if (localPeerIndex != -1) {
            PeerTrackNode peerTrackNode = peerTracks[localPeerIndex];
            peerTrackNode.peer = peer;
            localPeer = peer;
            peerTrackNode.notify();
            notifyListeners();
          }
        } else {
          int remotePeerIndex = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + "mainVideo");
          if (remotePeerIndex != -1) {
            PeerTrackNode peerTrackNode = peerTracks[remotePeerIndex];
            peerTrackNode.peer = peer;
            peerTrackNode.notify();
          }
        }
        updatePeerAt(peer);
        updateFilteredList(update, peer);
        break;

      case HMSPeerUpdate.networkQualityUpdated:
        int index = peerTracks
            .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
        if (index != -1) {
          peerTracks[index].networkQuality = peer.networkQuality?.quality;
          peerTracks[index].notify();
        }
        break;

      case HMSPeerUpdate.defaultUpdate:
        break;

      default:
    }
  }

  void peerOperationWithTrack(
      HMSPeer peer, HMSTrackUpdate update, HMSTrack track) {
    switch (update) {
      case HMSTrackUpdate.trackAdded:
        if (track.source != "REGULAR") {
          int peerIndex = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + track.trackId);
          if (peerIndex == -1) {
            screenShareCount++;
            peerTracks.insert(
                0,
                PeerTrackNode(
                    peer: peer,
                    uid: peer.peerId + track.trackId,
                    track: track as HMSVideoTrack,
                    stats: RTCStats()));
            isScreenShareActive();
            notifyListeners();
          }
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          int peerIndex = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + track.trackId);
          if (peerIndex != -1) {
            screenShareCount--;
            peerTracks.removeWhere(
                (element) => element.uid == peer.peerId + track.trackId);
            if (screenShareCount == 0) {
              setLandscapeLock(false);
            }
            isScreenShareActive();
            notifyListeners();
          }
        }
        break;
      case HMSTrackUpdate.trackMuted:
        break;
      case HMSTrackUpdate.trackUnMuted:
        break;
      case HMSTrackUpdate.trackDescriptionChanged:
        break;
      case HMSTrackUpdate.trackDegraded:
        break;
      case HMSTrackUpdate.trackRestored:
        break;
      case HMSTrackUpdate.defaultUpdate:
        break;
      default:
    }
  }

  // Logs are currently turned Off
  // @override
  // void onLogMessage({required dynamic HMSLogList}) async {
  // StaticLogger.logger?.v(HMSLogList.toString());
  //   FirebaseCrashlytics.instance.log(HMSLogList.toString());
  // }

  // void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
  //   HmsSdkManager.hmsSdkInteractor?.startHMSLogger(webRtclogLevel, logLevel);
  // }
  //
  // void addLogsListener() {
  //   HmsSdkManager.hmsSdkInteractor?.addLogsListener(this);
  // }
  //
  // void removeLogsListener() {
  //   HmsSdkManager.hmsSdkInteractor?.removeLogsListener(this);
  // }
  //
  // void removeHMSLogger() {
  //   HmsSdkManager.hmsSdkInteractor?.removeHMSLogger();
  // }

  void setMode(MeetingMode meetingMode) {
    switch (meetingMode) {
      case MeetingMode.Video:
        break;
      case MeetingMode.Audio:
        setPlayBackAllowed(false);
        break;
      case MeetingMode.Hero:
        if (this.meetingMode == MeetingMode.Audio) {
          setPlayBackAllowed(true);
        }
        this.isActiveSpeakerMode = false;
        break;
      case MeetingMode.Single:
        if (this.meetingMode == MeetingMode.Audio) {
          setPlayBackAllowed(true);
        }
        int type0 = 0;
        int type1 = peerTracks.length - 1;
        while (type0 < type1) {
          if (peerTracks[type0].track?.isMute ?? true) {
            if (peerTracks[type1].track != null &&
                peerTracks[type1].track!.isMute == false) {
              PeerTrackNode peerTrackNode = peerTracks[type0];
              peerTracks[type0] = peerTracks[type1];
              peerTracks[type1] = peerTrackNode;
            }
            type1--;
          } else
            type0++;
        }
        this.isActiveSpeakerMode = false;
        break;
      default:
    }
    this.meetingMode = meetingMode;
    notifyListeners();
  }

  void setActiveSpeakerMode() {
    this.isActiveSpeakerMode = !this.isActiveSpeakerMode;
    if (meetingMode == MeetingMode.Hero || meetingMode == MeetingMode.Single)
      this.meetingMode = MeetingMode.Video;
    notifyListeners();
  }

  rearrangeTile(PeerTrackNode peerTrackNode, int index) {
    if (peerTrackNode.track!.isMute) {
      if (peerTracks.length - 1 > index &&
          (peerTracks[index + 1].track?.isMute ?? true)) {
        return;
      } else {
        peerTracks.removeAt(index);
        peerTracks.add(peerTrackNode);
        notifyListeners();
      }
    } else {
      if (index != 0 &&
          (peerTracks[index - 1].track != null &&
              peerTracks[index - 1].track!.isMute == false)) {
        return;
      } else {
        peerTracks.removeAt(index);
        peerTracks.insert(screenShareCount, peerTrackNode);
        notifyListeners();
      }
    }
  }

  void setNewMessageFalse() {
    if (!isNewMessageReceived) return;
    this.isNewMessageReceived = false;
    notifyListeners();
  }

  void setMessageInfoFalse() {
    isMessageInfoShown = false;
    notifyListeners();
  }

  int isActiveSpeaker(String uid) {
    return activeSpeakerIds.containsKey(uid) ? activeSpeakerIds[uid]! : -1;
  }

  void getFilteredList(String type) {
    filteredPeers.clear();
    filteredPeers.addAll(peers);
    filteredPeers.removeWhere((element) => element.isLocal);
    filteredPeers.sortedBy(((element) => element.role.priority.toString()));
    filteredPeers.insert(0, localPeer!);
    if (type == "Everyone") {
      return;
    } else if (type == "Raised Hand") {
      filteredPeers = filteredPeers
          .where((element) =>
              element.metadata != null &&
              element.metadata!.contains("\"isHandRaised\":true"))
          .toList();
    } else {
      filteredPeers =
          filteredPeers.where((element) => element.role.name == type).toList();
    }
    notifyListeners();
  }

  bool checkForFilteredList(HMSPeer peer) {
    if ((selectedRoleFilter == "Everyone") ||
        (peer.role.name == selectedRoleFilter)) {
      return true;
    }
    return false;
  }

  HMSAudioFilePlayerNode audioFilePlayerNode =
      HMSAudioFilePlayerNode("audioFilePlayerNode");
  HMSMicNode micNode = HMSMicNode();
  // void setTrackSettings() async {
  //   HMSTrackSetting trackSetting = HMSTrackSetting(
  //       audioTrackSetting: HMSAudioTrackSetting(
  //           maxBitrate: 32,
  //           audioSource: HMSAudioMixerSource(node: [
  //             HMSAudioFilePlayerNode("audioFilePlayerNode"),
  //             HMSMicNode()
  //           ])),
  //       videoTrackSetting: HMSVideoTrackSetting(
  //           cameraFacing: HMSCameraFacing.FRONT,
  //           maxBitrate: 512,
  //           maxFrameRate: 25,
  //           resolution: HMSResolution(height: 180, width: 320)));
  //   _hmsSDKInteractor.setTrackSettings(hmsTrackSetting: trackSetting);
  //   isTrackSettingApplied = true;
  //   notifyListeners();
  // }

  void playAudioIos(String url) {
    audioFilePlayerNode.play(fileUrl: url);
  }

  Future<bool> isPlayerRunningIos() async {
    bool isPlaying = await audioFilePlayerNode.isPlaying();
    return isPlaying;
  }

  void stopAudioIos() {
    audioFilePlayerNode.stop();
  }

  void setAudioPlayerVolume(double volume) {
    audioFilePlayerNode.setVolume(volume);
    audioPlayerVolume = volume;
  }

//Get onSuccess or onException callbacks for HMSActionResultListenerMethod

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        peerTracks.clear();
        isRoomEnded = true;
        screenShareCount = 0;
        this.meetingMode = MeetingMode.Video;
        isScreenShareOn = false;
        isAudioShareStarted = false;
        _hmsSDKInteractor.removeUpdateListener(this);
        setLandscapeLock(false);
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        Utilities.showToast("Track State Changed");
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.endRoom:
        this.isRoomEnded = true;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.removePeer:
        HMSPeer peer = arguments!['peer'];
        Utilities.showToast("Removed ${peer.name} from room");
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        Utilities.showToast("Accept role change successful");
        break;
      case HMSActionResultListenerMethod.changeRole:
        Utilities.showToast("Change role successful");
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        message = arguments!['roles'] == null
            ? "Successfully Muted All"
            : "Successfully Muted Role";
        Utilities.showToast(message);
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        if (arguments != null) {
          if (arguments["rtmp_urls"].length == 0 && arguments["to_record"]) {
            Utilities.showToast("Recording Started");
          } else if (arguments["rtmp_urls"].length != 0 &&
              arguments["to_record"] == false) {
            Utilities.showToast("RTMP Started");
          }
        }
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        Utilities.showToast("Stopped successfully");
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.changeName:
        Utilities.showToast("Change name successful");
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        var message = HMSMessage(
            sender: localPeer,
            message: arguments!['message'],
            type: arguments['type'],
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: null,
                recipientRoles: null,
                hmsMessageRecipientType: HMSMessageRecipientType.BROADCAST));
        addMessage(message);
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        var message = HMSMessage(
            sender: localPeer,
            message: arguments!['message'],
            type: arguments['type'],
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: null,
                recipientRoles: arguments['roles'],
                hmsMessageRecipientType: HMSMessageRecipientType.GROUP));
        addMessage(message);
        notifyListeners();

        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        var message = HMSMessage(
            sender: localPeer,
            message: arguments!['message'],
            type: arguments['type'],
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: arguments['peer'],
                recipientRoles: null,
                hmsMessageRecipientType: HMSMessageRecipientType.DIRECT));
        addMessage(message);
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        isHLSLoading = true;
        hlsStreamingRetry = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        hasHlsStarted = false;
        Utilities.showToast("HLS Streaming Stopped");
        notifyListeners();
        break;

      case HMSActionResultListenerMethod.startScreenShare:
        Utilities.showToast("Screen Share Started");
        isScreenShareActive();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        Utilities.showToast("Screen Share Stopped");
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        Utilities.showToast("Audio Share Started");
        isAudioShareStarted = true;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        Utilities.showToast("Audio Share Stopped");
        isAudioShareStarted = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.setTrackSettings:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    this.hmsException = hmsException;
    FirebaseCrashlytics.instance.log(hmsException.toString());
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        Utilities.showToast("Leave Operation failed");
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        Utilities.showToast("Change Track state failed");
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        Utilities.showToast("End room failed");
        break;
      case HMSActionResultListenerMethod.removePeer:
        Utilities.showToast("Remove peer failed");
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        Utilities.showToast("Accept change role failed");
        break;
      case HMSActionResultListenerMethod.changeRole:
        Utilities.showToast("Change role failed");
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        Utilities.showToast("Failed to change track state");
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        if (arguments != null) {
          if (arguments["rtmp_urls"].length == 0 && arguments["to_record"]) {
            Utilities.showToast("Recording failed");
          } else if (arguments["rtmp_urls"].length != 0 &&
              arguments["to_record"] == false) {
            Utilities.showToast("RTMP failed");
          }
        }
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        Utilities.showToast("Stop RTMP Streaming failed");
        break;
      case HMSActionResultListenerMethod.changeName:
        Utilities.showToast("Name change failed");
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        Utilities.showToast("Sending broadcast message failed");
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        Utilities.showToast("Sending group message failed");
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        Utilities.showToast("Sending direct message failed");
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        if (!hlsStreamingRetry) {
          _hmsSDKInteractor.startHLSStreaming(this,
              meetingUrl: Constant.streamingUrl,
              hmshlsRecordingConfig: hmshlsRecordingConfig!);
          hlsStreamingRetry = true;
        } else {
          Utilities.showToast("Start HLS failed");
          hlsStreamingRetry = false;
        }

        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        Utilities.showToast("Stop HLS failed");
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        isScreenShareActive();
        Utilities.showToast("Start screenshare failed");
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        isScreenShareActive();
        Utilities.showToast("Stop screenshare failed");
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        Utilities.showToast("Start audio share failed");
        isAudioShareStarted = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        Utilities.showToast("Stop audio share failed");
        break;
      case HMSActionResultListenerMethod.setTrackSettings:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (isRoomEnded) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (localPeer?.role.name.contains("hls-") ?? false)
          hlsVideoController = new VideoPlayerController.network(
            streamUrl,
          )..initialize().then((_) {
              hlsVideoController!.play();
              notifyListeners();
            });
      });
      List<HMSPeer>? peersList = await getPeers();

      peersList?.forEach((element) {
        if (!element.isLocal) {
          (element.audioTrack as HMSRemoteAudioTrack?)?.setVolume(10.0);
          element.auxiliaryTracks?.forEach((element) {
            if (element.kind == HMSTrackKind.kHMSTrackKindAudio) {
              (element as HMSRemoteAudioTrack?)?.setVolume(10.0);
            }
          });
        }
      });
    } else if (state == AppLifecycleState.paused) {
      HMSLocalPeer? localPeer = await getLocalPeer();
      if (localPeer?.role.name.contains("hls-") ?? false) {
        hlsVideoController?.dispose();
        hlsVideoController = null;
        notifyListeners();
      }
      if (localPeer != null && !(localPeer.videoTrack?.isMute ?? true)) {
        switchVideo();
      }
      for (PeerTrackNode peerTrackNode in peerTracks) {
        peerTrackNode.setOffScreenStatus(true);
      }
    } else if (state == AppLifecycleState.inactive) {
      HMSLocalPeer? localPeer = await getLocalPeer();
      if (localPeer != null && !(localPeer.videoTrack?.isMute ?? true)) {
        switchVideo();
      }
      for (PeerTrackNode peerTrackNode in peerTracks) {
        peerTrackNode.setOffScreenStatus(true);
      }
    }
  }
}
