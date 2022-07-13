import 'package:demo_with_getx_and_100ms/models/PeerTrackNode.dart';
import 'package:demo_with_getx_and_100ms/views/HomePage.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import '../services/RoomService.dart';

class RoomController extends GetxController
    implements HMSUpdateListener, HMSActionResultListener {
  RxList<Rx<PeerTrackNode>> peerTrackList = <Rx<PeerTrackNode>>[].obs;
  RxBool isLocalVideoOn = false.obs;
  RxBool isLocalAudioOn = false.obs;

  String url;
  String name;

  RoomController(this.url, this.name);

  HMSSDK hmsSdk = Get.find();

  RxBool isVideoOnPreview = false.obs;
  RxBool isAudioOnPreview = false.obs;

  @override
  void onInit() async {
    hmsSdk.addUpdateListener(listener: this);

    hmsSdk.build();
    List<String?>? token = await RoomService().getToken(user: name, room: url);

    if (token == null) return;
    if (token[0] == null) return;

    HMSConfig config = HMSConfig(
      authToken: token[0]!,
      userName: name,
    );

    hmsSdk.join(config: config);

    isVideoOnPreview = Get.find(tag: "isLocalVideoOn");
    isAudioOnPreview = Get.find(tag: "isLocalAudioOn");

    super.onInit();
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
    Get.snackbar("Error", error.message);
  }

  @override
  void onJoin({required HMSRoom room}) {
    peerTrackList.clear();
    isLocalAudioOn.value = isAudioOnPreview.value;
    isLocalAudioOn.refresh();

    isLocalVideoOn.value = isVideoOnPreview.value;
    isLocalVideoOn.refresh();

    hmsSdk.switchAudio(isOn: !isLocalAudioOn.value);
    hmsSdk.switchVideo(isOn: !isLocalVideoOn.value);
  }

  @override
  void onMessage({required HMSMessage message}) {
    // TODO: implement onMessage
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {}

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        removeUserFromList(peer);
      } else if (trackUpdate == HMSTrackUpdate.trackAdded) {
        int index = peerTrackList
            .indexWhere((element) => element.value.peer.peerId == peer.peerId);
        if (index > -1) {
          peerTrackList[index](
              PeerTrackNode(track as HMSVideoTrack, track.isMute, peer));
        } else {
          peerTrackList.add(
              PeerTrackNode(track as HMSVideoTrack, track.isMute, peer).obs);
        }
      }
    }
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  void leaveMeeting() async {
    hmsSdk.leave(hmsActionResultListener: this);
  }

  void toggleAudio() async {
    var result = await hmsSdk.switchAudio(isOn: isLocalAudioOn.value);
    if (result == null) {
      isLocalAudioOn.toggle();
    }
  }

  void toggleVideo() async {
    var result = await hmsSdk.switchVideo(isOn: isLocalVideoOn.value);

    if (result == null) {
      isLocalVideoOn.toggle();
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    Get.snackbar("Error", hmsException.message);
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments}) {
    Get.back();
    Get.off(() => const HomePage());
  }

  void removeUserFromList(HMSPeer peer) {
    peerTrackList
        .removeWhere((element) => peer.peerId == element.value.peer.peerId);
  }

  @override
  void onLocalAudioStats(
      {required HMSLocalAudioStats hmsLocalAudioStats,
      required HMSLocalAudioTrack track,
      required HMSPeer peer}) {
    // TODO: implement onLocalAudioStats
  }

  @override
  void onLocalVideoStats(
      {required HMSLocalVideoStats hmsLocalVideoStats,
      required HMSLocalVideoTrack track,
      required HMSPeer peer}) {
    // TODO: implement onLocalVideoStats
  }

  @override
  void onRTCStats({required HMSRTCStatsReport hmsrtcStatsReport}) {
    // TODO: implement onRTCStats
  }

  @override
  void onRemoteAudioStats(
      {required HMSRemoteAudioStats hmsRemoteAudioStats,
      required HMSRemoteAudioTrack track,
      required HMSPeer peer}) {
    // TODO: implement onRemoteAudioStats
  }

  @override
  void onRemoteVideoStats(
      {required HMSRemoteVideoStats hmsRemoteVideoStats,
      required HMSRemoteVideoTrack track,
      required HMSPeer peer}) {
    // TODO: implement onRemoteVideoStats
  }
}
