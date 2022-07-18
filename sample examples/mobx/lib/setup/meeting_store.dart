//Package imports
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx_example/service/room_service.dart';
import 'package:mobx_example/setup/hms_sdk_interactor.dart';
import 'package:mobx_example/setup/peer_track_node.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase extends ChangeNotifier
    with Store
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDKInteractor _hmsSDKInteractor;

  MeetingStoreBase() {
    _hmsSDKInteractor = HMSSDKInteractor();
  }

  // HMSLogListener
  @observable
  bool isSpeakerOn = true;
  @observable
  String screenSharePeerId = '';
  @observable
  HMSException? hmsException;
  @observable
  bool hasHlsStarted = false;

  String streamUrl = "";
  @observable
  bool isHLSLink = false;

  @observable
  HMSRoleChangeRequest? roleChangeRequest;

  @observable
  bool isMeetingStarted = false;
  @observable
  bool isVideoOn = true;
  @observable
  bool isMicOn = true;
  @observable
  bool isScreenShareOn = false;
  @observable
  ObservableList<HMSTrack?> screenShareTrack = ObservableList.of([]);

  @observable
  HMSTrack? curentScreenShareTrack;

  @observable
  bool reconnecting = false;
  @observable
  bool reconnected = false;
  @observable
  bool isRoomEnded = false;
  @observable
  bool isRecordingStarted = false;
  @observable
  String event = '';

  @observable
  HMSTrackChangeRequest? hmsTrackChangeRequest;
  @observable
  List<HMSRole> roles = [];

  late int highestSpeakerIndex = -1;

  @observable
  HMSPeer? localPeer;
  @observable
  HMSTrack? localTrack;

  @observable
  HMSTrack? screenTrack;

  @observable
  bool isActiveSpeakerMode = false;

  @observable
  ObservableList<PeerTrackNode> activeSpeakerPeerTracksStore =
      ObservableList.of([]);

  @observable
  ObservableList<HMSTrack> tracks = ObservableList.of([]);

  @observable
  ObservableList<HMSTrack> audioTracks = ObservableList.of([]);

  @observable
  ObservableList<HMSMessage> messages = ObservableList.of([]);

  @observable
  ObservableMap<String, HMSTrackUpdate> trackStatus = ObservableMap.of({});

  @observable
  ObservableMap<String, HMSTrackUpdate> audioTrackStatus = ObservableMap.of({});

  @observable
  ObservableList<PeerTrackNode> peerTracks = ObservableList.of([]);

  HMSRoom? hmsRoom;

  int firstTimeBuild = 0;
  final DateFormat formatter = DateFormat('d MMM y h:mm:ss a');

  @action
  void addUpdateListener() {
    _hmsSDKInteractor.addUpdateListener(this);
    // startHMSLogger(HMSLogLevel.VERBOSE, HMSLogLevel.VERBOSE);
    // addLogsListener();
  }

  @action
  void removeUpdateListener() {
    _hmsSDKInteractor.removeUpdateListener(this);
    // removeLogsListener();
  }

  @action
  Future<bool> join(String user, String roomUrl) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init");

    await _hmsSDKInteractor.join(config: config);
    isMeetingStarted = true;
    return true;
  }

  void leave() async {
    if (isScreenShareOn) {
      isScreenShareOn = false;
      _hmsSDKInteractor.stopScreenShare();
    }
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
    isRoomEnded = true;
    peerTracks.clear();
  }

  @action
  Future<void> switchAudio() async {
    await _hmsSDKInteractor.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
  }

  @action
  Future<void> switchVideo() async {
    await _hmsSDKInteractor.switchVideo(isOn: isVideoOn);
    if (isVideoOn) {
      trackStatus[localPeer!.peerId] = HMSTrackUpdate.trackMuted;
    } else {
      trackStatus[localPeer!.peerId] = HMSTrackUpdate.trackUnMuted;
    }

    isVideoOn = !isVideoOn;
  }

  @action
  Future<void> switchCamera() async {
    await _hmsSDKInteractor.switchCamera();
  }

  @action
  void sendBroadcastMessage(String message) {
    _hmsSDKInteractor.sendBroadcastMessage(message, this);
  }

  void sendDirectMessage(String message, HMSPeer peer) async {
    _hmsSDKInteractor.sendDirectMessage(message, peer, this);
  }

  void sendGroupMessage(String message, List<HMSRole> roles) async {
    _hmsSDKInteractor.sendGroupMessage(message, roles, this);
  }

  @action
  void toggleSpeaker() {
    if (isSpeakerOn) {
      muteAll();
    } else {
      unMuteAll();
    }
    isSpeakerOn = !isSpeakerOn;
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

  @action
  void removeTrackWithTrackId(String trackId) {
    tracks.removeWhere((eachTrack) => eachTrack.trackId == trackId);
  }

  @action
  void removeTrackWithPeerIdExtra(String trackId) {
    var index = tracks.indexWhere((element) => trackId == element.trackId);
    tracks.removeAt(index);
  }

  @action
  void updateRoleChangeRequest(HMSRoleChangeRequest roleChangeRequest) {
    this.roleChangeRequest = roleChangeRequest;
  }

  @action
  void addMessage(HMSMessage message) {
    messages.add(message);
  }

  @action
  void addTrackChangeRequestInstance(
      HMSTrackChangeRequest hmsTrackChangeRequest) {
    this.hmsTrackChangeRequest = hmsTrackChangeRequest;
  }

  @action
  Future<void> isScreenShareActive() async {
    isScreenShareOn = await _hmsSDKInteractor.isScreenShareActive();
  }

  @override
  void onJoin({required HMSRoom room}) async {
    hmsRoom = room;

    if (room.hmshlsStreamingState?.running ?? false) {
      hasHlsStarted = true;
      streamUrl = room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl ?? "";
    } else {
      hasHlsStarted = false;
    }
    if (room.hmsBrowserRecordingState?.running == true) {
      isRecordingStarted = true;
    } else {
      isRecordingStarted = false;
    }

    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index = peerTracks
            .indexWhere((element) => element.peer.peerId == each.peerId);
        if (index == -1) {
          peerTracks.add(PeerTrackNode(peer: each, name: each.name));
        }
        localPeer = each;
        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            int index = peerTracks
                .indexWhere((element) => element.peer.peerId == each.peerId);
            peerTracks[index].track = each.videoTrack!;

            localTrack = each.videoTrack;
            if (each.videoTrack!.isMute) {
              isVideoOn = false;
            }
          }
        }
        break;
      }
    }

    roles = await getRoles();
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
        hasHlsStarted = room.hmshlsStreamingState?.running ?? false;

        streamUrl = hasHlsStarted
            ? room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl ?? ""
            : "";
        break;
      default:
        print('on room update ${update.toString()}');
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
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

    if (peer.isLocal &&
        trackUpdate == HMSTrackUpdate.trackMuted &&
        track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      isMicOn = false;
    }

    if (peer.isLocal) {
      localPeer = peer;

      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        localTrack = track;
        if (track.isMute) {
          isVideoOn = false;
        }
      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      int index = peerTracks
          .indexWhere((element) => element.peer.peerId == peer.peerId);
      if (index != -1) peerTracks[index].audioTrack = track;
      return;
    }

    if (track.source == "REGULAR") {
      int index = peerTracks
          .indexWhere((element) => element.peer.peerId == peer.peerId);
      if (index != -1) peerTracks[index].track = track as HMSVideoTrack;
    }

    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onHMSError({required HMSException error}) {
    hmsException = hmsException;
  }

  @override
  void onMessage({required HMSMessage message}) {
    addMessage(message);
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    updateRoleChangeRequest(roleChangeRequest);
  }

  HMSTrack? previousHighestVideoTrack;
  int previousHighestIndex = -1;
  @observable
  ObservableMap<String, String> observableMap = ObservableMap.of({});

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    //Highest Speaker Update is currently Off
    // if (!isActiveSpeakerMode) {
    //   if (updateSpeakers.length == 0) {
    //     peerTracks.removeAt(highestSpeakerIndex);
    //     peerTracks.insert(highestSpeakerIndex, highestSpeaker);
    //     highestSpeaker = PeerTracKNode(peerId: "-1");
    //     return;
    //   }
    //
    //   highestSpeakerIndex = peerTracks.indexWhere((element) =>
    //       element.peerId.trim() == updateSpeakers[0].peer.peerId.trim());
    //
    //   print("index is $highestSpeakerIndex");
    //   if (highestSpeakerIndex != -1) {
    //     highestSpeaker = peerTracks[highestSpeakerIndex];
    //     peerTracks.removeAt(highestSpeakerIndex);
    //     peerTracks.insert(highestSpeakerIndex, highestSpeaker);
    //   } else {
    //     highestSpeaker = PeerTracKNode(peerId: "-1");
    //   }
    // } else {
    //   if (updateSpeakers.length == 0) {
    //     activeSpeakerPeerTracksStore.removeAt(0);
    //     activeSpeakerPeerTracksStore.insert(0, highestSpeaker);
    //     highestSpeaker = PeerTracKNode(peerId: "-1");
    //     return;
    //   }
    //   highestSpeakerIndex = activeSpeakerPeerTracksStore.indexWhere((element) =>
    //       element.peerId.trim() == updateSpeakers[0].peer.peerId.trim());
    //
    //   print("index is $highestSpeakerIndex");
    //   if (highestSpeakerIndex != -1) {
    //     highestSpeaker = activeSpeakerPeerTracksStore[highestSpeakerIndex];
    //     activeSpeakerPeerTracksStore.removeAt(highestSpeakerIndex);
    //     activeSpeakerPeerTracksStore.insert(0, highestSpeaker);
    //   } else {
    //     highestSpeaker = PeerTracKNode(peerId: "-1");
    //   }
    // }
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
    if (!hmsTrackChangeRequest.mute) {
      addTrackChangeRequestInstance(hmsTrackChangeRequest);
    }
  }

  void changeTracks(HMSTrackChangeRequest hmsTrackChangeRequest) {
    if (hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switchVideo();
    } else {
      switchAudio();
    }
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    peerTracks.clear();
    isRoomEnded = true;
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

  @action
  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (peer.role.name.contains("hls-") == false) {
          int index = peerTracks
              .indexWhere((element) => element.peer.peerId == peer.peerId);
          if (index == -1) {
            peerTracks.add(PeerTrackNode(peer: peer, name: peer.name));
          }
        }
        break;
      case HMSPeerUpdate.peerLeft:
        peerTracks.removeWhere((element) => element.peer.peerId == peer.peerId);
        break;
      case HMSPeerUpdate.roleUpdated:
        if (peer.isLocal) {
          localPeer = peer;
          if (!peer.role.name.contains("hls-")) {
            isHLSLink = false;
          }
        }
        if (peer.role.name.contains("hls-") == false) {
          int index = peerTracks
              .indexWhere((element) => element.peer.peerId == peer.peerId);
          //if (index != -1) peerTracks[index].track = track;
          if (index == -1) {
            peerTracks.add(PeerTrackNode(peer: peer, name: peer.name));
          }
        }
        break;
      case HMSPeerUpdate.metadataChanged:
        int index = peerTracks
            .indexWhere((element) => element.peer.peerId == peer.peerId);
        if (index != -1) {
          peerTracks[index].isRaiseHand =
              (peer.metadata?.contains("\"isHandRaised\":true") ?? false);
        }
        if (peer.isLocal) {
          localPeer = peer;
        }
        break;
      case HMSPeerUpdate.nameChanged:
        if (peer.isLocal) {
          int localPeerIndex = peerTracks.indexWhere(
              (element) => element.peer.peerId == localPeer!.peerId);
          if (localPeerIndex != -1) {
            peerTracks[localPeerIndex].name = peer.name;
            localPeer = peer;
          }
        } else {
          int remotePeerIndex = peerTracks
              .indexWhere((element) => element.peer.peerId == peer.peerId);
          if (remotePeerIndex != -1) {
            peerTracks[remotePeerIndex].name = peer.name;
          }
        }
        break;
      case HMSPeerUpdate.defaultUpdate:
        print("Some default update or untouched case");
        break;
      default:
        print("Some default update or untouched case");
    }
  }

  @action
  void peerOperationWithTrack(
      HMSPeer peer, HMSTrackUpdate update, HMSTrack track) {
    switch (update) {
      case HMSTrackUpdate.trackAdded:
        if (track.source == "REGULAR") {
          trackStatus[peer.peerId] = track.isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
        } else {
          screenShareTrack.add(track);
          curentScreenShareTrack = screenShareTrack.first;
          screenSharePeerId = peer.peerId;
          isScreenShareActive();
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          screenShareTrack
              .removeWhere((element) => element?.trackId == track.trackId);
          if (screenShareTrack.isNotEmpty) {
            curentScreenShareTrack = screenShareTrack.first;
            screenSharePeerId = peer.peerId;
          } else {
            curentScreenShareTrack = null;
            screenSharePeerId = "";
          }
        } else {
          peerTracks
              .removeWhere((element) => element.peer.peerId == peer.peerId);
          isScreenShareActive();
        }
        break;
      case HMSTrackUpdate.trackMuted:
        trackStatus[peer.peerId] = HMSTrackUpdate.trackMuted;
        break;
      case HMSTrackUpdate.trackUnMuted:
        trackStatus[peer.peerId] = HMSTrackUpdate.trackUnMuted;
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
        print("Some default update or untouched case");
    }
  }

  void endRoom(bool lock, String? reason) {
    _hmsSDKInteractor.endRoom(lock, reason ?? "", this);
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

  Future<HMSPeer?> getLocalPeer() async {
    return await _hmsSDKInteractor.getLocalPeer();
  }

  void startRtmpOrRecording(
      {required String meetingUrl,
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

  bool isRaisedHand = false;

  void changeMetadata() {
    isRaisedHand = !isRaisedHand;
    String value = isRaisedHand ? "true" : "false";
    _hmsSDKInteractor.changeMetadata(
        metadata: "{\"isHandRaised\":$value}", hmsActionResultListener: this);
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

  void changeTrackStateForRole(bool mute, List<HMSRole>? roles) {
    _hmsSDKInteractor.changeTrackStateForRole(
        true, HMSTrackKind.kHMSTrackKindAudio, "regular", roles, this);
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        isRoomEnded = true;
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        print("raised hand");
        break;
      case HMSActionResultListenerMethod.endRoom:
        isRoomEnded = true;
        break;
      case HMSActionResultListenerMethod.removePeer:
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        break;
      case HMSActionResultListenerMethod.changeRole:
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        event = arguments!['roles'] == null
            ? "Successfully Muted All"
            : "Successfully Muted Role";
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.changeName:
        event = "Name Changed to ${localPeer!.name}";
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
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        break;

      case HMSActionResultListenerMethod.startScreenShare:
        print("startScreenShare success");
        isScreenShareActive();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        print("stopScreenShare success");
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
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
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        break;
      case HMSActionResultListenerMethod.endRoom:
        print("HMSException ${hmsException.message}");
        break;
      case HMSActionResultListenerMethod.removePeer:
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        break;
      case HMSActionResultListenerMethod.changeRole:
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        event = "Failed to Mute";
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        if (hmsException.code?.errorCode == "400") {
          isRecordingStarted = true;
        }
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.unknown:
        print("Unknown Method Called");
        break;
      case HMSActionResultListenerMethod.changeName:
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        print("sendBroadcastMessage failure");
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
        print("startScreenShare exception");
        isScreenShareActive();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        print("stopScreenShare exception");
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        // TODO: Handle this case.
        break;
    }
  }

  Future<List<HMSPeer>?> getPeers() async {
    return await _hmsSDKInteractor.getPeers();
  }
}
