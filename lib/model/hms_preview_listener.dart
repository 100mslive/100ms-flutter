import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';

abstract class HMSPreviewListener {
  void onError({required HMSError error});

  void onPreview({required HMSPeer peer, required HMSTrack localTrack});
}
