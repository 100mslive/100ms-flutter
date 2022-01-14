//Package imports
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:hmssdk_flutter_example/manager/HmsSdkManager.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase extends ChangeNotifier
    with Store
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDKInteractor _hmssdkInteractor;
  MeetingStoreBase() {
    _hmssdkInteractor = HmsSdkManager.hmsSdkInteractor!;
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

  String streamUrl="";
  @observable
  bool isHLSLink=false;
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
  HMSTrack? screenShareTrack;
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

  late PeerTracKNode highestSpeaker = PeerTracKNode(peerId: "-1");
  late int highestSpeakerIndex = -1;

  @observable
  ObservableList<HMSPeer> peers = ObservableList.of([]);

  @observable
  HMSPeer? localPeer;
  @observable
  HMSTrack? localTrack;

  @observable
  HMSTrack? screenTrack;

  @observable
  bool isActiveSpeakerMode = false;

  @observable
  ObservableList<PeerTracKNode> activeSpeakerPeerTracksStore =
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
  ObservableList<PeerTracKNode> peerTracks = ObservableList.of([]);

  HMSRoom? hmsRoom;

  int firstTimeBuild = 0;

  @action
  void startListen() {
    HmsSdkManager.hmsSdkInteractor?.addMeetingListener(this);
    // startHMSLogger(HMSLogLevel.VERBOSE, HMSLogLevel.VERBOSE);
    // addLogsListener();
  }

  @action
  void removeListenerMeeting() {
    _hmssdkInteractor.removeMeetingListener(this);
    // removeLogsListener();
  }

  @action
  Future<bool> join(String user, String roomUrl) async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
        userId: Uuid().v1(),
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init");

    await HmsSdkManager.hmsSdkInteractor?.join(config: config);
    isMeetingStarted = true;
    return true;
  }

  void leave() async {
    _hmssdkInteractor.leave(hmsActionResultListener: this);
    isRoomEnded = true;
    peerTracks.clear();
  }

  @action
  Future<void> switchAudio() async {
    await _hmssdkInteractor.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
  }

  @action
  Future<void> switchVideo() async {
    await _hmssdkInteractor.switchVideo(isOn: isVideoOn);
    isVideoOn = !isVideoOn;
  }

  @action
  Future<void> switchCamera() async {
    await _hmssdkInteractor.switchCamera();
  }

  @action
  void sendBroadcastMessage(String message) {
    _hmssdkInteractor.sendBroadcastMessage(message, this);
  }

  void sendDirectMessage(String message, HMSPeer peer) async {
    _hmssdkInteractor.sendDirectMessage(message, peer, this);
  }

  void sendGroupMessage(String message, String roleName) async {
    _hmssdkInteractor.sendGroupMessage(message, roleName, this);
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
    // TODO: add permission checks in exmaple app UI
    return await _hmssdkInteractor.isAudioMute(peer);
  }

  Future<bool> isVideoMute(HMSPeer? peer) async {
    // TODO: add permission checks in exmaple app UI
    return await _hmssdkInteractor.isVideoMute(peer);
  }

  Future<bool> startCapturing() async {
    return await _hmssdkInteractor.startCapturing();
  }

  void stopCapturing() {
    _hmssdkInteractor.stopCapturing();
  }

  @action
  void removePeer(HMSPeer peer) {
    peers.remove(peer);
    removeTrackWithPeerId(peer.peerId);
  }

  @action
  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
  }

  @action
  void removeTrackWithTrackId(String trackId) {
    tracks.removeWhere((eachTrack) => eachTrack.trackId == trackId);
  }

  @action
  void removeTrackWithPeerId(String peerId) {
    tracks.removeWhere((eachTrack) => eachTrack.peer?.peerId == peerId);
  }

  @action
  void removeTrackWithPeerIdExtra(String trackId) {
    var index = tracks.indexWhere((element) => trackId == element.trackId);
    tracks.removeAt(index);
  }

  @action
  int insertTrackWithPeerId(HMSPeer peer) {
    return tracks.indexWhere((element) => peer.peerId == element.peer!.peerId);
  }

  @action
  void addTrack(HMSTrack track, HMSPeer peer) {
    var index = -1;
    if (track.source.trim() == "REGULAR") index = insertTrackWithPeerId(peer);

    if (index >= 0) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        tracks.insert(index, track);
        tracks.removeAt(index + 1);
      }
    } else if (index == -1 && track.source.trim() != "REGULAR") {
      tracks.insert(0, track);
    } else {
      tracks.add(track);
    }
  }

  @action
  void onRoleUpdated(int index, HMSPeer peer) {
    peers[index] = peer;
  }

  @action
  void updateRoleChangeRequest(HMSRoleChangeRequest roleChangeRequest) {
    this.roleChangeRequest = roleChangeRequest;
  }

  @action
  void addMessage(HMSMessage message) {
    this.messages.add(message);
  }

  @action
  void addTrackChangeRequestInstance(
      HMSTrackChangeRequest hmsTrackChangeRequest) {
    this.hmsTrackChangeRequest = hmsTrackChangeRequest;
  }

  @action
  void updatePeerAt(peer) {
    int index = this.peers.indexOf(peer);
    this.peers.removeAt(index);
    this.peers.insert(index, peer);
  }

  @override
  void onJoin({required HMSRoom room}) async {
    hmsRoom = room;

    if(room.hmshlsStreamingState?.running??false){
      hasHlsStarted=true;
      streamUrl = room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl??"";
    }
    else{
      hasHlsStarted=false;
    }
    if (room.hmsBrowserRecordingState?.running == true)
      isRecordingStarted = true;
    else
      isRecordingStarted = false;

    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index =
            peerTracks.indexWhere((element) => element.peerId == each.peerId);
        if (index == -1)
          peerTracks
              .add(new PeerTracKNode(peerId: each.peerId, name: each.name));
        localPeer = each;
        addPeer(localPeer!);
        if(localPeer!.role!.name.contains("hls-")==true)
          isHLSLink=true;

        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            int index = peerTracks
                .indexWhere((element) => element.peerId == each.peerId);
            peerTracks[index].track = each.videoTrack!;

            localTrack = each.videoTrack;
            if (each.videoTrack!.isMute) {
              this.isVideoOn = false;
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
        streamUrl = room.hmshlsStreamingState?.variants[0]?.hlsStreamUrl??"";
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
      this.isMicOn = false;
    }

    if (peer.isLocal) {
      localPeer = peer;

      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        localTrack = track;
        if (track.isMute) {
          this.isVideoOn = false;
        }
      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      int index =
          peerTracks.indexWhere((element) => element.peerId == peer.peerId);
      if (index != -1) peerTracks[index].audioTrack = track;
      return;
    }
    if (track.source == "REGULAR") {
      int index =
          peerTracks.indexWhere((element) => element.peerId == peer.peerId);
      if (index != -1) peerTracks[index].track = track;
    }

    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onError({required HMSException error}) {
    this.hmsException = hmsException;
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
    if (!hmsTrackChangeRequest.mute)
      addTrackChangeRequestInstance(hmsTrackChangeRequest);
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
    leave();
  }

  void changeRole(
      {required HMSPeer peer,
      required String roleName,
      bool forceChange = false}) {
    _hmssdkInteractor.changeRole(
        roleName: roleName,
        peer: peer,
        forceChange: forceChange,
        hmsActionResultListener: this);
  }

  Future<List<HMSRole>> getRoles() async {
    return await _hmssdkInteractor.getRoles();
  }

  void changeTrackState(HMSPeer peer, bool mute, bool isVideoTrack) {
    return HmsSdkManager.hmsSdkInteractor
        ?.changeTrackState(peer, mute, isVideoTrack, this);
  }

  @action
  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        //TODO-> containsPeer or not
        if(peer.role?.name.contains("hls-")==false)
          peerTracks.add(new PeerTracKNode(peerId: peer.peerId, name: peer.name));
        addPeer(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        peerTracks.removeWhere((element) => element.peerId == peer.peerId);
        removePeer(peer);
        break;

      case HMSPeerUpdate.audioToggled:
        break;
      case HMSPeerUpdate.videoToggled:
        break;
      case HMSPeerUpdate.roleUpdated:
        if (peer.isLocal) {
          localPeer = peer;
        }
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.metadataChanged:
        int index =
            peerTracks.indexWhere((element) => element.peerId == peer.peerId);
        if (index != -1) {
          peerTracks[index].isRaiseHand =
              (peer.metadata == "{\"isHandRaised\":true}");
        }
        if (peer.isLocal) {
          localPeer = peer;
        }
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.nameChanged:
        if (peer.isLocal) {
          int localPeerIndex = peerTracks
              .indexWhere((element) => element.peerId == localPeer!.peerId);
          if (localPeerIndex != -1) {
            peerTracks[localPeerIndex].name = peer.name;
            localPeer = peer;
          }
        } else {
          int remotePeerIndex =
              peerTracks.indexWhere((element) => element.peerId == peer.peerId);
          if (remotePeerIndex != -1) {
            peerTracks[remotePeerIndex].name = peer.name;
          }
        }

        updatePeerAt(peer);
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
          screenSharePeerId = peer.peerId;
          screenShareTrack = track;
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.source != "REGULAR") {
          screenSharePeerId = "";
          screenShareTrack = null;
        } else {
          peerTracks.removeWhere((element) => element.peerId == peer.peerId);
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
    _hmssdkInteractor.endRoom(lock, reason == null ? "" : reason, this);
  }

  void removePeerFromRoom(HMSPeer peer) {
    _hmssdkInteractor.removePeer(peer, this);
  }

  void muteAll() {
    _hmssdkInteractor.muteAll();
  }

  void unMuteAll() {
    _hmssdkInteractor.unMuteAll();
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
    return await _hmssdkInteractor.getLocalPeer();
  }

  void startRtmpOrRecording(
      {required String meetingUrl,
      required bool toRecord,
      List<String>? rtmpUrls}) async {
    HMSRecordingConfig hmsRecordingConfig = new HMSRecordingConfig(
        meetingUrl: meetingUrl, toRecord: toRecord, rtmpUrls: rtmpUrls);

    _hmssdkInteractor.startRtmpOrRecording(hmsRecordingConfig, this);
  }

  void stopRtmpAndRecording() async {
    _hmssdkInteractor.stopRtmpAndRecording(this);
  }

  Future<HMSRoom?> getRoom() async {
    HMSRoom? room = await _hmssdkInteractor.getRoom();
    return room;
  }

  Future<HMSPeer?> getPeer({required String peerId}) async {
    return await _hmssdkInteractor.getPeer(peerId: peerId);
  }

  bool isRaisedHand = false;
  void changeMetadata() {
    isRaisedHand = !isRaisedHand;
    String value = isRaisedHand ? "true" : "false";
    _hmssdkInteractor.changeMetadata(
        metadata: "{\"isHandRaised\":$value}", hmsActionResultListener: this);
  }

  void setPlayBackAllowed(bool allow) {
    _hmssdkInteractor.setPlayBackAllowed(allow);
  }

  void acceptChangeRole() {
    _hmssdkInteractor.acceptChangeRole(this);
  }

  void changeName({required String name}) {
    _hmssdkInteractor.changeName(name: name, hmsActionResultListener: this);
  }

  Future<void> startHLSStreaming(String meetingUrl) async {
    await _hmssdkInteractor.startHLSStreaming(meetingUrl);
  }

  Future<void> stopHLSStreaming() async {
    await _hmssdkInteractor.stopHLSStreaming(hmsActionResultListener: this);
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
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        print("raised hand");
        break;
      case HMSActionResultListenerMethod.endRoom:
        isRoomEnded = true;
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        //TODO: HmsException?.code == 400(To see what this means)
        //isRecordingStarted = true;
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
      case HMSActionResultListenerMethod.changeName:
        // TODO: Handle this case.
        this.event = "Name Changed to ${localPeer!.name}";
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
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
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        // TODO: Handle this case.
        print("HMSException ${hmsException.message}");
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        if (hmsException.code?.errorCode == "400") {
          isRecordingStarted = true;
        }
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.unknown:
        print("Unknown Method Called");
        break;
      case HMSActionResultListenerMethod.changeName:
        // TODO: Handle this case.
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
    }
  }
}
