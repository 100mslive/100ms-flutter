import 'dart:convert';
import 'dart:io';
// import 'dart:js';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_log_level.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/logs/static_logger.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_controller.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:mobx/mobx.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase
    extends ChangeNotifier with Store
    implements HMSUpdateListener, HMSLogListener {
  @observable
  bool isSpeakerOn = true;
  @observable
  String screenSharePeerId = '';
  @observable
  HMSException? error;

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
  HMSTrackChangeRequest? hmsTrackChangeRequest;
  @observable
  List<HMSRole> roles = [];

  late MeetingController meetingController;

  @observable
  ObservableList<HMSPeer> peers = ObservableList.of([]);

  @observable
  HMSPeer? localPeer;

  @observable
  HMSTrack? screenTrack;

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
    meetingController.addMeetingListener(this);
    //startHMSLogger(HMSLogLevel.DEBUG, HMSLogLevel.DEBUG);
    //addLogsListener();
  }

  @action
  void removeListenerMeeting() {
    meetingController.removeMeetingListener(this);
    removeLogsListener();
  }

  @action
  void toggleSpeaker() {
    print("toggleSpeaker");
    if (isSpeakerOn) {
      muteAll();
    } else {
      unMuteAll();
    }
    isSpeakerOn = !isSpeakerOn;
  }

  @action
  Future<void> toggleVideo() async {
    print("toggleVideo $isVideoOn");
    await meetingController.switchVideo(isOn: isVideoOn);

    isVideoOn = !isVideoOn;
  }

  @action
  Future<void> toggleCamera() async {
    await meetingController.switchCamera();
  }

  @action
  Future<void> toggleAudio() async {
    await meetingController.switchAudio(isOn: isMicOn);
    isMicOn = !isMicOn;
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
  Future<bool> joinMeeting() async {
    bool ans = await meetingController.joinMeeting();
    if (!ans) return false;
    isMeetingStarted = true;
    // startHMSLogger(HMSLogLevel.VERBOSE, HMSLogLevel.VERBOSE);
    // addLogsListener();
    return true;
  }

  @action
  Future<void> sendMessage(String message) async {
    await meetingController.sendMessage(message);
  }

  Future<void> sendDirectMessage(String message, String peerId) async {
    await meetingController.sendDirectMessage(message, peerId);
  }

  Future<void> sendGroupMessage(String message, String roleName) async {
    await meetingController.sendGroupMessage(message, roleName);
  }

  @action
  void updateError(HMSException error) {
    this.error = error;
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
    if (Platform.isAndroid) {
      print("members ${room.peers!.length}");
      for (HMSPeer each in room.peers!) {
        if (each.isLocal) {
          peerTracks
              .add(new PeerTracKNode(peerId: each.peerId, name: each.name));
          localPeer = each;
          addPeer(localPeer!);
          print('on join ${localPeer!.peerId}');
          break;
        }
      }
    } else {
      for (HMSPeer each in room.peers!) {
        addPeer(each);
        if (each.isLocal) {
          localPeer = each;
          print('on join ${localPeer!.name}  ${localPeer!.peerId}');
          if (each.videoTrack != null) {
            trackStatus[each.videoTrack!.trackId] = HMSTrackUpdate.trackMuted;
            tracks.insert(0, each.videoTrack!);
          }
        } else {
          if (each.videoTrack != null) {
            trackStatus[each.videoTrack!.trackId] = HMSTrackUpdate.trackMuted;
            tracks.insert(0, each.videoTrack!);
          }
        }
      }
    }
    roles = await getRoles();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    print('on room update');
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    peerOperation(peer, update);
    print("${peerTracks.toString()} onPeerUpdateListLength");
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

    print("onTrackUpdate ${trackStatus[track.trackId]}");

    if (track.source == "SCREEN") {
      isScreenShareOn = true;
    }
    if (peer.isLocal) {
      localPeer = peer;
      if (track.isMute && track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        this.isVideoOn = false;
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
      print(
          "onTrackUpdateFlutter ${peerTracks[index].track?.isMute} ${peer.name} before");
      peerTracks[index].track = track;
      print(
          "onTrackUpdateFlutter ${peerTracks[index].track?.isMute} ${peer.name} after");
    }

    peerOperationWithTrack(peer, trackUpdate, track);
  }

  @override
  void onError({required HMSException error}) {
    updateError(error);
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
  ObservableMap<String,String> observableMap = ObservableMap.of({});

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    if (updateSpeakers.length == 0){
      observableMap["highestAudio"]="null";
      return;
    }
    HMSSpeaker highestAudioSpeaker = updateSpeakers[0];
    print("onUpdateSpeakerFlutter ${highestAudioSpeaker.peer.name}");
    observableMap["highestAudio"] = highestAudioSpeaker.peer.peerId;
    notifyListeners();
  }

  @override
  void onReconnecting() {
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
    int isVideoTrack =
        hmsTrackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindVideo
            ? 1
            : 0;
    trackChange = isVideoTrack;
    print("flutteronChangeTrack $trackChange");
    addTrackChangeRequestInstance(hmsTrackChangeRequest);
  }

  void changeTracks() {
    print("flutteronChangeTracks $trackChange");
    if (trackChange == 1) {
      toggleVideo();
    } else if (trackChange == 0) {
      toggleAudio();
    }
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    print("onRemovedFromRoomFlutter ${hmsPeerRemovedFromPeer}");
    leaveMeeting();
  }

  void changeRole(
      {required String peerId,
      required String roleName,
      bool forceChange = false}) {
    meetingController.changeRole(
        roleName: roleName, peerId: peerId, forceChange: forceChange);
  }

  Future<List<HMSRole>> getRoles() async {
    return meetingController.getRoles();
  }

  void changeTrackRequest(String peerId, bool mute, bool isVideoTrack) {
    return meetingController.changeTrackRequest(peerId, mute, isVideoTrack);
  }

  @action
  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        print('peer joined');
        //TODO-> containsPeer or not

        peerTracks.add(new PeerTracKNode(peerId: peer.peerId, name: peer.name));
        addPeer(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        print('peer left');
        peerTracks.removeWhere((element) => element.peerId == peer.peerId);
        removePeer(peer);
        break;
      case HMSPeerUpdate.peerKnocked:
        // removePeer(peer);
        break;
      case HMSPeerUpdate.audioToggled:
        print('Peer audio toggled');
        break;
      case HMSPeerUpdate.videoToggled:
        print('Peer video toggled');
        break;
      case HMSPeerUpdate.roleUpdated:
        print('${peers.indexOf(peer)}');
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.metadataChanged:
        updatePeerAt(peer);
        break;
      case HMSPeerUpdate.nameChanged:
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
        if (track.source == "REGULAR")
          trackStatus[peer.peerId] = track.isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
        else {
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

  Future<bool> endRoom(bool lock) async {
    bool room = await meetingController.endRoom(lock);
    if (room == true) isRoomEnded = true;
    return room;
  }

  void leaveMeeting() async {
    meetingController.leaveMeeting();
    isRoomEnded = true;
    removeListenerMeeting();
  }

  void removePeerFromRoom(String peerId) {
    meetingController.removePeer(peerId);
  }

  void muteAll() {
    meetingController.muteAll();
  }

  void unMuteAll() {
    meetingController.unMuteAll();
  }

  @override
  void onLogMessage({required dynamic HMSLog}) {
    StaticLogger.logger?.v(HMSLog.toMap());
    FirebaseCrashlytics.instance.log(HMSLog.toString());
  }

  void startHMSLogger(HMSLogLevel webRtclogLevel, HMSLogLevel logLevel) {
    meetingController.startHMSLogger(webRtclogLevel, logLevel);
  }

  void addLogsListener() {
    meetingController.addLogsListener(this);
  }

  void removeLogsListener() {
    meetingController.removeLogsListener(this);
  }

  void removeHMSLogger() {
    meetingController.removeHMSLogger();
  }

  Future<HMSPeer?> getLocalPeer() async {
    return await meetingController.getLocalPeer();
  }

  void startRtmpOrRecording(
      String meetingUrl, bool toRecord, List<String>? rtmpUrls) async {
    HMSRecordingConfig hmsRecordingConfig = new HMSRecordingConfig(
        meetingUrl: meetingUrl, toRecord: toRecord, rtmpUrls: rtmpUrls);
    hmsException =
        await meetingController.startRtmpOrRecording(hmsRecordingConfig);
    if (hmsException == null || hmsException?.code == 400) {
      isRecordingStarted = true;
    }

    print("${hmsException?.toString()} HMSEXCEPTION  ${isRecordingStarted}");
  }

  void stopRtmpAndRecording() async {
    hmsException = (await meetingController.stopRtmpAndRecording());
    if (hmsException == null) {
      isRecordingStarted = false;
    }
    print("${hmsException?.toString()} HMSEXCEPTION ${isRecordingStarted}");
  }

  Future<HMSRoom?> getRoom() async {
    HMSRoom? room = await meetingController.getRoom();
    return room;
  }

  Future<void> raiseHand() async{
    await meetingController.raiseHand();
  }
}
