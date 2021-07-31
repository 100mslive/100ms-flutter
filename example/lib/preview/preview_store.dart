import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';
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
  HMSTrack? localTrack;

  @action
  void onPreview(HMSRoom room, List<HMSTrack> localtracks) {
    localtracks.forEach((each) {
      if (each.kind == HMSTrackKind.kHMSTrackKindVideo) {
        localTrack = each;
      }
    });
  }

  void startListen() {
    previewController.startPreview();
  }

  void startPreview() {
    previewController.startPreview();
  }
}
