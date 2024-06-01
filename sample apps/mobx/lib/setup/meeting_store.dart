//Package imports

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:mobx_example/setup/hms_sdk_interactor.dart';
import 'package:mobx_example/setup/peer_track_node.dart';

part 'meeting_store.g.dart';

class MeetingStore = MeetingStoreBase with _$MeetingStore;

abstract class MeetingStoreBase extends ChangeNotifier
    with Store
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDKInteractor _hmsSDKInteractor;

  MeetingStoreBase({required HMSSDKInteractor hmssdkInteractor}) {
    _hmsSDKInteractor = hmssdkInteractor;
  }

  @observable
  HMSException? hmsException;

  @observable
  bool isVideoOn = true;
  @observable
  bool isMicOn = true;
  @observable
  bool isScreenShareOn = false;
  @observable
  bool isRoomEnded = false;

  @observable
  ObservableMap<String, HMSTrackUpdate> trackStatus = ObservableMap.of({});

  @observable
  ObservableList<PeerTrackNode> peerTracks = ObservableList.of([]);

  void leave() async {
    _hmsSDKInteractor.leave(hmsActionResultListener: this);
    peerTracks.clear();
    isRoomEnded = true;
  }

  void toggleScreenShare() async {
    if (await _hmsSDKInteractor.isScreenShareActive()) {
      _hmsSDKInteractor.stopScreenShare(hmsActionResultListener: this);
    } else {
      _hmsSDKInteractor.startScreenShare(hmsActionResultListener: this);
    }
  }

  @action
  void addUpdateListener() {
    _hmsSDKInteractor.addUpdateListener(this);
  }

  @action
  void removeUpdateListener() {
    _hmsSDKInteractor.removeUpdateListener(this);
  }

  @action
  Future<bool> join(String user, String roomUrl) async {
    var token =
        await _hmsSDKInteractor.getAuthTokenFromRoomCode(roomCode: roomUrl);
    if (token == null) return false;
    HMSConfig config = HMSConfig(
      authToken: token,
      userName: user,
    );

    await _hmsSDKInteractor.join(config: config);
    return true;
  }

  @action
  Future<void> toggleMicMuteStatus() async {
    await _hmsSDKInteractor.toggleMicMuteStatus();
    isMicOn = !isMicOn;
  }

  @action
  Future<void> toggleCameraMuteStatus() async {
    await _hmsSDKInteractor.toggleCameraMuteState();
    int index = peerTracks.indexWhere((element) => element.peer.isLocal);
    if (index != -1) {
      if (isVideoOn) {
        trackStatus[peerTracks[index].uid] = HMSTrackUpdate.trackMuted;
      } else {
        trackStatus[peerTracks[index].uid] = HMSTrackUpdate.trackUnMuted;
      }
      isVideoOn = !isVideoOn;
    }
  }

  @action
  Future<void> isScreenShareActive() async {
    isScreenShareOn = await _hmsSDKInteractor.isScreenShareActive();
  }

  @override
  void onJoin({required HMSRoom room}) async {
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        int index = peerTracks
            .indexWhere((element) => element.peer.peerId == each.peerId);
        if (index == -1) {
          peerTracks.add(PeerTrackNode(
              uid: each.peerId +
                  ((each.videoTrack?.source == "REGULAR")
                      ? "mainVideo"
                      : (each.videoTrack?.trackId ?? "empty")),
              peer: each,
              name: each.name));
        }
        if (each.videoTrack != null) {
          if (each.videoTrack!.kind == HMSTrackKind.kHMSTrackKindVideo) {
            int index = peerTracks
                .indexWhere((element) => element.peer.peerId == each.peerId);
            peerTracks[index].track = each.videoTrack!;
            if (each.videoTrack!.isMute) {
              isVideoOn = false;
            }
            trackStatus[peerTracks[0].uid] = (each.videoTrack?.isMute ?? false)
                ? HMSTrackUpdate.trackMuted
                : HMSTrackUpdate.trackUnMuted;
          }
        }
        break;
      }
    }
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs for room updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // Checkout the docs for peer updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (peer.isLocal) {
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
        isMicOn = !track.isMute;
      } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo &&
          track.source == "REGULAR") {
        isVideoOn == !track.isMute;
      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      bool isRegular = (track.source == "REGULAR");
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        peerTracks.removeWhere((node) =>
            node.uid ==
            (peer.peerId + (isRegular ? "mainVideo" : track.trackId)));
      } else {
        int index = peerTracks.indexWhere((node) =>
            node.uid ==
            (peer.peerId + (isRegular ? "mainVideo" : track.trackId)));
        if (index != -1) {
          trackStatus[peerTracks[index].uid] = track.isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
          peerTracks[index].track = track as HMSVideoTrack?;
        } else {
          peerTracks.add(PeerTrackNode(
              uid: peer.peerId + (isRegular ? "mainVideo" : track.trackId),
              peer: peer,
              name: peer.name,
              track: track as HMSVideoTrack?));
        }
      }
    }
  }

  @override
  void onHMSError({required HMSException error}) {
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
    hmsException = hmsException;
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
    isRoomEnded = true;
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // Checkout the docs for sessions store here: https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // Checkout the docs for onPeerListUpdate here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        isRoomEnded = true;
        removeUpdateListener();
        _hmsSDKInteractor.destroy();
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        log("startScreenShare success");
        isScreenShareOn = true;
        isScreenShareActive();
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        log("stopScreenShare success");
        isScreenShareOn = false;
        isScreenShareActive();
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
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        log("Failed to Leave");
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        log("startScreenShare exception");
        isScreenShareActive();
        break;

      case HMSActionResultListenerMethod.stopScreenShare:
        log("stopScreenShare exception");
        isScreenShareActive();
        break;
      default:
        break;
    }
  }
}
