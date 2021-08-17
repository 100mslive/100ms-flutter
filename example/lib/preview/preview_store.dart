import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';
import 'package:mobx/mobx.dart';

part 'preview_store.g.dart';

class PreviewStore = PreviewStoreBase with _$PreviewStore;

abstract class PreviewStoreBase with Store implements HMSPreviewListener {
  late PreviewController previewController;

  @observable
  List<HMSTrack> localTracks = [];
  @observable
  HMSError? error;

  @observable
  bool videoOn = true;
  @observable
  bool audioOn = true;

  @override
  void onError({required HMSError error}) {
    print("previewError ${error.toString()}");
    updateError(error);
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    List<HMSTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        videoTracks.add(track);
      }
    }
    this.localTracks = ObservableList.of(videoTracks);
  }

  void startListen() {
    previewController.startListen(this);
  }

  void startPreview() {
    previewController.startPreview();
  }

  void startCapturing() {
    previewController.startCapturing();
    videoOn = true;
  }

  void stopCapturing() {
    previewController.stopCapturing();
    videoOn = false;
  }

  void switchAudio() {
    previewController.switchAudio(isOn: audioOn);
    audioOn = !audioOn;
  }

  @action
  void updateError(HMSError error) {
    this.error = error;
  }
}
