import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';

abstract class HMSTrack {
  abstract final String trackID;
  abstract final HMSTrackKind kind;
  abstract final HMSTrackSource source;
  abstract final String trackDescription;

  bool isMute();
}
