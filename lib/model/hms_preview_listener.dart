import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';

abstract class HMSPreviewListener {
  void onError(HMSError error);

  void onPreview(HMSRoom room, List<HMSTrack> localTracks);
}
