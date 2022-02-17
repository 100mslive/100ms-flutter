//Package imports
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';

class PreviewStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {
  late PreviewController previewController;

  List<HMSVideoTrack> localTracks = [];

  HMSPeer? peer;

  HMSException? error;

  bool isHLSLink = false;
  HMSRoom? room;

  bool videoOn = true;

  bool audioOn = true;

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
    this.localTracks = videoTracks;
     notifyListeners();
  }

  void addPreviewListener() {
    previewController.addPreviewListener(this);
    addLogsListener();
  }

  void removePreviewListener() {
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
