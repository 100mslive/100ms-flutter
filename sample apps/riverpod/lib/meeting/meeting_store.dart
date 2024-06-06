//Package imports

import 'package:example_riverpod/hms_sdk_interactor.dart';
import 'package:example_riverpod/meeting/peer_track_node.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class MeetingStore extends ChangeNotifier
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDKInteractor _hmsSDKInteractor;

  MeetingStore({required HMSSDKInteractor hmsSDKInteractor}) {
    _hmsSDKInteractor = hmsSDKInteractor;
  }

  // HMSLogListener

  HMSException? hmsException;

  bool isVideoOn = true;

  bool isMicOn = true;

  List<HMSPeer> peers = [];

  HMSPeer? localPeer;

  List<HMSTrack> audioTracks = [];

  List<PeerTrackNode> peerTracks = [];

  HMSRoom? hmsRoom;

  bool isScreenShareOn = false;

// Function calls*******************************************

  Future<bool> join(String user, String roomUrl) async {
    var token =
        await _hmsSDKInteractor.getAuthTokenFromRoomCode(roomCode: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(authToken: token, userName: user);

    _hmsSDKInteractor.addUpdateListener(this);
    _hmsSDKInteractor.join(config: config);
    return true;
  }

  void leave() async {
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
  }

  Future<void> toggleMicMuteState() async {
    _hmsSDKInteractor.toggleMicMuteState();
    isMicOn = !isMicOn;
    notifyListeners();
  }

  Future<void> toggleCameraMuteState() async {
    _hmsSDKInteractor.toggleCameraMuteState();
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    await _hmsSDKInteractor.switchCamera(hmsActionResultListener: this);
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

  void startScreenShare() {
    _hmsSDKInteractor.startScreenShare(hmsActionResultListener: this);
  }

  void stopScreenShare() {
    _hmsSDKInteractor.stopScreenShare(hmsActionResultListener: this);
  }

  void removePeer(HMSPeer peer) {
    peers.remove(peer);
  }

  void addPeer(HMSPeer peer) {
    if (!peers.contains(peer)) peers.add(peer);
  }

  void onRoleUpdated(int index, HMSPeer peer) {
    peers[index] = peer;
  }

  void updatePeerAt(peer) {
    int index = peers.indexOf(peer);
    peers.removeAt(index);
    peers.insert(index, peer);
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

  void changeTrackState(HMSTrack track, bool mute) {
    return _hmsSDKInteractor.changeTrackState(track, mute, this);
  }

  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (peer.role.name.contains("hls-") == false) {
          int index = peerTracks.indexWhere(
              (element) => element.uid == peer.peerId + "mainVideo");
          if (index == -1) {
            peerTracks
                .add(PeerTrackNode(peer: peer, uid: peer.peerId + "mainVideo"));
          }
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

        int index = peerTracks
            .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
        if (index == -1) {
          peerTracks
              .add(PeerTrackNode(peer: peer, uid: peer.peerId + "mainVideo"));
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
        break;

      case HMSPeerUpdate.defaultUpdate:
        break;

      default:
    }
  }

// Listeners implementation*******************************************

  @override
  void onJoin({required HMSRoom room}) async {
    hmsRoom = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index = peerTracks
            .indexWhere((element) => element.uid == each.peerId + "mainVideo");
        if (index == -1) {
          peerTracks
              .add(PeerTrackNode(peer: each, uid: each.peerId + "mainVideo"));
        }
        localPeer = each;
        addPeer(localPeer!);
        index = peerTracks
            .indexWhere((element) => element.uid == each.peerId + "mainVideo");
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
    notifyListeners();
  }

  @override
  void onPeerUpdate(
      {required HMSPeer peer, required HMSPeerUpdate update}) async {
    // Checkout the docs for peer updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
    peerOperation(peer, update);
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
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

    if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      int index = peerTracks
          .indexWhere((element) => element.uid == peer.peerId + "mainVideo");
      if (index != -1) {
        PeerTrackNode peerTrackNode = peerTracks[index];
        peerTrackNode.audioTrack = track as HMSAudioTrack;
        peerTrackNode.notify();
      } else {
        peerTracks.add(PeerTrackNode(
            peer: peer,
            uid: peer.peerId + "mainVideo",
            audioTrack: track as HMSAudioTrack));
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
      } else {
        peerTracks.add(PeerTrackNode(
            peer: peer,
            uid: peer.peerId + "mainVideo",
            track: track as HMSVideoTrack));
      }
    } else {
      if (trackUpdate == HMSTrackUpdate.trackAdded) {
        peerTracks.add(PeerTrackNode(
            peer: peer,
            uid: peer.peerId + track.trackId,
            track: track as HMSVideoTrack));
      } else {
        int index = peerTracks.indexWhere(
            (element) => element.uid == peer.peerId + track.trackId);
        if (index != -1) {
          peerTracks.removeAt(index);
        }
      }
      notifyListeners();
    }
  }

  @override
  void onHMSError({required HMSException error}) {
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
    hmsException = hmsException;
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs for room updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onMessage({required HMSMessage message}) {
    // Checkout the docs for chat messaging here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/chat
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // Checkout the docs for handling the role change request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/change-role#accept-role-change-request
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // Checkout the docs for handling the updates regarding who is currently speaking here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/show-audio-level
  }

  @override
  void onReconnecting() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onReconnected() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  int trackChange = -1;

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // Checkout the docs for handling the unmute request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/track/remote-mute-unmute
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // Checkout the docs for handling the peer removal here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/remove-peer
    peerTracks.clear();
    notifyListeners();
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        peerTracks.clear();
        _hmsSDKInteractor.removeUpdateListener(this);
        break;
      case HMSActionResultListenerMethod.switchCamera:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.endRoom:
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        isScreenShareOn = true;
        notifyListeners();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        isScreenShareOn = false;
        notifyListeners();
        break;
      default:
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
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {}

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // TODO: implement onSessionStoreAvailable
  }
}
