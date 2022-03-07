//Package imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';
import 'package:mobx/mobx.dart';

part 'preview_store.g.dart';

class PreviewStore = PreviewStoreBase with _$PreviewStore;

abstract class PreviewStoreBase
    with Store
    implements HMSPreviewListener, HMSLogListener {
  late PreviewController previewController;

  @observable
  List<HMSVideoTrack> localTracks = [];
  @observable
  HMSPeer? peer;
  @observable
  HMSException? error;
  @observable
  bool isHLSLink = false;
  HMSRoom? room;
  @observable
  bool videoOn = true;
  @observable
  bool audioOn = true;
  @observable
  bool isRecordingStarted = false;
  @observable
  ObservableList<HMSPeer> peers = ObservableList.of([]);

  @override
  void onError({required HMSException error}) {
    updateError(error);
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    this.room = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        peer = each;
        if (each.role.name.indexOf("hls-") == 0) {
          isHLSLink = true;
        }
        break;
      }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track as HMSVideoTrack);
      }
    }
    this.localTracks = ObservableList.of(videoTracks);
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        peers.add(peer);
        break;
      case HMSPeerUpdate.peerLeft:
        peers.remove(peer);
        break;
      case HMSPeerUpdate.roleUpdated:
        int index = peers.indexOf(peer);
        peers[index] = peer;
        break;
      default:
        break;
    }
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
        isRecordingStarted = room.hmshlsStreamingState?.running ?? false;
        break;
      default:
        break;
    }
  }

  void addPreviewListener() {
    previewController.addPreviewListener(this);
    addLogsListener();
  }

  void removeListener() {
    previewController.removeListener(this);
    removeLogsListener();
  }

  Future<bool> startPreview() async {
    return await previewController.startPreview();
  }

  void startCapturing() {
    previewController.startCapturing();
  }

  void stopCapturing() {
    previewController.stopCapturing();
  }

  void switchVideo() {
    previewController.switchVideo(isOn: videoOn);
    videoOn = !videoOn;
  }

  void switchAudio() {
    previewController.switchAudio(isOn: audioOn);
    audioOn = !audioOn;
  }

  @action
  void updateError(HMSException error) {
    this.error = error;
  }

  @override
  void onLogMessage({required dynamic hmsLogList}) {
    FirebaseCrashlytics.instance.log(hmsLogList.toString());
  }

  void addLogsListener() {
    previewController.addLogsListener(this);
  }

  void removeLogsListener() {
    previewController.removeLogsListener(this);
  }
}
