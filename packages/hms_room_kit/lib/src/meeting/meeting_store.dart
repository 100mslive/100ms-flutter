//Package imports

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hms_room_kit/src/common/constants.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/model/rtc_stats.dart';
import 'package:hms_room_kit/src/service/app_secrets.dart';
import 'package:hms_room_kit/src/service/room_service.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Add comments in this class for better understanding
///This class is responsible for storing the data related to the meeting
///This class is also responsible for handling the events from the SDK
///
///This class extends ChangeNotifier so that it can notify the UI when the data changes
///This class has WidgetsBindingObserver mixin so that it can listen to the app lifecycle events
class MeetingStore extends ChangeNotifier
    with WidgetsBindingObserver
    implements
        HMSUpdateListener,
        HMSActionResultListener,
        HMSStatsListener,
        HMSLogListener,
        HMSKeyChangeListener,
        HMSHLSPlaybackEventsListener {
  late HMSSDKInteractor _hmsSDKInteractor;

  MeetingStore({required HMSSDKInteractor hmsSDKInteractor}) {
    _hmsSDKInteractor = hmsSDKInteractor;
  }

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

  List<HMSTrack> audioTracks = [];

  List<HMSMessage> messages = [];

  List<PeerTrackNode> peerTracks = [];

  List<String> activeSpeakerIds = [];

  HMSRoom? hmsRoom;

  int? localPeerNetworkQuality;

  bool isStatsVisible = false;

  bool isAutoSimulcast = true;

  bool isNewMessageReceived = false;

  int firstTimeBuild = 0;

  String message = "";

  final DateFormat formatter = DateFormat('d MMM y h:mm:ss a');

  ScrollController controller = ScrollController();

  MeetingMode meetingMode = MeetingMode.grid;

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

  final GlobalKey pipFlutterPlayerKey = GlobalKey();

  bool hlsStreamingRetry = false;

  bool isTrackSettingApplied = false;

  double audioPlayerVolume = 1.0;

  bool retryHLS = true;

  String? sessionMetadata;

  bool isPipActive = false;

  bool isPipAutoEnabled = true;

  bool lastVideoStatus = false;

  double hlsAspectRatio = 9 / 16;

  bool showNotification = false;

  HMSVideoTrack? currentPIPtrack;

  HMSLogList applicationLogs = HMSLogList(hmsLog: []);

  bool isFlashOn = false;

  ///These variables are used in session metadata implementation *************************************************

  HMSSessionStore? _hmsSessionStore;

  PeerTrackNode? spotLightPeer;

  String? spotlightMetadata;

  ///HLS Player Stats

  HMSHLSPlayerStats? hlsPlayerStats;

  bool isHLSStatsEnabled = false;

  bool isDefaultAspectRatioSelected = true;

  Future<HMSException?> join(String userName, String roomUrl,
      {HMSConfig? roomConfig}) async {
    //If roomConfig is null then only we call the methods to get the authToken
    //If we are joining the room from preview we already have authToken so we don't
    //need to call the getAuthTokenByRoomCode method
    if (roomConfig == null) {
      // List<String?>? roomData = RoomService().getCode(roomUrl);

      //If the link is not valid then we might not get the code and whether the link is a
      //PROD or QA so we return the error in this case
      // if (roomData != null && roomData.isEmpty) {
      //   return HMSException(
      //       message: "Invalid meeting URL",
      //       description: "Provided meeting URL is invalid",
      //       action: "Please Check the meeting URL",
      //       isTerminal: false);
      // }
      String? tokenEndPoint;
      String? initEndPoint;

      if (roomUrl.contains("app.100ms.live")) {
        List<String?>? roomData = RoomService().getCode(roomUrl);

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
        Constant.meetingCode = roomUrl;
      }
      //We use this to get the auth token from room code
      dynamic tokenData = await _hmsSDKInteractor.getAuthTokenByRoomCode(
          roomCode: Constant.meetingCode, endPoint: tokenEndPoint);

      if ((tokenData is String?) && tokenData != null) {
        roomConfig = HMSConfig(
            authToken: tokenData,
            userName: userName,
            captureNetworkQualityInPreview: true,
            endPoint: initEndPoint);
      } else {
        return tokenData;
      }
    }

    _hmsSDKInteractor.addUpdateListener(this);
    _hmsSDKInteractor.addLogsListener(this);
    HMSHLSPlayerController.addHMSHLSPlaybackEventsListener(this);
    WidgetsBinding.instance.addObserver(this);
    _hmsSDKInteractor.join(config: roomConfig);
    meetingUrl = roomUrl;
    return null;
  }

  //HMSSDK Methods

  void leave() async {
    _hmsSDKInteractor.removeStatsListener(this);
    WidgetsBinding.instance.removeObserver(this);
    hmsException = null;
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
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
    _hmsSDKInteractor.endRoom(lock, reason ?? "", this);
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

  void toggleAlwaysScreenOn() {
    _hmsSDKInteractor.toggleAlwaysScreenOn();
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isAudioMute(peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isVideoMute(peer);
  }

  Future<void> isScreenShareActive() async {
    isScreenShareOn = await _hmsSDKInteractor.isScreenShareActive();
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
      {String? meetingUrl,
      required bool toRecord,
      List<String>? rtmpUrls}) async {
    HMSRecordingConfig hmsRecordingConfig = HMSRecordingConfig(
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
  }

  void stopHLSStreaming() {
    _hmsSDKInteractor.stopHLSStreaming(hmsActionResultListener: this);
  }

  void sendHLSTimedMetadata(List<HMSHLSTimedMetadata> metadata) {
    _hmsSDKInteractor.sendHLSTimedMetadata(metadata, this);
  }

  void changeTrackStateForRole(bool mute, List<HMSRole>? roles) {
    _hmsSDKInteractor.changeTrackStateForRole(
        true, HMSTrackKind.kHMSTrackKindAudio, "regular", roles, this);
  }

  void setSettings() async {
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
            .indexWhere((element) => element.uid == "${each.peerId}mainVideo");
        if (index == -1) {
          peerTracks.add(PeerTrackNode(
              peer: each,
              uid: "${each.peerId}mainVideo",
              networkQuality: localPeerNetworkQuality,
              stats: RTCStats()));
        }
        localPeer = each;
        addPeer(localPeer!);
        if (localPeer!.role.name.contains("hls-") == true) isHLSLink = true;
        index = peerTracks
            .indexWhere((element) => element.uid == "${each.peerId}mainVideo");
        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            peerTracks[index].track = each.videoTrack!;
            if (each.videoTrack!.isMute) {
              isVideoOn = false;
            }
          }
        }
        if (each.audioTrack != null) {
          if (each.audioTrack!.kind == HMSTrackKind.kHMSTrackKindAudio) {
            peerTracks[index].audioTrack = each.audioTrack!;
            if (each.audioTrack!.isMute) {
              isMicOn = false;
            }
          }
        }
        break;
      }
    }
    roles = await getRoles();
    roles.removeWhere((element) => element.name == "__internal_recorder");
    Utilities.saveStringData(key: "meetingLink", value: meetingUrl);
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();

    if (Platform.isIOS && !(localPeer?.role.name.contains("hls-") ?? false)) {
      HMSIOSPIPController.setup(
          autoEnterPip: true,
          aspectRatio: [9, 16],
          backgroundColor: Colors.black);
    } else if (Platform.isAndroid) {
      HMSAndroidPIPController.setup();
    }
  }

  void initForegroundTask() {
    FlutterForegroundTask.startService(
        notificationTitle: "100ms foreground service running",
        notificationText: "Tap to return to the app");
  }

  void getSpotlightPeer() async {
    String? metadata =
        await _hmsSessionStore?.getSessionMetadataForKey(key: "spotlight");
    if (metadata != null) {
      setPeerToSpotlight(metadata);
      spotlightMetadata = metadata;
    }
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
        isMicOn = !track.isMute;
      }
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo &&
          track.source == "REGULAR") {
        isVideoOn = !track.isMute;
      }
      notifyListeners();
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio &&
        trackUpdate != HMSTrackUpdate.trackRemoved) {
      int index = peerTracks
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.audioTrack = track as HMSAudioTrack;
        peerTrackNode.notify();
      } else {
        peerTracks.add(PeerTrackNode(
            peer: peer,
            uid: "${peer.peerId}mainVideo",
            stats: RTCStats(),
            audioTrack: track as HMSAudioTrack));
        notifyListeners();
      }
      setSpotlightOnTrackUpdate(track);
      return;
    }

    if (track.source == "REGULAR" &&
        trackUpdate != HMSTrackUpdate.trackRemoved) {
      int index = peerTracks
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.track = track as HMSVideoTrack;
        peerTrackNode.notify();
        if (meetingMode == MeetingMode.single) {
          rearrangeTile(peerTrackNode, index);
        }
        setSpotlightOnTrackUpdate(track);
        return;
      } else {
        peerTracks.add(PeerTrackNode(
            peer: peer,
            uid: "${peer.peerId}mainVideo",
            stats: RTCStats(),
            track: track as HMSVideoTrack));
        notifyListeners();
        setSpotlightOnTrackUpdate(track);
        return;
      }
    }
    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onHMSError({required HMSException error}) {
    log("onHMSError-> error: ${error.code} ${error.message}");
    hmsException = error;
    Utilities.showNotification(error.message ?? "", "error");
    notifyListeners();
  }

  @override
  void onMessage({required HMSMessage message}) {
    log("onMessage-> sender: ${message.sender} message: ${message.message} time: ${message.time}, type: ${message.type}");
    switch (message.type) {
      case "metadata":
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
    currentRoleChangeRequest = roleChangeRequest;
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    //To handle the active speaker mode scenario
    if (meetingMode == MeetingMode.activeSpeaker) {
      //Picking up the first four peers from the peerTracks list
      List<PeerTrackNode> activeSpeakerList = peerTracks.sublist(
          screenShareCount + (spotLightPeer != null ? 1 : 0),
          math.min(peerTracks.length, 4));

      /* Here we iterate through the updateSpeakers list
       * and do the following:
       *  - Whether the peer is already present on screen
       *  - if not we find the peer's index from peerTracks list
       *  - if peer is present in the peerTracks list(this is done just to make sure that peer is still in the room)
       *  - Insert the peer after screenShare tracks and remove the peer from it's previous position
      */
      for (var speaker in updateSpeakers) {
        int index = activeSpeakerList.indexWhere((previousSpeaker) =>
            previousSpeaker.uid == "${speaker.peer.peerId}mainVideo");
        if (index == -1) {
          int peerIndex = peerTracks.indexWhere(
              (node) => node.uid == "${speaker.peer.peerId}mainVideo");
          if (peerIndex != -1) {
            if (peerTracks[peerIndex].uid != spotLightPeer?.uid) {
              PeerTrackNode activeSpeaker = peerTracks[peerIndex];
              peerTracks.removeAt(peerIndex);
              peerTracks.insert(
                  screenShareCount + (spotLightPeer != null ? 1 : 0),
                  activeSpeaker);
              peerTracks[screenShareCount + (spotLightPeer != null ? 1 : 0)]
                  .setOffScreenStatus(false);
            }
          }
        }
      }
      activeSpeakerList.clear();
      notifyListeners();
    }

    //This is to handle the borders around the tiles of peers who are currently speaking
    //Reseting the borders of the tile everytime the update is received
    if (activeSpeakerIds.isNotEmpty) {
      for (var key in activeSpeakerIds) {
        int index = peerTracks.indexWhere((element) => element.uid == key);
        if (index != -1) {
          peerTracks[index].setAudioLevel(-1);
        }
      }
      activeSpeakerIds.clear();
    }

    //Setting the border for peers who are speaking
    for (var element in updateSpeakers) {
      activeSpeakerIds.add("${element.peer.peerId}mainVideo");
      int index = peerTracks
          .indexWhere((element) => element.uid == activeSpeakerIds.last);
      if (index != -1) {
        peerTracks[index].setAudioLevel(element.audioLevel);
      }
    }

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
        changePIPWindowOnAndroid("${updateSpeakers[0].peer.peerId}mainVideo");
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
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
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
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
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
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
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
          .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
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
      showAudioDeviceChangePopup = true;
    }
    if (selfChangeAudioDevice) {
      selfChangeAudioDevice = false;
    }
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
  }

