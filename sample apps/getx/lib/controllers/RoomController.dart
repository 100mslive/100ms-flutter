import 'package:demo_with_getx_and_100ms/models/PeerTrackNode.dart';
import 'package:demo_with_getx_and_100ms/views/HomePage.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class RoomController extends GetxController
    implements HMSUpdateListener, HMSActionResultListener {
  RxList<Rx<PeerTrackNode>> peerTrackList = <Rx<PeerTrackNode>>[].obs;
  RxBool isLocalVideoOn = true.obs;
  RxBool isLocalAudioOn = true.obs;
  RxBool isScreenShareActive = false.obs;
  String url;
  String name;

  RoomController(this.url, this.name);

  HMSSDK hmsSdk = Get.find();

  @override
  void onInit() async {
    hmsSdk.addUpdateListener(listener: this);
    var token = await hmsSdk.getAuthTokenByRoomCode(roomCode: url);

    if (token == null) return;

    HMSConfig config = HMSConfig(
      authToken: token,
      userName: name,
    );

    hmsSdk.join(config: config);

    super.onInit();
  }

  @override
  void onJoin({required HMSRoom room}) {
    peerTrackList.clear();

    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        isLocalAudioOn.value = !(peer.audioTrack?.isMute ?? true);
        isLocalVideoOn.value = !(peer.videoTrack?.isMute ?? true);
        peerTrackList.add(PeerTrackNode(
                peer.peerId +
                    ((peer.videoTrack?.source == "REGULAR")
                        ? "mainVideo"
                        : (peer.videoTrack?.trackId ?? "")),
                peer.videoTrack,
                peer.videoTrack?.isMute ?? false,
                peer)
            .obs);
      }
    });
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (peer.isLocal) {
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
        isLocalAudioOn.value = !track.isMute;
        isLocalAudioOn.refresh();
      } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo &&
          track.source == "REGULAR") {
        isLocalVideoOn.value == !track.isMute;
        isLocalVideoOn.refresh();
      }
    }

    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        peerTrackList.removeWhere((element) =>
            peer.peerId +
                ((track.source == "REGULAR") ? "mainVideo" : track.trackId) ==
            element.value.uid);
      } else {
        bool isRegular = (track.source == "REGULAR");
        int index = peerTrackList.indexWhere((element) =>
            element.value.peer.peerId +
                (isRegular
                    ? "mainVideo"
                    : (element.value.hmsVideoTrack?.trackId ?? "empty")) ==
            peer.peerId + (isRegular ? "mainVideo" : track.trackId));
        if (index != -1) {
          peerTrackList[index](PeerTrackNode(
              peer.peerId + (isRegular ? "mainVideo" : track.trackId),
              track as HMSVideoTrack,
              track.isMute,
              peer));
        } else {
          peerTrackList.add(PeerTrackNode(
                  peer.peerId + (isRegular ? "mainVideo" : track.trackId),
                  track as HMSVideoTrack,
                  track.isMute,
                  peer)
              .obs);
        }
      }
    }
  }

  @override
  void onHMSError({required HMSException error}) {
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
    Get.snackbar("Error", error.message ?? "");
  }

  void leaveMeeting() async {
    hmsSdk.leave(hmsActionResultListener: this);
  }

  void toggleMicMuteState() async {
    await hmsSdk.toggleMicMuteState();
    isLocalAudioOn.toggle();
  }

  void toggleCameraMuteState() async {
    await hmsSdk.toggleCameraMuteState();
    isLocalVideoOn.toggle();
  }

  void toggleScreenShare() {
    if (!isScreenShareActive.value) {
      hmsSdk.startScreenShare(hmsActionResultListener: this);
    } else {
      hmsSdk.stopScreenShare(hmsActionResultListener: this);
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        Get.snackbar("Leave Error", hmsException.message ?? "");
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        Get.snackbar("startScreenShare Error", hmsException.message ?? "");

        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        Get.snackbar("stopScreenShare Error", hmsException.message ?? "");

        break;
      case HMSActionResultListenerMethod.changeTrackState:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        // TODO: Handle this case.
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
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.switchCamera:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.quickStartPoll:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addSingleChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addMultiChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.unknown:
        // TODO: Handle this case.
        break;
      case null:
        // TODO: Handle this case.
        break;
    }
    Get.snackbar("Error", hmsException.message ?? "");
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        hmsSdk.removeUpdateListener(listener: this);
        hmsSdk.destroy();
        Get.back();
        Get.off(() => const HomePage());
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        isScreenShareActive.toggle();
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        isScreenShareActive.toggle();
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.endRoom:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.removePeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        // TODO: Handle this case.
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
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.switchCamera:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.quickStartPoll:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addSingleChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.addMultiChoicePollResponse:
        // TODO: Handle this case.
        break;
      case HMSActionResultListenerMethod.unknown:
        // TODO: Handle this case.
        break;
      case null:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onMessage({required HMSMessage message}) {
    // Checkout the docs for chat messaging here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/chat
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // Checkout the docs for peer updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onReconnected() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onReconnecting() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // Checkout the docs for handling the peer removal here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/remove-peer
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // Checkout the docs for handling the role change request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/change-role#accept-role-change-request
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs for room updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // Checkout the docs for handling the unmute request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/track/remote-mute-unmute
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // Checkout the docs for handling the updates regarding who is currently speaking here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/show-audio-level
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // TODO: implement onSessionStoreAvailable
  }
}
