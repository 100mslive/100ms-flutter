// import 'dart:convert';
import 'dart:io';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';

// import 'package:hmssdk_flutter/src/enum/hms_log_level.dart';
// import 'package:hmssdk_flutter_example/logs/static_logger.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:mobx/mobx.dart';
import 'package:hmssdk_flutter_example/manager/HmsSdkManager.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

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
    print("removeTrackWithTrackId ${tracks.length} before");
    tracks.removeWhere((eachTrack) => eachTrack.trackId == trackId);
    print("removeTrackWithTrackId ${tracks.length} after");
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
        print(
            "${tracks[index].isMute} ${tracks[index].source} ${peer.name} addTrack}");
      }
    } else if (index == -1 && track.source.trim() != "REGULAR") {
      print("ScreenShare Enabled");
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
    if (update == HMSRoomUpdate.browserRecordingStateUpdated) {
      if (room.hmsBrowserRecordingState?.running == true)
        isRecordingStarted = true;
      else
        isRecordingStarted = false;
    }
    print('on room update ${update.toString()}');
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    peerOperation(peer, update);
    // print("${peerTracks.toString()} onPeerUpdateListLength");
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    print("Called After Reconnection ${peer.name} ${track.source}");
    print("${peer.name} ${track.kind} onTrackUpdateFlutterMeetingStore");
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
        print("LOCALPEERTRACKVideo");
        localTrack = track;
        if (track.isMute) {
          this.isVideoOn = false;
        }
      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      int index =
          peerTracks.indexWhere((element) => element.peerId == peer.peerId);
      peerTracks[index].audioTrack = track;
      return;
    }
    if (track.source == "REGULAR") {
      int index =
          peerTracks.indexWhere((element) => element.peerId == peer.peerId);
      peerTracks[index].track = track;
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
    debugPrint("onRoleChangeRequest Flutter");
    updateRoleChangeRequest(roleChangeRequest);
  }

  HMSTrack? previousHighestVideoTrack;
  int previousHighestIndex = -1;
  @observable
  ObservableMap<String, String> observableMap = ObservableMap.of({});

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
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
    print("onRemovedFromRoomFlutter $hmsPeerRemovedFromPeer");
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
    print("peerOperation ${peer.name} $update");
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        print('peer joined');
        //TODO-> containsPeer or not
        int index =
            peerTracks.indexWhere((element) => element.peerId == peer.peerId);
        if (index == -1)
          peerTracks
              .add(new PeerTracKNode(peerId: peer.peerId, name: peer.name));
        addPeer(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        print('peer left');
        peerTracks.removeWhere((element) => element.peerId == peer.peerId);
        removePeer(peer);
        break;

      case HMSPeerUpdate.audioToggled:
        print('Peer audio toggled');
        break;
      case HMSPeerUpdate.videoToggled:
        print('Peer video toggled');
        break;
      case HMSPeerUpdate.roleUpdated:
        print('${peers.indexOf(peer)}');
        if (peer.isLocal) {
          localPeer = peer;
        }
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.metadataChanged:
        int index =
            peerTracks.indexWhere((element) => element.peerId == peer.peerId);
        if (index != -1 && peer.metadata == "{\"isHandRaised\":true}")
          peerTracks[index].isRaiseHand = true;
        else if (index != -1 && peer.metadata == "{\"isHandRaised\":false}") {
          peerTracks[index].isRaiseHand = false;
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
          }
          localPeer = peer;
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
    print("onTrackUpdateFlutter $update ${peer.name} update");

    switch (update) {
      case HMSTrackUpdate.trackAdded:
        if (track.source == "REGULAR") {
          trackStatus[peer.peerId] = track.isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
          print("${trackStatus[peer.peerId]} trackStatusOfPeer");
        } else {
          screenSharePeerId = peer.peerId;
          screenShareTrack = track;
        }
        print("peerOperationWithTrack ${track.isMute}");
        break;
      case HMSTrackUpdate.trackRemoved:
        print("peerOperationWithTrack ${peerTracks.toString()}");
        if (track.source != "REGULAR") {
          screenSharePeerId = "";
          screenShareTrack = null;
        } else {
          peerTracks.removeWhere((element) => element.peerId == peer.peerId);
          print("peerOperationWithTrack ${peerTracks.toString()}");
        }
        break;
      case HMSTrackUpdate.trackMuted:
        trackStatus[peer.peerId] = HMSTrackUpdate.trackMuted;
        print("peerOperationWithTrackMute ${track.isMute}");
        break;
      case HMSTrackUpdate.trackUnMuted:
        trackStatus[peer.peerId] = HMSTrackUpdate.trackUnMuted;
        print("peerOperationWithTrackUnmute ${track.isMute}");
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
    // hmsException =
    //     await HmsSdkManager.hmsSdkInteractor?.startRtmpOrRecording(hmsRecordingConfig);
    // // ignore: unrelated_type_equality_checks
    // if (hmsException == null || hmsException?.code == 400) {
    //   isRecordingStarted = true;
    // }

    // print("${hmsException?.toString()} HMSEXCEPTION  $isRecordingStarted");
  }

  void stopRtmpAndRecording() async {
    _hmssdkInteractor.stopRtmpAndRecording(this);

    // hmsException = (await HmsSdkManager.hmsSdkInteractor?.stopRtmpAndRecording());
    // if (hmsException == null) {
    //   isRecordingStarted = false;
    // }
    // print("${hmsException?.toString()} HMSEXCEPTION $isRecordingStarted");
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
    _hmssdkInteractor.changeMetadata(
        metadata: "{\"isHandRaised\":$isRaisedHand}",
        hmsActionResultListener: this);
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

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    print(
        "onSuccess Action Result Listener method: $methodType || arguments $arguments");
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
        print("stopped rtmp");
        //isRecordingStarted = false;
        break;
      case HMSActionResultListenerMethod.unknown:
        print("Unknown Method Called");
        break;
      case HMSActionResultListenerMethod.changeName:
        // TODO: Handle this case.
        this.event = "Name Changed to ${localPeer!.name}";
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        print("Message is ${arguments!['message']}");
        // addMessage(arguments['message']);
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        print("Message is ${arguments!['message']}");
        // addMessage(arguments['message']);
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        print("Message is ${arguments!['message']}");
        // addMessage(arguments['message']);
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
        print("HMSException ${hmsException.message}");
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
        print("HMSException ${hmsException.message}");
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        // TODO: Handle this case.
        print("HMSException ${hmsException.message}");
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
