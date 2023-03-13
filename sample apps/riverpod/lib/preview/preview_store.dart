//Package imports
import 'package:example_riverpod/hms_sdk_interactor.dart';
import 'package:example_riverpod/service/room_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewStore extends ChangeNotifier implements HMSPreviewListener {
  late HMSSDKInteractor hmsSDKInteractor;

  PreviewStore() {
    hmsSDKInteractor = HMSSDKInteractor();
  }

  List<HMSVideoTrack> localTracks = [];

  HMSPeer? peer;

  HMSException? error;

  HMSRoom? room;

  bool isVideoOn = true;

  bool isAudioOn = true;

  @override
  void onHMSError({required HMSException error}) {
    this.error = error;
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    this.room = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        peer = each;
        break;
      }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
      }
    }
    this.localTracks = videoTracks;
    notifyListeners();
  }

  Future<bool> startPreview(
      {required String user, required String roomId}) async {
    String? token = await RoomService().getToken(user: user, room: roomId);

    if (token == null) return false;
    HMSConfig config = HMSConfig(authToken: token, userName: user);
    hmsSDKInteractor.addPreviewListener(this);
    hmsSDKInteractor.preview(config: config);
    return true;
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  void removePreviewListener() {
    hmsSDKInteractor.removePreviewListener(this);
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  void toggleCameraMuteState() {
    hmsSDKInteractor.toggleCameraMuteState();
    isVideoOn = !isVideoOn;
    notifyListeners();
  }

  void toggleMicMuteState() {
    hmsSDKInteractor.toggleMicMuteState();
    isAudioOn = !isAudioOn;
    notifyListeners();
  }

  void leave() {
    hmsSDKInteractor.leave();
  }
}
