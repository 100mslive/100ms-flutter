///Dart imports
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

//Package imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';

//Project imports
import 'package:hms_room_kit/src/model/participant_store.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/model/rtc_stats.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[MeetingStore] is the store that is used to store the data of the meeting
///It takes the following parameters:
///[hmsSDKInteractor] is the interactor that is used to interact with the SDK
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

  HMSLocalVideoTrack? previewForRoleVideoTrack;

  HMSLocalAudioTrack? previewForRoleAudioTrack;

  HMSPeer? peerDeclinedRequest;

  HMSPeer? peerToBringOnStage;

  bool isMeetingStarted = false;

  bool isVideoOn = true;

  bool isMicOn = true;

  bool isScreenShareOn = false;

  BuildContext? screenshareContext;

  bool reconnecting = false;

  bool reconnected = false;

  bool isRoomEnded = false;

  ///This variable is used to check if the room end method is called or not
  ///by you or someone else(This also covers the case when you are removed from session but session is still active)
  bool isEndRoomCalled = false;

  List<HMSToastModel> toasts = [];

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

  ///Map with key as role and value as list of peers with that role
  Map<String, List<ParticipantsStore>> participantsInMeetingMap = {
    "Hand Raised": []
  };

  ///This stores the length of the filteredPeerList
  int participantsInMeeting = 0;

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

  bool isOverlayChatOpened =
      (HMSRoomLayout.chatData?.isOpenInitially ?? false) &&
          (HMSRoomLayout.chatData?.isOverlay ?? false);

  int firstTimeBuild = 0;

  String message = "";

  final DateFormat formatter = DateFormat('d MMM y h:mm:ss a');

  ScrollController controller = ScrollController();

  MeetingMode meetingMode = MeetingMode.activeSpeakerWithInset;

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

  bool hlsStreamingRetry = false;

  bool isTrackSettingApplied = false;

  double audioPlayerVolume = 1.0;

  bool retryHLS = true;

  String? sessionMetadata;

  bool isPipActive = false;

  // bool isPipAutoEnabled = true;

  bool lastVideoStatus = false;

  double hlsAspectRatio = 9 / 16;

  bool showNotification = false;

  // HMSVideoTrack? currentPIPtrack;

  HMSLogList applicationLogs = HMSLogList(hmsLog: []);

  bool isFlashOn = false;

  String? previousRole;

  ///These variables are used in session metadata implementation *************************************************

  HMSSessionStore? _hmsSessionStore;

  PeerTrackNode? spotLightPeer;

  String? spotlightMetadata;

  ///HLS Player Stats

  HMSHLSPlayerStats? hlsPlayerStats;

  bool isHLSStatsEnabled = false;

  bool isDefaultAspectRatioSelected = true;

  int currentPage = 0;

  int currentScreenSharePage = 0;

  ///PeerList iterators
  ///This is a map with key as role and value as the iterator for that role
  Map<String, HMSPeerListIterator> peerListIterators = {};

  ///This checks whether to refresh peerlist or not
  ///This is used in case when we are looking at a specific viewer role peerlist
  ///i.e we are using the View All button functionalities.
  bool disablePeerListRefresh = false;

  ///This stores the number of peers in the room
  int peersInRoom = 0;

  ///Check whether recording is in intialising state
  bool isRecordingInInitialisingState = false;

  Future<HMSException?> join(String userName, String roomCode,
      {HMSConfig? roomConfig}) async {
    //If roomConfig is null then only we call the methods to get the authToken
    //If we are joining the room from preview we already have authToken so we don't
    //need to call the getAuthTokenByRoomCode method
    if (roomConfig == null) {
      //We use this to get the auth token from room code
      dynamic tokenData = await _hmsSDKInteractor.getAuthTokenByRoomCode(
          userId: Constant.prebuiltOptions?.userId,
          roomCode: Constant.roomCode,
          endPoint: Constant.tokenEndPoint);

      ///If the tokenData is String then we set the authToken in the roomConfig
      ///and then we join the room
      ///
      ///If the tokenData is HMSException then we return the HMSException i.e. tokenData
      if ((tokenData is String?) && tokenData != null) {
        ///Success Scenario
        roomConfig = HMSConfig(
            authToken: tokenData,
            userName: userName,
            captureNetworkQualityInPreview: true,
            endPoint: Constant.initEndPoint);
      } else {
        ///Error Scenario
        return tokenData;
      }
    }

    _hmsSDKInteractor.addUpdateListener(this);
    _hmsSDKInteractor.addLogsListener(this);
    HMSHLSPlayerController.addHMSHLSPlaybackEventsListener(this);
    WidgetsBinding.instance.addObserver(this);
    setMeetingModeUsingLayoutApi();
    _hmsSDKInteractor.join(config: roomConfig);
    meetingUrl = roomCode;
    return null;
  }

  ///This method reapplies the theme layout based on the role name
  void resetLayout(String roleName) {
    HMSRoomLayout.resetLayout(roleName);
    setMeetingModeUsingLayoutApi();
    notifyListeners();
  }

  ///This method is used to set the meeting mode using the layout api
  void setMeetingModeUsingLayoutApi() {
    if (HMSRoomLayout.peerType == PeerRoleType.conferencing) {
      meetingMode = (HMSRoomLayout
                  .roleLayoutData
                  ?.screens
                  ?.conferencing
                  ?.defaultConf
                  ?.elements
                  ?.videoTileLayout
                  ?.enableLocalTileInset ??
              true)
          ? MeetingMode.activeSpeakerWithInset
          : MeetingMode.activeSpeakerWithoutInset;
    }
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
    isEndRoomCalled = true;
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
    if (isScreenShareOn) {
      int index = toasts.indexWhere(
          (toast) => toast.hmsToastType == HMSToastsType.localScreenshareToast);
      if (index == -1) {
        toasts.add(HMSToastModel(this,
            hmsToastType: HMSToastsType.localScreenshareToast));
        notifyListeners();
      }
    } else {
      toasts.removeWhere((element) =>
          element.hmsToastType == HMSToastsType.localScreenshareToast);
      notifyListeners();
    }
  }

  void removeToast(HMSToastsType hmsToastsType, {dynamic data}) {
    switch (hmsToastsType) {
      case HMSToastsType.roleChangeToast:
        toasts.removeWhere((toast) =>
            toast.hmsToastType == HMSToastsType.roleChangeToast &&
            data.peerId == toast.toastData.peerId);
        break;
      case HMSToastsType.errorToast:
        toasts.removeWhere(
            (toast) => toast.hmsToastType == HMSToastsType.errorToast);
        break;
      case HMSToastsType.localScreenshareToast:
        toasts.removeWhere((toast) =>
            toast.hmsToastType == HMSToastsType.localScreenshareToast);
        break;
      case HMSToastsType.roleChangeDeclineToast:
        toasts.removeWhere((toast) =>
            toast.hmsToastType == HMSToastsType.roleChangeDeclineToast &&
            data.peerId == toast.toastData.peerId);
        break;
    }
    notifyListeners();
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

  HMSRole? getOnStageRole() {
    if (HMSRoomLayout.peerType == PeerRoleType.conferencing) {
      String? roleName = HMSRoomLayout.roleLayoutData?.screens?.conferencing
          ?.defaultConf?.elements?.onStageExp?.onStageRole;
      int? roleIndex = roles.indexWhere((element) => element.name == roleName);
      if (roleIndex != -1) {
        return roles[roleIndex];
      }
    } else if (HMSRoomLayout.peerType == PeerRoleType.hlsViewer) {
      String? roleName = HMSRoomLayout.roleLayoutData?.screens?.conferencing
          ?.hlsLiveStreaming?.elements?.onStageExp?.onStageRole;
      int? roleIndex = roles.indexWhere((element) => element.name == roleName);
      if (roleIndex != -1) {
        return roles[roleIndex];
      }
    }
    return null;
  }

  ///This method returns the off stage roles
  bool isOffStageRole(String? roleName) {
    if (HMSRoomLayout.peerType == PeerRoleType.conferencing) {
      int? roleIndex = HMSRoomLayout.roleLayoutData?.screens?.conferencing
          ?.defaultConf?.elements?.onStageExp?.offStageRoles
          ?.indexWhere((role) => role == roleName);
      if (roleIndex != -1) {
        return true;
      }
    } else if (HMSRoomLayout.peerType == PeerRoleType.hlsViewer) {
      int? roleIndex = HMSRoomLayout.roleLayoutData?.screens?.conferencing
          ?.hlsLiveStreaming?.elements?.onStageExp?.offStageRoles
          ?.indexWhere((role) => role == roleName);
      if (roleIndex != -1) {
        return true;
      }
    }
    return false;
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
    isRecordingInInitialisingState = true;
    notifyListeners();
  }

  void cancelPreview() async {
    var result = await _hmsSDKInteractor.cancelPreview();
    if (result != null) {
      log(result.toString());
      return;
    }
    if (isRaisedHand) {
      toggleLocalPeerHandRaise();
    }
    if (currentRoleChangeRequest?.suggestedBy != null) {
      _hmsSDKInteractor.sendDirectMessage(
          "", currentRoleChangeRequest!.suggestedBy!, this,
          type: "role_change_declined");
    }
    currentRoleChangeRequest = null;
    previewForRoleAudioTrack = null;
    previewForRoleVideoTrack = null;
    notifyListeners();
  }

  void toggleRequestDeclined(HMSPeer? sender) {
    toasts.add(HMSToastModel(sender,
        hmsToastType: HMSToastsType.roleChangeDeclineToast));
    notifyListeners();
  }

  dynamic previewForRole(String role) async {
    var result = await _hmsSDKInteractor.previewForRole(role: role);

    ///Handle the exception
    if (result is HMSException) {
      log(result.toString());
    } else {
      var indexForVideoTrack = (result as List<HMSTrack>).indexWhere(
          (element) =>
              element.kind == HMSTrackKind.kHMSTrackKindVideo &&
              element.source == "REGULAR");
      if (indexForVideoTrack != -1) {
        previewForRoleVideoTrack =
            result[indexForVideoTrack] as HMSLocalVideoTrack;
        isVideoOn = true;
      }
      var indexForAudioTrack = result.indexWhere(
          (element) => element.kind == HMSTrackKind.kHMSTrackKindAudio);
      if (indexForAudioTrack != -1) {
        previewForRoleAudioTrack =
            result[indexForAudioTrack] as HMSLocalAudioTrack;
        isMicOn = true;
      }
      notifyListeners();
    }
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

  void toggleLocalPeerHandRaise() {
    if (isRaisedHand) {
      _hmsSDKInteractor.lowerLocalPeerHand(hmsActionResultListener: this);
    } else {
      _hmsSDKInteractor.raiseLocalPeerHand(hmsActionResultListener: this);
    }
  }

  void lowerRemotePeerHand(HMSPeer forPeer) {
    _hmsSDKInteractor.lowerRemotePeerHand(
        forPeer: forPeer, hmsActionResultListener: this);
  }

  bool isBRB = false;

  void changeMetadataBRB() {
    isBRB = !isBRB;
    if (isRaisedHand) {
      _hmsSDKInteractor.lowerLocalPeerHand(hmsActionResultListener: this);
    }
    String value = isBRB ? "true" : "false";
    _hmsSDKInteractor.changeMetadata(
        metadata: "{\"isBRBOn\":$value,\"prevRole\":\"$previousRole\"}",
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
    previewForRoleAudioTrack = null;
    previewForRoleVideoTrack = null;
    _hmsSDKInteractor.acceptChangeRole(hmsRoleChangeRequest, this);
    if (localPeer != null) {
      previousRole = localPeer?.role.name;
      if (isRaisedHand) {
        toggleLocalPeerHandRaise();
      }

      ///Setting the previous role
      _hmsSDKInteractor.changeMetadata(
          metadata: "{\"isBRBOn\":false,\"prevRole\":\"$previousRole\"}",
          hmsActionResultListener: this);
      // resetLayout(hmsRoleChangeRequest.suggestedRole.name);
      currentRoleChangeRequest = null;
      notifyListeners();
    }
  }

  void changeName({required String name}) {
    _hmsSDKInteractor.changeName(name: name, hmsActionResultListener: this);
  }

  HMSHLSRecordingConfig? hmshlsRecordingConfig;
  Future<HMSException?> startHLSStreaming(
      bool singleFile, bool videoOnDemand) async {
    hmshlsRecordingConfig = HMSHLSRecordingConfig(
        singleFilePerLayer: singleFile, videoOnDemand: videoOnDemand);
    return await _hmsSDKInteractor.startHLSStreaming(this,
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

  void nextPeersForRole(String role) async {
    dynamic nextSetOfPeers = await peerListIterators[role]?.next();
    if (nextSetOfPeers is List<HMSPeer> && nextSetOfPeers.isNotEmpty) {
      for (var peer in nextSetOfPeers) {
        addPeer(peer);
      }
    }
  }

  ///This method is used to disable the peer list refresh
  void disableRefresh() {
    disablePeerListRefresh = true;
  }

  ///This method is used to enable the peer list refresh
  void enableRefresh() {
    disablePeerListRefresh = false;
  }

  ///This method is used to refresh the peer list
  void refreshPeerList() async {
    ///If the peer list refresh is disabled then we return
    if (disablePeerListRefresh) {
      return;
    }
    log("Calling refresh PeerList Method $peerListIterators");
    peerListIterators.clear();
    List<String>? offStageRoles = HMSRoomLayout.roleLayoutData?.screens
        ?.conferencing?.defaultConf?.elements?.onStageExp?.offStageRoles;
    offStageRoles?.forEach((role) async {
      var peerListIterator = await _hmsSDKInteractor.getPeerListIterator(
          peerListIteratorOptions:
              PeerListIteratorOptions(limit: 10, byRoleName: role));
      if (peerListIterator != null && peerListIterator is HMSPeerListIterator) {
        peerListIterators[role] = peerListIterator;
        participantsInMeeting -= participantsInMeetingMap[role]?.length ?? 0;
        participantsInMeetingMap[role]?.clear();
        dynamic nonRealTimePeers = await peerListIterator.next();
        if (nonRealTimePeers is List<HMSPeer>) {
          log("Calling refresh PeerList Method $nonRealTimePeers");
          if (nonRealTimePeers.isNotEmpty) {
            for (var peer in nonRealTimePeers) {
              addPeer(peer);
            }
          }
        }
      }
    });
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
    notifyListeners();
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
    setParticipantsList(roles);
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index = peerTracks
            .indexWhere((element) => element.uid == "${each.peerId}mainVideo");
        if (index == -1 &&
            (each.audioTrack != null || each.videoTrack != null)) {
          peerTracks.add(PeerTrackNode(
              peer: each,
              uid: "${each.peerId}mainVideo",
              networkQuality: localPeerNetworkQuality,
              stats: RTCStats()));
        }
        localPeer = each;
        addPeer(localPeer!);
        if (HMSRoomLayout
                .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
            null) isHLSLink = true;
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

    if (roles.isEmpty) {
      roles = await getRoles();
      roles.removeWhere((element) => element.name == "__internal_recorder");
      setParticipantsList(roles);
    }
    Utilities.saveStringData(key: "meetingLink", value: meetingUrl);
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();

    // if (Platform.isIOS &&
    //     HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf !=
    //         null) {
    //   HMSIOSPIPController.setup(
    //       autoEnterPip: true,
    //       aspectRatio: [9, 16],
    //       backgroundColor: Colors.black);
    // } else if (Platform.isAndroid) {
    //   HMSAndroidPIPController.setup();
    // }
  }

  void setParticipantsList(List<HMSRole> roles) {
    String? onStageRoles = HMSRoomLayout.roleLayoutData?.screens?.conferencing
        ?.defaultConf?.elements?.onStageExp?.onStageRole;
    if (onStageRoles != null) {
      participantsInMeetingMap[onStageRoles] = [];
    }
    roles
        .where((role) => role.publishSettings?.allowed.isNotEmpty ?? false)
        .forEach((element) {
      participantsInMeetingMap[element.name] = [];
    });

    roles
        .where((role) => role.publishSettings?.allowed.isEmpty ?? false)
        .forEach((element) {
      participantsInMeetingMap[element.name] = [];
    });
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
    peersInRoom = room.peerCount;
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        recordingType["browser"] =
            room.hmsBrowserRecordingState?.running ?? false;
        isRecordingInInitialisingState =
            room.hmsBrowserRecordingState?.initialising ?? false;
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
      default:
        break;
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
      localPeer = peer;
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
      case "role_change_declined":
        toggleRequestDeclined(message.sender);
        break;
      case "chat":
        addMessage(message);
        isNewMessageReceived = true;
        Utilities.showNotification(
            "New message from ${message.sender?.name ?? ""}", "message");
        notifyListeners();
      default:
        break;
    }
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    log("onRoleChangeRequest-> sender: ${roleChangeRequest.suggestedBy} role: ${roleChangeRequest.suggestedRole}");
    if (currentRoleChangeRequest == null) {
      currentRoleChangeRequest = roleChangeRequest;
      previewForRole(roleChangeRequest.suggestedRole.name);
    }
  }

  void setCurrentPage(int newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void setCurrentScreenSharePage(int newPage) {
    currentScreenSharePage = newPage;
    notifyListeners();
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    //To handle the active speaker mode scenario
    if ((currentPage == 0) &&
        (meetingMode == MeetingMode.activeSpeakerWithInset ||
            meetingMode == MeetingMode.activeSpeakerWithoutInset) &&
        peerTracks.length > 6) {
      /* Here we iterate through the updateSpeakers list
       * and do the following:
       * Find the index of the peer
       * If the peer is out of the screen when you are on first page
       * we remove the peer from that index and insert it on the first index
      */
      for (var speaker in updateSpeakers) {
        int index = peerTracks.indexWhere((previousSpeaker) =>
            previousSpeaker.uid == "${speaker.peer.peerId}mainVideo");
        if (index > 5) {
          PeerTrackNode activeSpeaker = peerTracks[index];
          peerTracks.removeAt(index);
          peerTracks.insert(screenShareCount, activeSpeaker);
          peerTracks[screenShareCount].setOffScreenStatus(false);
        }
      }
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
    // if (updateSpeakers.isNotEmpty) {
    //   if (Platform.isIOS && (screenShareCount == 0 || isScreenShareOn)) {
    //     if (updateSpeakers[0].peer.videoTrack != null) {
    //       changePIPWindowTrackOnIOS(
    //           track: updateSpeakers[0].peer.videoTrack,
    //           alternativeText: updateSpeakers[0].peer.name,
    //           ratio: [9, 16]);
    //     } else {
    //       changePIPWindowTextOnIOS(
    //           text: updateSpeakers[0].peer.name, ratio: [9, 16]);
    //     }
    //   } else if (Platform.isAndroid) {
    //     changePIPWindowOnAndroid("${updateSpeakers[0].peer.peerId}mainVideo");
    //   }
    // }
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
    isEndRoomCalled = hmsPeerRemovedFromPeer.roomWasEnded;
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
    // clearPIPState();
    removeListeners();
    toggleAlwaysScreenOn();
    _hmsSDKInteractor.destroy();
    _hmsSessionStore = null;
    peerTracks.clear();
    isRoomEnded = true;
    resetForegroundTaskAndOrientation();

    ///Here we call the method passed by the user in HMSPrebuilt as a callback
    if (Constant.onLeave != null) {
      Constant.onLeave!();
    }
    notifyListeners();
  }

  void resetForegroundTaskAndOrientation() {
    setLandscapeLock(false);
    FlutterForegroundTask.stopService();
  }

  // void clearPIPState() {
  //   if (Platform.isAndroid) {
  //     HMSAndroidPIPController.destroy();
  //   } else if (Platform.isIOS) {
  //     HMSIOSPIPController.destroy();
  //   }
  // }

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
    participantsInMeetingMap[peer.role.name]
        ?.removeWhere((oldPeer) => oldPeer.peer.peerId == peer.peerId);
    participantsInMeeting--;
    if (peer.isHandRaised) {
      participantsInMeetingMap["Hand Raised"]
          ?.removeWhere((oldPeer) => oldPeer.peer.peerId == peer.peerId);
    }
    notifyListeners();
  }

  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
    if (participantsInMeetingMap[peer.role.name]
            ?.indexWhere((element) => element.peer.peerId == peer.peerId) ==
        -1) {
      participantsInMeetingMap[peer.role.name]
          ?.add(ParticipantsStore(peer: peer));
      participantsInMeeting++;
    }
    if (peer.isHandRaised) {
      participantsInMeetingMap["Hand Raised"]
          ?.add(ParticipantsStore(peer: peer));
    }
    notifyListeners();
  }

  void addMessage(HMSMessage message) {
    messages.add(message);
  }

  void updatePeerAt(HMSPeer peer) {
    int index = peers.indexOf(peer);
    if (index != -1) {
      peers.removeAt(index);
      peers.insert(index, peer);
    }
  }

  void updatePeerMap(HMSPeerUpdate peerUpdate, HMSPeer peer,
      {HMSRole? oldRole}) {
    int? index = participantsInMeetingMap[peer.role.name]
        ?.indexWhere((element) => element.peer.peerId == peer.peerId);

    if (index != null && index != -1) {
      if ((peerUpdate == HMSPeerUpdate.nameChanged)) {
        participantsInMeetingMap[peer.role.name]?[index].updatePeer(peer);
        if (peer.isHandRaised) {
          int? peerIndex = participantsInMeetingMap["Hand Raised"]
              ?.indexWhere((element) => element.peer.peerId == peer.peerId);
          if (peerIndex != null && peerIndex != -1) {
            participantsInMeetingMap["Hand Raised"]?[peerIndex]
                .updatePeer(peer);
          }
        }
      } else if (peerUpdate == HMSPeerUpdate.handRaiseUpdated) {
        if (peer.isHandRaised) {
          if (participantsInMeetingMap["Hand Raised"]?.indexWhere(
                  (element) => element.peer.peerId == peer.peerId) ==
              -1) {
            participantsInMeetingMap["Hand Raised"]
                ?.add(ParticipantsStore(peer: peer));
          }
          participantsInMeetingMap[peer.role.name]?[index].updatePeer(peer);
        } else {
          participantsInMeetingMap["Hand Raised"]?.removeWhere(
              (handDownPeer) => handDownPeer.peer.peerId == peer.peerId);
          participantsInMeetingMap[peer.role.name]?[index].updatePeer(peer);
        }
        notifyListeners();
      }
    } else {
      if (peerUpdate == HMSPeerUpdate.roleUpdated) {
        if (oldRole != null) {
          participantsInMeetingMap[oldRole.name]
              ?.removeWhere((oldPeer) => oldPeer.peer.peerId == peer.peerId);
        }
        participantsInMeetingMap["Hand Raised"]
            ?.removeWhere((oldPeer) => oldPeer.peer.peerId == peer.peerId);
        participantsInMeetingMap[peer.role.name]
            ?.add(ParticipantsStore(peer: peer));
        participantsInMeetingMap[peer.role.name]
                ?[participantsInMeetingMap[peer.role.name]!.length - 1]
            .updatePeer(peer);
        notifyListeners();
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
          resetLayout(peer.role.name);
          localPeer = peer;
        }
        if (HMSRoomLayout
                .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
            null) {
          isHLSLink = peer.isLocal;
          peerTracks.removeWhere(
              (leftPeer) => leftPeer.uid == "${peer.peerId}mainVideo");
        } else {
          if (peer.isLocal) {
            isHLSLink = false;
          }
        }

        // if (peer.isLocal) {
        //   if (Platform.isIOS) {
        //     if (HMSRoomLayout
        //             .roleLayoutData?.screens?.conferencing?.hlsLiveStreaming !=
        //         null) {
        //       HMSIOSPIPController.destroy();
        //     } else {
        //       HMSIOSPIPController.setup(
        //           autoEnterPip: true,
        //           aspectRatio: [9, 16],
        //           backgroundColor: Colors.black);
        //     }
        //   }
        // }

        Utilities.showToast("${peer.name}'s role changed to ${peer.role.name}");
        int index = peers.indexOf(peer);
        HMSRole? oldRole;
        if (index != -1) {
          oldRole = peers[index].role;
        }
        updatePeerAt(peer);
        updatePeerMap(update, peer, oldRole: oldRole);
        notifyListeners();
        break;

      case HMSPeerUpdate.metadataChanged:
        if (peer.isLocal) localPeer = peer;
        int index = peerTracks
            .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks[index];
          peerTrackNode.peer = peer;
          peerTrackNode.notify();
        }
        updatePeerAt(peer);
        updatePeerMap(update, peer);
        break;

      case HMSPeerUpdate.handRaiseUpdated:
        if (peer.isLocal) {
          localPeer = peer;
        }
        int index = peerTracks
            .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks[index];
          peerTrackNode.peer = peer;
          peerTrackNode.notify();
        } else {
          if (HMSRoomLayout.peerType == PeerRoleType.conferencing) {
            if (HMSRoomLayout.roleLayoutData?.screens?.conferencing?.defaultConf
                    ?.elements?.onStageExp?.offStageRoles
                    ?.contains(peer.role.name) ??
                false) {
              addRemoveToastsForRoleChange(peer: peer);
            }
          } else if (HMSRoomLayout.peerType == PeerRoleType.hlsViewer) {
            if (HMSRoomLayout.roleLayoutData?.screens?.conferencing
                    ?.hlsLiveStreaming?.elements?.onStageExp?.offStageRoles
                    ?.contains(peer.role.name) ??
                false) {
              addRemoveToastsForRoleChange(peer: peer);
            }
          }
        }
        updatePeerAt(peer);
        updatePeerMap(update, peer);
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
        updatePeerMap(update, peer);
        break;

      case HMSPeerUpdate.networkQualityUpdated:
        int index = peerTracks
            .indexWhere((element) => element.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          peerTracks[index].setNetworkQuality(peer.networkQuality?.quality);
          int? participantsListIndex = participantsInMeetingMap[peer.role.name]
              ?.indexWhere((element) => element.peer.peerId == peer.peerId);
          if (participantsListIndex != null && participantsListIndex != -1) {
            participantsInMeetingMap[peer.role.name]?[participantsListIndex]
                .updatePeer(peer);
          }
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
          if (!peer.isLocal) {
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
              notifyListeners();
              // changePIPWindowTrackOnIOS(
              //     track: track,
              //     ratio: [9, 16],
              //     alternativeText: "${peer.name} Screen share");
            }
          } else {
            isScreenShareActive();
          }
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          if (!peer.isLocal) {
            int peerIndex = peerTracks.indexWhere(
                (element) => element.uid == peer.peerId + track.trackId);
            if (peerIndex != -1) {
              screenShareCount--;
              peerTracks.removeAt(peerIndex);
              notifyListeners();
              // changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
            }

            //pop the full screen screenshare when the screenshare is stopped
            //set the screenshareContext to null
            if (screenshareContext != null) {
              Navigator.pop(screenshareContext!);
              screenshareContext = null;
            }

            ///Need to check why we were doing this
            // peerTracks.removeWhere(
            //     (element) => element.track?.trackId == track.trackId);
          } else {
            isScreenShareActive();
          }
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
              // if (currentPIPtrack == track) {
              //   changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
              // }
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
        // if (currentPIPtrack == track &&
        //     track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        //   changePIPWindowTrackOnIOS(
        //       track: track as HMSVideoTrack,
        //       alternativeText: peer.name,
        //       ratio: [9, 16]);
        // }
        break;
      case HMSTrackUpdate.trackUnMuted:
        // if (currentPIPtrack == track &&
        //     track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        //   changePIPWindowTrackOnIOS(
        //       track: track as HMSVideoTrack,
        //       alternativeText: peer.name,
        //       ratio: [9, 16]);
        // }
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

  ///This method rearranges tiles based on whether camera is ON/OFF
  ///and whether the peer is in spotlight or not
  ///If the peer is in spotlight then it is placed on the first index
  ///If video is ON then the peer is placed on the first index
  ///If video is OFF then the peer is placed on the last index
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

  // void enterPipModeOnAndroid() async {
  //   //to check whether pip is available in android
  //   if (Platform.isAndroid) {
  //     bool isPipAvailable = await HMSAndroidPIPController.isAvailable();
  //     if (isPipAvailable) {
  //       //[isPipActive] method can also be used to check whether application is in pip Mode or not
  //       isPipActive = await HMSAndroidPIPController.start();
  //       notifyListeners();
  //     }
  //   }
  // }

  // Future<bool> isPIPActive() async {
  //   if (Platform.isAndroid) {
  //     isPipActive = await HMSAndroidPIPController.isActive();
  //   } else if (Platform.isIOS) {
  //     isPipActive = await HMSIOSPIPController.isActive();
  //   }
  //   return isPipActive;
  // }

  // void changePIPWindowOnAndroid(String uid) {
  //   if (Platform.isAndroid && isPipActive) {
  //     int index = -1;
  //     index = peerTracks.indexWhere((element) => element.uid == uid);
  //     if (index != -1) {
  //       PeerTrackNode node = peerTracks[index];
  //       peerTracks.removeAt(index);
  //       peerTracks.insert(screenShareCount, node);
  //     }
  //     notifyListeners();
  //   }
  // }

  void switchAudioOutputUsingiOSUI() {
    _hmsSDKInteractor.switchAudioOutputUsingiOSUI();
  }

  // void changePIPWindowTrackOnIOS(
  //     {HMSVideoTrack? track,
  //     required String alternativeText,
  //     required List<int> ratio}) async {
  //   if (Platform.isIOS && track != null) {
  //     isPipActive = await isPIPActive();
  //     if (isPipActive) {
  //       HMSIOSPIPController.changeVideoTrack(
  //           track: track,
  //           aspectRatio: ratio,
  //           alternativeText: alternativeText,
  //           scaleType: ScaleType.SCALE_ASPECT_FILL,
  //           backgroundColor: Colors.black);
  //       currentPIPtrack = track;
  //     }
  //   }
  // }

  // void changePIPWindowTextOnIOS(
  //     {String? text, required List<int> ratio}) async {
  //   if (Platform.isIOS && text != null) {
  //     isPipActive = await isPIPActive();
  //     if (isPipActive) {
  //       HMSIOSPIPController.changeText(
  //           text: text, aspectRatio: ratio, backgroundColor: Colors.black);
  //       currentPIPtrack = null;
  //     }
  //   }
  // }

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

  ///
  /// Method to toggle the role change toast
  ///
  void addRemoveToastsForRoleChange({required HMSPeer peer}) {
    if (peer.isHandRaised) {
      toasts.add(
          HMSToastModel(peer, hmsToastType: HMSToastsType.roleChangeToast));
      notifyListeners();
    } else {
      toasts.removeWhere((toast) =>
          toast.hmsToastType == HMSToastsType.roleChangeToast &&
          peer.peerId == toast.toastData.peerId);
      notifyListeners();
    }
  }

  void toggleChatOverlay() {
    isOverlayChatOpened = !isOverlayChatOpened;
    if (isOverlayChatOpened) {
      isNewMessageReceived = false;
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
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        isRaisedHand = false;
        isBRB = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        isRaisedHand = true;
        isBRB = false;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
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
        toasts.add(HMSToastModel(hmsException,
            hmsToastType: HMSToastsType.errorToast));
        isRecordingInInitialisingState = false;
        notifyListeners();
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
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
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
      // if (Platform.isAndroid) {
      //   isPipActive = await HMSAndroidPIPController.isActive();
      // } else if (Platform.isIOS) {
      //   isPipActive = false;
      // }
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
        // isPipActive = await HMSAndroidPIPController.isActive();
        notifyListeners();
      }

      // if (Platform.isIOS) {
      //   if (screenShareCount == 0 || isScreenShareOn) {
      //     int peerIndex = peerTracks.indexWhere((element) =>
      //         (!(element.track?.isMute ?? true) && !element.peer.isLocal));
      //     if (peerIndex != -1) {
      //       changePIPWindowTrackOnIOS(
      //           track: peerTracks[peerIndex].track,
      //           alternativeText: peerTracks[peerIndex].peer.name,
      //           ratio: [9, 16]);
      //     } else {
      //       changePIPWindowTextOnIOS(text: localPeer?.name, ratio: [9, 16]);
      //     }
      //   } else {
      //     int peerIndex = peerTracks.indexWhere((element) =>
      //         element.uid ==
      //         element.peer.peerId + (element.track?.trackId ?? ""));
      //     if (peerIndex != -1) {
      //       changePIPWindowTrackOnIOS(
      //           track: peerTracks[peerIndex].track,
      //           alternativeText: peerTracks[peerIndex].peer.name,
      //           ratio: [9, 16]);
      //     }
      //   }
      // }
    }
    // else if (state == AppLifecycleState.inactive) {
    //   if (Platform.isAndroid && !isPipActive) {
    //     isPipActive = await HMSAndroidPIPController.isActive();
    //   }
    //   notifyListeners();
    // } else if (state == AppLifecycleState.detached) {
    //   if (Platform.isAndroid && !isPipActive) {
    //     isPipActive = await HMSAndroidPIPController.isActive();
    //   }
    //   notifyListeners();
    // }
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

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    log("onPeerListUpdate -> addedPeers: $addedPeers removedPeers: $removedPeers");
    for (var peer in addedPeers) {
      addPeer(peer);
    }
  }
}
