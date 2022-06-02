//Package imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:intl/intl.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';

class MeetingStore extends ChangeNotifier
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

  String streamUrl = "";

  bool isHLSLink = false;

  HMSRoleChangeRequest? roleChangeRequest;

  bool isMeetingStarted = false;

  bool isVideoOn = true;

  bool isMicOn = true;

  bool isScreenShareOn = false;

  List<HMSTrack?> screenShareTrack = [];

  HMSTrack? curentScreenShareTrack;

  bool reconnecting = false;

  bool reconnected = false;

  bool isRoomEnded = false;

  bool isRecordingStarted = false;

  String description = "Meeting Ended";

  HMSTrackChangeRequest? hmsTrackChangeRequest;

  List<HMSRole> roles = [];

  late int highestSpeakerIndex = -1;

  List<HMSPeer> peers = [];

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
    _hmsSDKInteractor.join(config: config);
    return true;
  }

  void leave() async {
    if (isScreenShareOn) {
      isScreenShareOn = false;
      _hmsSDKInteractor.stopScreenShare();
    }

    _hmsSDKInteractor.removeStatsListener(this);
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
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
    await _hmsSDKInteractor.switchCamera();
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

  void toggleSpeaker() {
    if (isSpeakerOn) {
      muteAll();
    } else {
      unMuteAll();
    }
    isSpeakerOn = !isSpeakerOn;
    notifyListeners();
  }

  void toggleScreenShare() {
    if (!isScreenShareOn) {
      startScreenShare();
    } else {
      stopScreenShare();
    }
  }

  Future<bool> isAudioMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isAudioMute(peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    return await _hmsSDKInteractor.isVideoMute(peer);
  }

  Future<bool> startCapturing() async {
    return await _hmsSDKInteractor.startCapturing();
  }

  void stopCapturing() {
    _hmsSDKInteractor.stopCapturing();
  }

  void removePeer(HMSPeer peer) {
    peers.remove(peer);
    // removeTrackWithPeerId(peer.peerId);
  }

  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
  }

  void onRoleUpdated(int index, HMSPeer peer) {
    peers[index] = peer;
  }

  void updateRoleChangeRequest(HMSRoleChangeRequest roleChangeRequest) {
    this.roleChangeRequest = roleChangeRequest;
  }

  void addMessage(HMSMessage message) {
    this.messages.add(message);
  }

  void addTrackChangeRequestInstance(
      HMSTrackChangeRequest hmsTrackChangeRequest) {
    this.hmsTrackChangeRequest = hmsTrackChangeRequest;
    notifyListeners();
  }

  void updatePeerAt(peer) {
    int index = this.peers.indexOf(peer);
    this.peers.removeAt(index);
    this.peers.insert(index, peer);
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
    if (room.hmsBrowserRecordingState?.running == true ||
        room.hmsServerRecordingState?.running == true ||
        room.hmsRtmpStreamingState?.running == true ||
        room.hmshlsStreamingState?.running == true)
      isRecordingStarted = true;
    else
      isRecordingStarted = false;

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

        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            int index = peerTracks.indexWhere(
                (element) => element.uid == each.peerId + "mainVideo");
            peerTracks[index].track = each.videoTrack!;
            if (each.videoTrack!.isMute) {
              this.isVideoOn = false;
            }
          }
        }
        break;
      }
    }
    roles = await getRoles();
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    switch (update) {
      case HMSRoomUpdate.browserRecordingStateUpdated:
        isRecordingStarted = room.hmsBrowserRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.serverRecordingStateUpdated:
        isRecordingStarted = room.hmsServerRecordingState?.running ?? false;
        break;

      case HMSRoomUpdate.rtmpStreamingStateUpdated:
        isRecordingStarted = room.hmsRtmpStreamingState?.running ?? false;
        break;
      case HMSRoomUpdate.hlsStreamingStateUpdated:
        isRecordingStarted = room.hmshlsStreamingState?.running ?? false;
        hasHlsStarted = room.hmshlsStreamingState?.running ?? false;
        streamUrl = hasHlsStarted
            ? room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl ?? ""
            : "";
        break;
      default:
        break;
    }
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
  void onError({required HMSException error}) {
    this.hmsException = hmsException;
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
    updateRoleChangeRequest(roleChangeRequest);
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

  int trackChange = -1;

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    if (!hmsTrackChangeRequest.mute)
      addTrackChangeRequestInstance(hmsTrackChangeRequest);
    else {
      if (hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        isVideoOn = false;
      } else {
        isMicOn = false;
      }
      notifyListeners();
    }
  }

  void rejectrequest() {
    notifyListeners();
  }

  void changeTracks(HMSTrackChangeRequest hmsTrackChangeRequest) {
    if (hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switchVideo();
    } else {
      switchAudio();
    }
    this.hmsTrackChangeRequest = null;
    // notifyListeners();
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    description = "Removed by ${hmsPeerRemovedFromPeer.peerWhoRemoved?.name}";
    peerTracks.clear();
    isRoomEnded = true;
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

        updatePeerAt(peer);
        notifyListeners();
        break;

      case HMSPeerUpdate.metadataChanged:
        int index = peerTracks
            .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
        if (index != -1) {
          PeerTrackNode peerTrackNode = peerTracks[index];
          peerTrackNode.peer = peer;
          peerTrackNode.notify();
        }
        updatePeerAt(peer);
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
          screenShareCount++;
          peerTracks.insert(
              0,
              PeerTrackNode(
                  peer: peer,
                  uid: peer.peerId + track.trackId,
                  track: track as HMSVideoTrack));
          isScreenShareActive();
          // for (var node in peerTracks) {
          //   if (node.isOffscreen == false) {
          //     node.setOffScreenStatus(true);
          //   }
          // }
          // controller.jumpTo(0);
          notifyListeners();
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          screenShareCount--;
          peerTracks.removeWhere(
              (element) => element.uid == peer.peerId + track.trackId);
          notifyListeners();
        } else {
          isScreenShareActive();
        }
        break;
      case HMSTrackUpdate.trackMuted:
        // trackStatus[peer.peerId] = HMSTrackUpdate.trackMuted;
        break;
      case HMSTrackUpdate.trackUnMuted:
        // trackStatus[peer.peerId] = HMSTrackUpdate.trackUnMuted;
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

  void endRoom(bool lock, String? reason) {
    _hmsSDKInteractor.endRoom(lock, reason == null ? "" : reason, this);
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

  Future<HMSPeer?> getLocalPeer() async {
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

  bool isRaisedHand = false;

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
    this.roleChangeRequest = null;
    notifyListeners();
  }

  void changeName({required String name}) {
    _hmsSDKInteractor.changeName(name: name, hmsActionResultListener: this);
  }

  void startHLSStreaming(String meetingUrl) {
    _hmsSDKInteractor.startHLSStreaming(meetingUrl, this);
  }

  void stopHLSStreaming() {
    _hmsSDKInteractor.stopHLSStreaming(hmsActionResultListener: this);
  }

  void changeTrackStateForRole(bool mute, List<HMSRole>? roles) {
    _hmsSDKInteractor.changeTrackStateForRole(
        true, HMSTrackKind.kHMSTrackKindAudio, "regular", roles, this);
  }

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

  void setSettings() {
    isMirror = _hmsSDKInteractor.mirrorCamera;
    isStatsVisible = _hmsSDKInteractor.showStats;
    if (isStatsVisible) {
      _hmsSDKInteractor.addStatsListener(this);
    }
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

  int isActiveSpeaker(String uid) {
    return activeSpeakerIds.containsKey(uid) ? activeSpeakerIds[uid]! : -1;
  }

  void showToast(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: Colors.black87);
  }

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
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        showToast("Track State Changed");
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.endRoom:
        this.isRoomEnded = true;
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        showToast("Accept role change successful");
        break;
      case HMSActionResultListenerMethod.changeRole:
        showToast("Change role successful");
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        message = arguments!['roles'] == null
            ? "Successfully Muted All"
            : "Successfully Muted Role";
        showToast(message);
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        showToast("RTMP start successful");

        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        showToast("RTMP stop successful");
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.changeName:
        showToast("Change name successful");
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
        hasHlsStarted = true;
        showToast("HLS Streaming Started");
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        hasHlsStarted = false;
        showToast("HLS Streaming Stopped");
        notifyListeners();
        break;

      case HMSActionResultListenerMethod.startScreenShare:
        showToast("Screen Share Started");
        isScreenShareActive();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        showToast("Screen Share Stopped");
        isScreenShareActive();
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
        showToast("Leave Operation failed");
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        showToast("Change Track state failed");
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        showToast("End room failed");
        break;
      case HMSActionResultListenerMethod.removePeer:
        showToast("Remove peer failed");
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        showToast("Accept change role failed");
        break;
      case HMSActionResultListenerMethod.changeRole:
        showToast("Change role failed");
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        showToast("Failed to change track state");
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        if (hmsException.code?.errorCode == "400") {
          isRecordingStarted = true;
        }
        showToast("Start RTMP Streaming failed");
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        showToast("Stop RTMP Streaming failed");
        break;
      case HMSActionResultListenerMethod.changeName:
        showToast("Name change failed");
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        showToast("Start HLS failed");
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        showToast("Stop HLS failed");
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        isScreenShareActive();
        showToast("Start screenshare failed");
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        isScreenShareActive();
        showToast("Stop screenshare failed");
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
    }
  }

  Future<List<HMSPeer>?> getPeers() async {
    return await _hmsSDKInteractor.getPeers();
  }
}
