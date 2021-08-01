import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';
import 'package:mobx/mobx.dart';

part 'preview_store.g.dart';

class PreviewStore = PreviewStoreBase with _$PreviewStore;

abstract class PreviewStoreBase with Store implements HMSPreviewListener {
  late PreviewController previewController;

  @observable
  HMSTrack? localTrack;

  @override
  void onError({required HMSError error}) {
    print(error);
  }

  @override
  void onPreview({required HMSPeer peer, required HMSTrack localTrack}) {
    this.localTrack = localTrack;
  }

  void startListen() {
    previewController.startListen(this);
  }

  void startPreview() {
    previewController.startPreview();
  }
}
