import 'package:hmssdk_flutter/hmssdk_flutter.dart';

abstract class HMSPreviewListener {
  void onError({required HMSError error});

  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});
}
