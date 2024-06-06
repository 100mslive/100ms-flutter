import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewController extends GetxController
    implements HMSPreviewListener, HMSActionResultListener {
  RxBool isLocalVideoOn = true.obs;
  RxBool isLocalAudioOn = true.obs;

  List<HMSVideoTrack> localTracks = <HMSVideoTrack>[].obs;

  String url;
  String name;

  PreviewController(this.url, this.name);

//To know more about HMSSDK setup and initialization checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/install-the-sdk/hmssdk
  HMSSDK hmsSdk = Get.put(HMSSDK());

  @override
  void onInit() async {
    await hmsSdk.build();
    hmsSdk.addPreviewListener(listener: this);
    var token = await hmsSdk.getAuthTokenByRoomCode(roomCode: url);
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

  void toggleMicMuteState() async {
    await hmsSdk.toggleMicMuteState();
    isLocalAudioOn.toggle();
  }

  void toggleCameraMuteState() async {
    await hmsSdk.toggleCameraMuteState();
    isLocalVideoOn.toggle();
  }

  void removePreviewListener() {
    hmsSdk.removePreviewListener(listener: this);
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
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
    Get.snackbar("Error", error.message ?? "");
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // Checkout the docs about handling peer updates in preview here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/preview
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs about handling room updates in preview here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/preview
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates in preview here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/preview
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }
}
