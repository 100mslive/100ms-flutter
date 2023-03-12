import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import '../services/RoomService.dart';

class PreviewController extends GetxController
    implements HMSPreviewListener, HMSActionResultListener {
  RxBool isLocalVideoOn = Get.put(false.obs, tag: "isLocalVideoOn");
  RxBool isLocalAudioOn = Get.put(false.obs, tag: "isLocalAudioOn");

  List<HMSVideoTrack> localTracks = <HMSVideoTrack>[].obs;

  String url;
  String name;

  PreviewController(this.url, this.name);

  HMSSDK hmsSdk = Get.put(HMSSDK());

  @override
  void onInit() async {
    await hmsSdk.build();
    hmsSdk.addPreviewListener(listener: this);
    String? token = await RoomService().getToken(user: name, room: url);
    if (token == null) return;

    HMSConfig config = Get.put(
        HMSConfig(
          authToken: token,
          userName: name,
        ),
        tag: "");

    hmsSdk.preview(config: config);

    super.onInit();
  }

  void leaveMeeting() async {
    hmsSdk.leave(hmsActionResultListener: this);
  }

  void toggleAudio() async {
    var result = await hmsSdk.toggleMicMuteState();
    if (result == null) {
      isLocalAudioOn.toggle();
    }
  }

  void toggleVideo() async {
    var result = await hmsSdk.toggleCameraMuteState();

    if (result == null) {
      isLocalVideoOn.toggle();

      if (kDebugMode) {
        print("RESULT VIDEO ${isLocalVideoOn.value}");
      }
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    Get.snackbar("Error", hmsException.message ?? "");
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod? methodType,
      Map<String, dynamic>? arguments}) {
    Get.back();
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        isLocalVideoOn.value = !track.isMute;
        isLocalVideoOn.refresh();
        videoTracks.add(track as HMSVideoTrack);
      } else {
        isLocalAudioOn.value = !track.isMute;
        isLocalAudioOn.refresh();
      }
    }
    this.localTracks.clear();
    this.localTracks.addAll(videoTracks);
  }

  @override
  void onHMSError({required HMSException error}) {
    Get.snackbar("Error", error.message ?? "");
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }
}
