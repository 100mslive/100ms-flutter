import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';

abstract class HMSTrack {
  final String trackID;
  final HMSTrackKind kind;
  final HMSTrackSource source;

  HMSTrack(this.trackID, this.kind, this.source, this.trackDescription);

  final String trackDescription;

  Future<bool> isMute();
}