// Helper Methods

  void clearRoomState() async {
    clearPIPState();
    removeListeners();
    toggleAlwaysScreenOn();
    _hmsSDKInteractor.destroy();
    _hmsSessionStore = null;
    peerTracks.clear();
    isRoomEnded = true;
    resetForegroundTaskAndOrientation();
    notifyListeners();
  }

  void resetForegroundTaskAndOrientation() {
    setLandscapeLock(false);
    FlutterForegroundTask.stopService();
  }

  void clearPIPState() {
    if (Platform.isAndroid) {
      HMSAndroidPIPController.destroy();
    } else if (Platform.isIOS) {
      HMSIOSPIPController.destroy();
    }
  }

  void removeListeners() {
    _hmsSDKInteractor.removeUpdateListener(this);
    _hmsSDKInteractor.removeLogsListener(this);
    _hmsSessionStore?.removeKeyChangeListener(hmsKeyChangeListener: this);
    _hmsSDKInteractor.removeHMSLogger();
    HMSHLSPlayerController.removeHMSHLSPlaybackEventsListener(this);
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
    messages.add(message);
  }

  void updatePeerAt(HMSPeer peer) {
    int index = peers.indexOf(peer);
    peers.removeAt(index);
    peers.insert(index, peer);
  }

  void updateFilteredList(HMSPeerUpdate peerUpdate, HMSPeer peer) {
    String currentRole = selectedRoleFilter;
    int index =
        filteredPeers.indexWhere((element) => element.peerId == peer.peerId);

    if (index != -1) {
      filteredPeers.removeAt(index);
      if ((peerUpdate == HMSPeerUpdate.nameChanged)) {
        filteredPeers.insert(index, peer);
      } else if (peerUpdate == HMSPeerUpdate.metadataChanged) {
        if ((peer.metadata?.contains("\"isHandRaised\":true") ?? false) ||
            ((currentRole == "Everyone") || (currentRole == peer.role.name))) {
          filteredPeers.insert(index, peer);
        }
      } else if (peerUpdate == HMSPeerUpdate.roleUpdated &&
          ((currentRole == "Everyone") || (currentRole == "Raised Hand"))) {
        filteredPeers.insert(index, peer);
      }
    } else {
      if ((peerUpdate == HMSPeerUpdate.metadataChanged &&
              currentRole == "Raised Hand") ||
          (peerUpdate == HMSPeerUpdate.roleUpdated &&
              currentRole == peer.role.name)) {
        filteredPeers.add(peer);
      }
    }
  }

  void setLandscapeLock(bool value) {
    if (value) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
            (leftPeer) => leftPeer.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          peerTracks.removeAt(index);
          notifyListeners();
        }
        removePeer(peer);
        break;

      case HMSPeerUpdate.roleUpdated:
        if (peer.isLocal) {
          getSpotlightPeer();
          localPeer = peer;
        }
        if (peer.role.name.contains("hls-")) {
          isHLSLink = peer.isLocal;
          peerTracks.removeWhere(
              (leftPeer) => leftPeer.uid == "${peer.peerId}mainVideo");
        } else {
          if (peer.isLocal) {
            isHLSLink = false;
          }
        }

        if (peer.isLocal) {
          if (Platform.isIOS) {
            if (peer.role.name.contains("hls-")) {
              HMSIOSPIPController.destroy();
            } else {
              HMSIOSPIPController.setup(
                  autoEnterPip: true,
                  aspectRatio: [9, 16],
                  backgroundColor: Colors.black);
            }
          }
        }

        Utilities.showToast("${peer.name}'s role changed to ${peer.role.name}");
        updatePeerAt(peer);
        updateFilteredList(update, peer);
        notifyListeners();
        break;

      case HMSPeerUpdate.metadataChanged:
        if (peer.isLocal) localPeer = peer;
        int index = peerTracks
            .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks[index];
          peerTrackNode.peer = peer;
          if (peer.metadata?.contains("\"isHandRaised\":true") ?? false) {
            Utilities.showNotification(
                "${peer.name} raised hand", "hand-raise");
          }
          peerTrackNode.notify();
        }
        updatePeerAt(peer);
        updateFilteredList(update, peer);
        break;

      case HMSPeerUpdate.nameChanged:
        if (peer.isLocal) {
          int localPeerIndex = peerTracks.indexWhere(
              (element) => element.uid == "${localPeer!.peerId}mainVideo");
          if (localPeerIndex != -1) {
            PeerTrackNode peerTrackNode = peerTracks[localPeerIndex];
            peerTrackNode.peer = peer;
            localPeer = peer;
            peerTrackNode.notify();
            notifyListeners();
          }
        } else {
          int remotePeerIndex = peerTracks.indexWhere(
              (element) => element.uid == "${peer.peerId}mainVideo");
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
            .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
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
          peerTracks.removeWhere(
              (element) => element.track?.trackId == track.trackId);
          notifyListeners();
          return;
        } else {
          int peerIndex = peerTracks.indexWhere(
              (element) => element.uid == "${peer.peerId}mainVideo");
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

  ///Here we get the instance of HMSSessionStore using which
  ///we will be performing the session metadata actions
  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    _hmsSessionStore = hmsSessionStore;
    _hmsSessionStore?.addKeyChangeListener(
        keys: SessionStoreKeyValues.getSessionStoreKeys(),
        hmsKeyChangeListener: this);
    getSpotlightPeer();
  }

  ///We get this call everytime metadata corresponding to a key is changed
  ///
  ///Note: This only gets called when we have attached [HMSKeyChangeListener] using
  ///     addKeyChangeListener method with keys to be listened
  @override
  void onKeyChanged({required String key, required String? value}) {
    log("onKeyChanged --> key: $key value: $value");
    SessionStoreKey keyType = SessionStoreKeyValues.getMethodFromName(key);
    switch (keyType) {
      case SessionStoreKey.pinnedMessageSessionKey:
        sessionMetadata = value;
        break;
      case SessionStoreKey.spotlight:
        setPeerToSpotlight(value);
        break;
      case SessionStoreKey.unknown:
        break;
    }
    notifyListeners();
  }

  ///This method sets the peer to spotlight
  ///this also handles removing a peer from spotlight case
  void setPeerToSpotlight(String? value) {
    try {
      int currentSpotlightPeerIndex =
          peerTracks.indexWhere((node) => node.uid == spotLightPeer?.uid);
      if (currentSpotlightPeerIndex != -1) {
        peerTracks[currentSpotlightPeerIndex].pinTile = false;
        spotLightPeer = null;
        spotlightMetadata = null;
      }
      if (value != null) {
        int index = peerTracks.indexWhere(((node) =>
            node.audioTrack?.trackId == (value) ||
            node.track?.trackId == (value)));
        if (index != -1) {
          Utilities.showToast("${peerTracks[index].peer.name} is in spotlight");
          spotLightPeer = peerTracks[index];
          changePinTileStatus(peerTracks[index]);
        } else {
          spotlightMetadata = value;
        }
      } else {
        spotlightMetadata = null;
        spotLightPeer = null;
      }
      notifyListeners();
    } catch (e) {
      log("setPeerToSpotlight: $e");
    }
  }

  void setMode(MeetingMode meetingMode) {
    //Turning the videos on if the previously mode was audio
    if (this.meetingMode == MeetingMode.audio &&
        meetingMode != MeetingMode.audio) {
      unMuteRoomVideoLocally();
    }

    switch (meetingMode) {
      case MeetingMode.audio:
        //Muting the videos of peers in room locally
        muteRoomVideoLocally();
        break;
      case MeetingMode.single:
        //This is to place the peers with there videos ON
        //in the beginning
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
          } else {
            type0++;
          }
        }
        break;
      default:
        //In Hero,Active Speaker and Grid mode there is nothing needs to be done
        //Just setting the mode below
        break;
    }
    this.meetingMode = meetingMode;
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
    isNewMessageReceived = false;
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

  void setSpotlightOnTrackUpdate(HMSTrack track) {
    ///In order to avoid errors because of
    ///track updates ordering for audio and video
    ///adding the method call here.
    if (spotlightMetadata == track.trackId) {
      setPeerToSpotlight(spotlightMetadata);
    }
  }

  HMSAudioFilePlayerNode audioFilePlayerNode =
      HMSAudioFilePlayerNode("audioFilePlayerNode");
  HMSMicNode micNode = HMSMicNode();

  void playAudioIos(String url) async {
    HMSException? exception = await audioFilePlayerNode.play(fileUrl: url);
    if (exception != null) {
      Utilities.showToast(exception.description, time: 5);
    }
    isPlayerRunningIos();
  }

  Future<bool> isPlayerRunningIos() async {
    isAudioShareStarted = await audioFilePlayerNode.isPlaying();
    return isAudioShareStarted;
  }

  void stopAudioIos() {
    audioFilePlayerNode.stop();
    isPlayerRunningIos();
  }

  void setAudioPlayerVolume(double volume) {
    audioFilePlayerNode.setVolume(volume);
    audioPlayerVolume = volume;
  }

  void setSessionMetadataForKey({required String key, String? metadata}) {
    _hmsSessionStore?.setSessionMetadataForKey(
        key: key, data: metadata, hmsActionResultListener: this);
  }

  void getSessionMetadata(String key) async {
    dynamic result = await _hmsSessionStore?.getSessionMetadataForKey(key: key);
    if (result is HMSException) {
      Utilities.showToast(
          "Error Occured: code: ${result.code?.errorCode}, description: ${result.description}, message: ${result.message}",
          time: 5);
      return;
    }
    if (result != null) {
      sessionMetadata = result as String;
    }
    notifyListeners();
  }

  void enterPipModeOnAndroid() async {
    //to check whether pip is available in android
    if (Platform.isAndroid) {
      bool isPipAvailable = await HMSAndroidPIPController.isAvailable();
      if (isPipAvailable) {
        //[isPipActive] method can also be used to check whether application is in pip Mode or not
        isPipActive = await HMSAndroidPIPController.start();
        notifyListeners();
      }
    }
  }

  Future<bool> isPIPActive() async {
    if (Platform.isAndroid) {
      isPipActive = await HMSAndroidPIPController.isActive();
    } else if (Platform.isIOS) {
      isPipActive = await HMSIOSPIPController.isActive();
    }
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

  void switchAudioOutputUsingiOSUI() {
    _hmsSDKInteractor.switchAudioOutputUsingiOSUI();
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
            backgroundColor: Colors.black);
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
            text: text, aspectRatio: ratio, backgroundColor: Colors.black);
        currentPIPtrack = null;
      }
    }
  }

  void setAspectRatio(double ratio) {
    hlsAspectRatio = ratio;
    notifyListeners();
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

  ///
  /// This method is used to toggle the flash light of your phone
  /// Here we are not checking whether flash is supported or not
  /// Since this method already check that internally,
  ///
  void toggleFlash() async {
    dynamic result = await HMSCameraControls.toggleFlash();
    if (result is HMSException) {
      Utilities.showToast(
          "Error Occured: code: ${result.code?.errorCode}, description: ${result.description}, message: ${result.message}",
          time: 5);
      return;
    }
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
          if (arguments["rtmp_urls"] != null &&
              arguments["rtmp_urls"].length == 0 &&
              arguments["to_record"]) {
            Utilities.showToast("Recording Started");
          } else if (arguments["rtmp_urls"] != null &&
              arguments["rtmp_urls"].length != 0 &&
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
        if (arguments != null) {
          var message = HMSMessage.fromMap(arguments);
          if (arguments['type'] != "metadata") {
            addMessage(message);
            notifyListeners();
          }
        }
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        if (arguments != null) {
          var message = HMSMessage.fromMap(arguments);
          addMessage(message);
          notifyListeners();
        }
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        if (arguments != null) {
          var message = HMSMessage.fromMap(arguments);
          addMessage(message);
          notifyListeners();
        }
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
      case HMSActionResultListenerMethod.switchCamera:
        Utilities.showToast("Camera switched successfully");
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        Utilities.showToast("Change Role successful");
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        Utilities.showToast("Metadata sent successfully");
        break;
      default:
        log("ActionResultListener onException-> method: ${methodType.toString()}Could not find a valid case while switching");
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
      case HMSActionResultListenerMethod.switchCamera:
        Utilities.showToast("Camera switching failed");
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        Utilities.showToast("Change role failed");
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        Utilities.showToast("Set session metadata failed");
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        // TODO: Handle this case.
        break;
      default:
        log("ActionResultListener onException-> method: ${methodType.toString()} Could not find a valid case while switching");
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
      if (Platform.isAndroid) {
        isPipActive = await HMSAndroidPIPController.isActive();
      } else if (Platform.isIOS) {
        isPipActive = false;
      }
      notifyListeners();

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

      if (Platform.isAndroid) {
        isPipActive = await HMSAndroidPIPController.isActive();
        notifyListeners();
      }

      if (Platform.isIOS) {
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
          if (peerIndex != -1) {
            changePIPWindowTrackOnIOS(
                track: peerTracks[peerIndex].track,
                alternativeText: peerTracks[peerIndex].peer.name,
                ratio: [9, 16]);
          }
        }
      }
    } else if (state == AppLifecycleState.inactive) {
      if (Platform.isAndroid && !isPipActive) {
        isPipActive = await HMSAndroidPIPController.isActive();
      }
      notifyListeners();
    } else if (state == AppLifecycleState.detached) {
      if (Platform.isAndroid && !isPipActive) {
        isPipActive = await HMSAndroidPIPController.isActive();
      }
      notifyListeners();
    }
  }

  @override
  void onLogMessage({required HMSLogList hmsLogList}) {
    notifyListeners();
  }

  @override
  void onCue({required HMSHLSCue hlsCue}) {
    /**
     * Here we use a list of alignments and select an alignment at random and use it 
     * to position the toast for timed metadata
     */

    if (hlsCue.payload != null) {
      /**
       * Generally we are assuming that the timed metadata payload will be a JSON String
       * but if it's a normal string then this throws the format exception 
       * Hence we catch it and display the payload as string on toast.
       * The toast is displayed for the time duration hlsCue.endDate - hlsCue.startDate
       * If endDate is null then toast is displayed for 2 seconds by default
       */
      try {
        final Map<String, dynamic> data = jsonDecode(hlsCue.payload!);
        Utilities.showTimedMetadata(
            Utilities.getTimedMetadataEmojiFromId(data["emojiId"]),
            time: hlsCue.endDate == null
                ? 2
                : (hlsCue.endDate!.difference(hlsCue.startDate)).inSeconds,
            align: Utilities.timedMetadataAlignment[math.Random()
                .nextInt(Utilities.timedMetadataAlignment.length)]);
      } catch (e) {
        Utilities.showTimedMetadata(hlsCue.payload!,
            time: hlsCue.endDate == null
                ? 2
                : (hlsCue.endDate!.difference(hlsCue.startDate)).inSeconds,
            align: Utilities.timedMetadataAlignment[math.Random()
                .nextInt(Utilities.timedMetadataAlignment.length)]);
      }
    }
  }

  @override
  void onPlaybackFailure({required String? error}) {
    Utilities.showToast("Playback failure $error");
  }

  @override
  void onPlaybackStateChanged({required HMSHLSPlaybackState playbackState}) {
    Utilities.showToast("Playback state changed to ${playbackState.name}");
  }

  @override
  void onHLSError({required HMSException hlsException}) {
    // TODO: implement onHLSError
  }

  @override
  void onHLSEventUpdate({required HMSHLSPlayerStats playerStats}) {
    log("onHLSEventUpdate-> bitrate:${playerStats.averageBitrate} buffered duration: ${playerStats.bufferedDuration}");
    hlsPlayerStats = playerStats;
    notifyListeners();
  }

  void setHLSPlayerStats(bool value) {
    isHLSStatsEnabled = value;
    if (!value) {
      HMSHLSPlayerController.removeHLSStatsListener();
    } else {
      HMSHLSPlayerController.addHLSStatsListener();
    }
    notifyListeners();
  }
}
