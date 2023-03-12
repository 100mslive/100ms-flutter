//Package imports
import 'dart:developer';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hmssdk_flutter_example/service/constant.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:pip_flutter/pipflutter_player_configuration.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:pip_flutter/pipflutter_player_controls_configuration.dart';
import 'package:pip_flutter/pipflutter_player_data_source.dart';
import 'package:pip_flutter/pipflutter_player_data_source_type.dart';
import 'package:pip_flutter/pipflutter_player_event.dart';
import 'package:pip_flutter/pipflutter_player_event_type.dart';
import 'package:pip_flutter/pipflutter_player_theme.dart';

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

  String? streamUrl = "";

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

  List<HMSPeer> peers = [];

  List<HMSPeer> filteredPeers = [];

  String selectedRoleFilter = "Everyone";

  HMSPeer? localPeer;

  bool isActiveSpeakerMode = true;

  List<HMSTrack> audioTracks = [];

  List<HMSMessage> messages = [];

  List<PeerTrackNode> peerTracks = [];

  List<String> activeSpeakerIds = [];

  HMSRoom? hmsRoom;

  int? localPeerNetworkQuality;

  bool isStatsVisible = false;

  bool isMirror = false;

  bool isAutoSimulcast = true;

  bool isNewMessageReceived = false;

  int firstTimeBuild = 0;

  String message = "";

  final DateFormat formatter = DateFormat('d MMM y h:mm:ss a');

  ScrollController controller = ScrollController();

  MeetingMode meetingMode = MeetingMode.Video;

  bool isLandscapeLocked = false;

  bool isMessageInfoShown = true;

  String meetingUrl = "";
  bool isAudioShareStarted = false;

  List<HMSAudioDevice> availableAudioOutputDevices = [];

  HMSAudioDevice? currentAudioOutputDevice;

  HMSAudioDevice currentAudioDeviceMode = Platform.isAndroid
      ? HMSAudioDevice.AUTOMATIC
      : HMSAudioDevice.SPEAKER_PHONE;

  bool showAudioDeviceChangePopup = false;

  bool selfChangeAudioDevice = false;

  bool isRaisedHand = false;

  int trackChange = -1;

  // VideoPlayerController? hlsVideoController;

  PipFlutterPlayerController? hlsVideoController;
  final GlobalKey pipFlutterPlayerKey = GlobalKey();

  bool hlsStreamingRetry = false;

  bool isTrackSettingApplied = false;

  double audioPlayerVolume = 1.0;

  bool retryHLS = true;

  String? sessionMetadata;

  bool isPipActive = false;

  bool isPipAutoEnabled = false;

  bool lastVideoStatus = false;

  double hlsAspectRatio = 16 / 9;

  bool showNotification = false;

  HMSVideoTrack? currentPIPtrack;

  Future<bool> join(String user, String roomUrl) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
      authToken: token[0]!,
      userName: user,
      captureNetworkQualityInPreview: true,
      // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
      endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init",
    );

    _hmsSDKInteractor.addUpdateListener(this);
    WidgetsBinding.instance.addObserver(this);
    _hmsSDKInteractor.join(config: config);
    this.meetingUrl = roomUrl;
    return true;
  }

  //HMSSDK Methods

  void leave() async {
    _hmsSDKInteractor.removeStatsListener(this);
    WidgetsBinding.instance.removeObserver(this);
    hmsException = null;
    if ((localPeer?.role.name.contains("hls-") ?? false) && hasHlsStarted) {
      hlsVideoController!.dispose(forceDispose: true);
      hlsVideoController = null;
    }
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
    _hmsSDKInteractor.destroy();
  }

  Future<void> toggleMicMuteState() async {
    await _hmsSDKInteractor.toggleMicMuteState();
    isMicOn = !isMicOn;
    notifyListeners();
  }

  Future<void> toggleCameraMuteState() async {
    await _hmsSDKInteractor.toggleCameraMuteState();
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (isVideoOn) {
      await _hmsSDKInteractor.switchCamera(hmsActionResultListener: this);
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

  void muteRoomAudioLocally() {
    _hmsSDKInteractor.muteRoomAudioLocally();
  }

  void unMuteRoomAudioLocally() {
    _hmsSDKInteractor.unMuteRoomAudioLocally();
  }

  void muteRoomVideoLocally() {
    _hmsSDKInteractor.muteRoomVideoLocally();
  }

  void unMuteRoomVideoLocally() {
    _hmsSDKInteractor.unMuteRoomVideoLocally();
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

  Future<void> isScreenShareActive() async {
    this.isScreenShareOn = await _hmsSDKInteractor.isScreenShareActive();
  }

  void changeStatsVisible() {
    isStatsVisible = !isStatsVisible;
    notifyListeners();
  }

  void attachStatsListener() {
    if (isStatsVisible) {
      return;
    } else {
      _hmsSDKInteractor.addStatsListener(this);
    }
  }

  void removeStatsListener() {
    if (isStatsVisible) {
      return;
    } else {
      _hmsSDKInteractor.removeStatsListener(this);
    }
  }

  void changeRoleOfPeer(
      {required HMSPeer peer,
      required HMSRole roleName,
      bool forceChange = false}) {
    _hmsSDKInteractor.changeRoleOfPeer(
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
      toggleMicMuteState();
    }
    if (isVideoOn) {
      toggleCameraMuteState();
    }
    notifyListeners();
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
    retryHLS = true;
  }

  void stopHLSStreaming() {
    _hmsSDKInteractor.stopHLSStreaming(hmsActionResultListener: this);
  }

  void changeTrackStateForRole(bool mute, List<HMSRole>? roles) {
    _hmsSDKInteractor.changeTrackStateForRole(
        true, HMSTrackKind.kHMSTrackKindAudio, "regular", roles, this);
  }

  void setSettings() async {
    isMirror = await Utilities.getBoolData(key: 'mirror-camera') ?? false;
    isStatsVisible = await Utilities.getBoolData(key: 'show-stats') ?? false;
    isAutoSimulcast =
        await Utilities.getBoolData(key: 'is-auto-simulcast') ?? true;
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
  }

  Future<void> getCurrentAudioDevice() async {
    currentAudioOutputDevice = await _hmsSDKInteractor.getCurrentAudioDevice();
  }

  void switchAudioOutput({required HMSAudioDevice audioDevice}) {
    selfChangeAudioDevice = true;
    currentAudioDeviceMode = audioDevice;
    _hmsSDKInteractor.switchAudioOutput(audioDevice: audioDevice);
  }

// Override Methods

  @override
  void onJoin({required HMSRoom room}) async {
    log("onJoin-> room: ${room.toString()}");
    isMeetingStarted = true;
    hmsRoom = room;
    if (room.hmshlsStreamingState?.running ?? false) {
      hasHlsStarted = true;
      streamUrl = room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl;
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
    roles.removeWhere((element) => element.name == "__internal_recorder");
    Utilities.saveStringData(key: "meetingLink", value: this.meetingUrl);
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();

    if (Platform.isIOS && !(isHLSLink)) {
      HMSIOSPIPController.setup(autoEnterPip: true, aspectRatio: [9, 16]);
    }

    FlutterForegroundTask.startService(
        notificationTitle: "100ms foreground service running",
        notificationText: "Tap to return to the app");
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    log("onRoomUpdate-> room: ${room.toString()} update: ${update.name}");
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
            ? room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl
            : null;
        Utilities.showToast(room.hmshlsStreamingState?.running ?? false
            ? "HLS Streaming Started"
            : "HLS Streaming Stopped");
        break;
      case HMSRoomUpdate.roomPeerCountUpdated:
        hmsRoom = room;
        return;
      default:
        return;
    }
    hmsRoom = room;
    notifyListeners();
  }

  @override
  void onPeerUpdate(
      {required HMSPeer peer, required HMSPeerUpdate update}) async {
    log("onPeerUpdate-> peer: ${peer.name} update: ${update.name}");
    peerOperation(peer, update);
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    log("onTrackUpdate-> track: ${track.toString()} peer: ${peer.name} update: ${trackUpdate.name}");
    if (peer.role.name.contains("hls-")) return;

    if (!isSpeakerOn &&
        track.kind == HMSTrackKind.kHMSTrackKindAudio &&
        trackUpdate == HMSTrackUpdate.trackAdded) {
      if (track.runtimeType == HMSRemoteAudioTrack) {
        HMSRemoteAudioTrack currentTrack = track as HMSRemoteAudioTrack;
        currentTrack.setPlaybackAllowed(false);
      }
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

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio &&
        trackUpdate != HMSTrackUpdate.trackRemoved) {
      int index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.audioTrack = track as HMSAudioTrack;
        peerTrackNode.notify();
      } else {
        peerTracks.add(new PeerTrackNode(
            peer: peer,
            uid: peer.peerId + "mainVideo",
            stats: RTCStats(),
            audioTrack: track as HMSAudioTrack));
        notifyListeners();
      }
      return;
    }

    if (track.source == "REGULAR" &&
        trackUpdate != HMSTrackUpdate.trackRemoved) {
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
        peerTracks.add(new PeerTrackNode(
            peer: peer,
            uid: peer.peerId + "mainVideo",
            stats: RTCStats(),
            track: track as HMSVideoTrack));
        notifyListeners();
        return;
      }
    }
    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onHMSError({required HMSException error}) {
    log("onHMSError-> error: ${error.message}");
    this.hmsException = error;
    Utilities.showNotification(error.message ?? "", "error");
    notifyListeners();
  }

  @override
  void onMessage({required HMSMessage message}) {
    log("onMessage-> sender: ${message.sender} message: ${message.message} time: ${message.time}, type: ${message.type}");
    switch (message.type) {
      case "metadata":
        getSessionMetadata();
        break;
      default:
        addMessage(message);
        isNewMessageReceived = true;
        Utilities.showNotification(
            "New message from ${message.sender?.name ?? ""}", "message");
        notifyListeners();
        break;
    }
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    log("onRoleChangeRequest-> sender: ${roleChangeRequest.suggestedBy} role: ${roleChangeRequest.suggestedRole}");
    this.currentRoleChangeRequest = roleChangeRequest;
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    if (activeSpeakerIds.isNotEmpty) {
      activeSpeakerIds.forEach((key) {
        int index = peerTracks.indexWhere((element) => element.uid == key);
        if (index != -1) {
          peerTracks[index].setAudioLevel(-1);
        }
      });
    }

    updateSpeakers.forEach((element) {
      activeSpeakerIds.add(element.peer.peerId + "mainVideo");
      int index = peerTracks
          .indexWhere((element) => element.uid == activeSpeakerIds.last);
      if (index != -1) {
        peerTracks[index].setAudioLevel(element.audioLevel);
      }
    });

    // Below code for change track and text in PIP mode iOS and android.
    if (updateSpeakers.isNotEmpty) {
      if (Platform.isIOS && (screenShareCount == 0 || isScreenShareOn)) {
        if (updateSpeakers[0].peer.videoTrack != null) {
          changePIPWindowTrackOnIOS(
              track: updateSpeakers[0].peer.videoTrack,
              alternativeText: updateSpeakers[0].peer.name,
              ratio: [9, 16]);
        } else {
          changePIPWindowTextOnIOS(
              text: updateSpeakers[0].peer.name, ratio: [9, 16]);
        }
      } else if (Platform.isAndroid) {
        changePIPWindowOnAndroid(updateSpeakers[0].peer.peerId + "mainVideo");
      }
    }

    // if (updateSpeakers.isNotEmpty) {
    //   highestSpeaker = updateSpeakers[0].peer.name;
    // } else {
    //   highestSpeaker = null;
    // }
    // activeSpeakerIds.clear();
    // updateSpeakers.forEach((element) {
    //   activeSpeakerIds[element.peer.peerId + "mainVideo"] = element.audioLevel;
    // });
    // int firstScreenPeersCount = (meetingMode == MeetingMode.Audio) ? 6 : 4;
    // if ((isActiveSpeakerMode && peerTracks.length > firstScreenPeersCount) ||
    //     meetingMode == MeetingMode.Hero) {
    //   List<HMSSpeaker> activeSpeaker = [];
    //   if (updateSpeakers.length > firstScreenPeersCount) {
    //     activeSpeaker.addAll(updateSpeakers.sublist(0, firstScreenPeersCount));
    //   } else {
    //     activeSpeaker.addAll(updateSpeakers);
    //   }
    //   for (int i = activeSpeaker.length - 1; i > -1; i--) {
    //     if (isActiveSpeakerMode) {
    //       List<PeerTrackNode> tempTracks = peerTracks.sublist(
    //           screenShareCount, screenShareCount + firstScreenPeersCount);
    //       int indexTrack = tempTracks.indexWhere(
    //           (peer) => activeSpeaker[i].peer.peerId + "mainVideo" == peer.uid);
    //       if (indexTrack != -1) {
    //         continue;
    //       }
    //     }
    //     int index = peerTracks.indexWhere(
    //         (peer) => activeSpeaker[i].peer.peerId + "mainVideo" == peer.uid);
    //     if (index != -1) {
    //       PeerTrackNode peerTrackNode = peerTracks.removeAt(index);
    //       peerTracks.insert(screenShareCount, peerTrackNode);
    //     }
    //   }
    // }
    // notifyListeners();
  }

  @override
  void onReconnecting() {
    reconnected = false;
    reconnecting = true;
    notifyListeners();
  }

  @override
  void onReconnected() {
    reconnecting = false;
    reconnected = true;
    notifyListeners();
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    log("onChangeTrackStateRequest-> sender: ${hmsTrackChangeRequest.requestBy} track: ${hmsTrackChangeRequest.track.toString()} mute: ${hmsTrackChangeRequest.mute}");
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
    log("onRemovedFromRoom-> sender: ${hmsPeerRemovedFromPeer.peerWhoRemoved}, reason: ${hmsPeerRemovedFromPeer.reason}, roomEnded: ${hmsPeerRemovedFromPeer.roomWasEnded}");
    description = "Removed by ${hmsPeerRemovedFromPeer.peerWhoRemoved?.name}";
    clearRoomState();
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
      peerTracks[index].setHMSLocalAudioStats(hmsLocalAudioStats);
    }
  }

  @override
  void onLocalVideoStats(
      {required List<HMSLocalVideoStats> hmsLocalVideoStats,
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
      peerTracks[index].setHMSLocalVideoStats(hmsLocalVideoStats);
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
      peerTracks[index].setHMSRemoteAudioStats(hmsRemoteAudioStats);
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
      peerTracks[index].setHMSRemoteVideoStats(hmsRemoteVideoStats);
    }
  }

  @override
  void onRTCStats({required HMSRTCStatsReport hmsrtcStatsReport}) {}

  void toggleSpeaker() {
    if (isSpeakerOn) {
      muteRoomAudioLocally();
    } else {
      unMuteRoomAudioLocally();
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
  }

// Helper Methods

  void clearRoomState() {
    _hmsSDKInteractor.destroy();
    peerTracks.clear();
    isRoomEnded = true;
    screenShareCount = 0;
    this.meetingMode = MeetingMode.Video;
    isScreenShareOn = false;
    isAudioShareStarted = false;
    _hmsSDKInteractor.removeUpdateListener(this);
    setLandscapeLock(false);
    notifyListeners();
    FlutterForegroundTask.stopService();
  }

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
      toggleCameraMuteState();
    } else {
      toggleMicMuteState();
    }
  }

  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        addPeer(peer);
        Utilities.showNotification("${peer.name} joined", "peer-joined");
        break;

      case HMSPeerUpdate.peerLeft:
        Utilities.showNotification("${peer.name} left", "peer-left");
        int index = peerTracks.indexWhere(
            (leftPeer) => leftPeer.uid == peer.peerId + "mainVideo");
        if (index != -1) {
          peerTracks.removeAt(index);
          notifyListeners();
        }
        removePeer(peer);
        break;

      case HMSPeerUpdate.roleUpdated:
        if (peer.isLocal) {
          localPeer = peer;
          if (hlsVideoController != null && !peer.role.name.contains("hls-")) {
            hlsVideoController!.dispose(forceDispose: true);
            hlsVideoController = null;
          }
        }
        if (peer.role.name.contains("hls-")) {
          isHLSLink = peer.isLocal;
          peerTracks.removeWhere(
              (leftPeer) => leftPeer.uid == peer.peerId + "mainVideo");
        } else {
          if (peer.isLocal) {
            isHLSLink = false;
          }
        }

        // Setup or destroy PIP controller on role Based
        if (Platform.isIOS) {
          if (peer.isLocal) {
            if (peer.role.name.contains("hls-")) {
              HMSIOSPIPController.destroy();
            } else {
              HMSIOSPIPController.setup(
                  autoEnterPip: true, aspectRatio: [9, 16]);
            }
          }
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
          if (peer.metadata?.contains("\"isHandRaised\":true") ?? false)
            Utilities.showNotification(
                "${peer.name} raised hand", "hand-raise");
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
          peerTracks[index].setNetworkQuality(peer.networkQuality?.quality);
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
            changePIPWindowTrackOnIOS(
                track: track,
                ratio: [9, 16],
                alternativeText: "${peer.name} Screen share");
          }
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          int peerIndex = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + track.trackId);
          if (peerIndex != -1) {
            screenShareCount--;
            peerTracks.removeAt(peerIndex);
            if (screenShareCount == 0) {
              setLandscapeLock(false);
            }
            isScreenShareActive();
            notifyListeners();
            changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
          }
        } else {
          int peerIndex = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + "mainVideo");
          if (peerIndex != -1) {
            if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
              peerTracks[peerIndex].audioTrack = null;
            } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
              peerTracks[peerIndex].track = null;
              if (currentPIPtrack == track) {
                changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
              }
            }
            if (peerTracks[peerIndex].track == null &&
                peerTracks[peerIndex].audioTrack == null) {
              peerTracks.removeAt(peerIndex);

              notifyListeners();
            }
          }
        }
        break;
      case HMSTrackUpdate.trackMuted:
        if (currentPIPtrack == track &&
            track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          changePIPWindowTrackOnIOS(
              track: track as HMSVideoTrack,
              alternativeText: peer.name,
              ratio: [9, 16]);
        }
        break;
      case HMSTrackUpdate.trackUnMuted:
        if (currentPIPtrack == track &&
            track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          changePIPWindowTrackOnIOS(
              track: track as HMSVideoTrack,
              alternativeText: peer.name,
              ratio: [9, 16]);
        }
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
    if (isActiveSpeakerMode) {
      isActiveSpeakerMode = false;
    }
    switch (meetingMode) {
      case MeetingMode.Video:
        break;
      case MeetingMode.Audio:
        isActiveSpeakerMode = false;
        muteRoomVideoLocally();
        break;
      case MeetingMode.Hero:
        if (this.meetingMode == MeetingMode.Audio) {
          unMuteRoomVideoLocally();
        }
        break;
      case MeetingMode.Single:
        if (this.meetingMode == MeetingMode.Audio) {
          unMuteRoomVideoLocally();
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

  void playAudioIos(String url) {
    audioFilePlayerNode.play(fileUrl: url);
    isPlayerRunningIos();
  }

  Future<bool> isPlayerRunningIos() async {
    bool isPlaying = await audioFilePlayerNode.isPlaying();
    isAudioShareStarted = isPlaying;
    return isPlaying;
  }

  void stopAudioIos() {
    audioFilePlayerNode.stop();
    isPlayerRunningIos();
  }

  void setAudioPlayerVolume(double volume) {
    audioFilePlayerNode.setVolume(volume);
    audioPlayerVolume = volume;
  }

  void setSessionMetadata(String? metadata) {
    _hmsSDKInteractor.setSessionMetadata(
        metadata: metadata, hmsActionResultListener: this);
  }

  void getSessionMetadata() async {
    sessionMetadata = await _hmsSDKInteractor.getSessionMetadata();
    notifyListeners();
  }

  void enterPipModeOnAndroid() async {
    //to check whether pip is available in android
    if (Platform.isAndroid) {
      bool _isPipAvailable = await HMSAndroidPIPController.isAvailable();
      if (_isPipAvailable) {
        //[isPipActive] method can also be used to check whether application is in pip Mode or not
        isPipActive =
            await HMSAndroidPIPController.start(autoEnterPip: isPipAutoEnabled);
        notifyListeners();
      }
    }
  }

  Future<bool> isPIPActive() async {
    if (Platform.isAndroid)
      isPipActive = await HMSAndroidPIPController.isActive();
    else if (Platform.isIOS) isPipActive = await HMSIOSPIPController.isActive();
    return isPipActive;
  }

  void changePIPWindowOnAndroid(String uid) {
    if (Platform.isAndroid && isPipActive) {
      int index = -1;
      index = peerTracks.indexWhere((element) => element.uid == uid);
      if (index != -1) {
        PeerTrackNode node = peerTracks[index];
        peerTracks.removeAt(index);
        peerTracks.insert(screenShareCount, node);
      }
      notifyListeners();
    }
  }

  void changePIPWindowTrackOnIOS(
      {HMSVideoTrack? track,
      required String alternativeText,
      required List<int> ratio}) async {
    if (Platform.isIOS && track != null) {
      isPipActive = await isPIPActive();
      if (isPipActive) {
        HMSIOSPIPController.changeVideoTrack(
            track: track,
            aspectRatio: ratio,
            alternativeText: alternativeText,
            scaleType: ScaleType.SCALE_ASPECT_FILL,
            backgroundColor: Utilities.getBackgroundColour(alternativeText));
        currentPIPtrack = track;
      }
    }
  }

  void changePIPWindowTextOnIOS(
      {String? text, required List<int> ratio}) async {
    if (Platform.isIOS && text != null) {
      isPipActive = await isPIPActive();
      if (isPipActive) {
        HMSIOSPIPController.changeText(
            text: text,
            aspectRatio: ratio,
            backgroundColor: Utilities.getBackgroundColour(text));
        currentPIPtrack = null;
      }
    }
  }

  void destroyPIPSetupOnIOS() {
    if (Platform.isIOS) {
      HMSIOSPIPController.destroy();
    }
  }

  void setPIPVideoController(bool reinitialise,
      {double? aspectRatio, String? hlsStreamUrl}) {
    if (hlsVideoController != null) {
      hlsVideoController!.dispose(forceDispose: true);
      hlsVideoController = null;
    }
    if (aspectRatio != null) {
      hlsAspectRatio = aspectRatio;
    }
    PipFlutterPlayerConfiguration pipFlutterPlayerConfiguration =
        PipFlutterPlayerConfiguration(
            //aspectRatio parameter can be used to set the player view based on the ratio selected from dashboard
            //Stream aspectRatio can be selected from Dashboard->Templates->Destinations->Customise stream video output->Video aspect ratio
            //The selected aspectRatio can be set here to get expected stream resolution
            aspectRatio: hlsAspectRatio,
            allowedScreenSleep: false,
            fit: BoxFit.contain,
            showPlaceholderUntilPlay: true,
            deviceOrientationsAfterFullScreen: [
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown
            ],
            autoDispose: false,
            handleLifecycle: false,
            placeholder: Center(
              child: TitleText(
                text: "Loading...",
                textColor: themeDefaultColor,
              ),
            ),
            eventListener: (PipFlutterPlayerEvent event) {
              if (event.pipFlutterPlayerEventType ==
                      PipFlutterPlayerEventType.initialized &&
                  isPipActive) {
                hlsVideoController!.enablePictureInPicture(pipFlutterPlayerKey);
              }
            },
            controlsConfiguration: PipFlutterPlayerControlsConfiguration(
                controlBarColor: Colors.transparent,
                enablePlayPause: false,
                enableOverflowMenu: false,
                enableSkips: false,
                playerTheme: PipFlutterPlayerTheme.cupertino));
    if (streamUrl == null && hlsStreamUrl == null) {
      Utilities.showToast("Stream URL is null", time: 5);
    }
    PipFlutterPlayerDataSource dataSource = PipFlutterPlayerDataSource(
        PipFlutterPlayerDataSourceType.network,
        ((streamUrl == null) ? hlsStreamUrl : streamUrl) ?? "",
        liveStream: true);
    hlsVideoController =
        PipFlutterPlayerController(pipFlutterPlayerConfiguration);
    hlsVideoController!.setupDataSource(dataSource);
    hlsVideoController!.play();
    hlsVideoController!.setPipFlutterPlayerGlobalKey(pipFlutterPlayerKey);
    if (reinitialise) notifyListeners();
  }

  void changeRoleOfPeersWithRoles(HMSRole toRole, List<HMSRole> ofRoles) {
    _hmsSDKInteractor.changeRoleOfPeersWithRoles(
        toRole: toRole, ofRoles: ofRoles, hmsActionResultListener: this);
  }

  void changePinTileStatus(PeerTrackNode peerTrackNode) {
    peerTrackNode.pinTile = !peerTrackNode.pinTile;
    peerTracks.remove(peerTrackNode);
    if (peerTrackNode.pinTile) {
      peerTracks.insert(screenShareCount, peerTrackNode);
    } else {
      peerTracks.add(peerTrackNode);
    }
    notifyListeners();
  }

//Get onSuccess or onException callbacks for HMSActionResultListenerMethod

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        clearRoomState();
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        Utilities.showToast("Track State Changed");
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.endRoom:
        clearRoomState();
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
      case HMSActionResultListenerMethod.changeRoleOfPeer:
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
          notifyListeners();
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
        if (arguments['type'] != "metadata") {
          addMessage(message);
          notifyListeners();
        }
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
      case HMSActionResultListenerMethod.setSessionMetadata:
        _hmsSDKInteractor.sendBroadcastMessage("refresh", this,
            type: "metadata");
        Utilities.showToast("Session Metadata changed");
        sessionMetadata = arguments!["session_metadata"];
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.switchCamera:
        Utilities.showToast("Camera switched successfully");
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        Utilities.showToast("Change Role successful");
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
    log("ActionResultListener onException-> method: ${methodType.toString()} , Error code : ${hmsException.code} , Description : ${hmsException.description} , Message : ${hmsException.message}");
    if (Constant.appFlavor == AppFlavors.prod) {
      FirebaseCrashlytics.instance.log(hmsException.toString());
    }
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        break;
      case HMSActionResultListenerMethod.endRoom:
        break;
      case HMSActionResultListenerMethod.removePeer:
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        break;
      case HMSActionResultListenerMethod.changeRole:
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.changeName:
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        if (retryHLS) {
          _hmsSDKInteractor.startHLSStreaming(this,
              meetingUrl: Constant.streamingUrl,
              hmshlsRecordingConfig: hmshlsRecordingConfig!);
          retryHLS = false;
        }

        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        isAudioShareStarted = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        break;
      case HMSActionResultListenerMethod.setSessionMetadata:
        break;
      case HMSActionResultListenerMethod.switchCamera:
        Utilities.showToast("Camera switching failed");
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        Utilities.showToast("Change role failed");
        break;
    }
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (isRoomEnded) {
      return;
    }
    if (state == AppLifecycleState.resumed) {
      if (isPipActive) {
        isPipActive = false;
        notifyListeners();
      }

      if (lastVideoStatus && !reconnecting) {
        toggleCameraMuteState();
        lastVideoStatus = false;
      }

      List<HMSPeer>? peersList = await getPeers();

      peersList?.forEach((element) {
        if (!element.isLocal && (Platform.isAndroid)) {
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
      if (localPeer != null &&
          !(localPeer.videoTrack?.isMute ?? true) &&
          !isPipActive) {
        toggleCameraMuteState();
        lastVideoStatus = true;
      }
      if (screenShareCount == 0 || isScreenShareOn) {
        int peerIndex = peerTracks.indexWhere((element) =>
            (!(element.track?.isMute ?? true) && !element.peer.isLocal));
        if (peerIndex != -1) {
          changePIPWindowTrackOnIOS(
              track: peerTracks[peerIndex].track,
              alternativeText: peerTracks[peerIndex].peer.name,
              ratio: [9, 16]);
        } else {
          changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
        }
      } else {
        int peerIndex = peerTracks.indexWhere((element) =>
            element.uid ==
            element.peer.peerId + (element.track?.trackId ?? ""));
        if (peerIndex != -1)
          changePIPWindowTrackOnIOS(
              track: peerTracks[peerIndex].track,
              alternativeText: peerTracks[peerIndex].peer.name,
              ratio: [9, 16]);
      }
    } else if (state == AppLifecycleState.inactive) {
      if (Platform.isAndroid && isPipAutoEnabled && !isPipActive) {
        isPipActive = true;
        notifyListeners();
      }
    }
  }
}
