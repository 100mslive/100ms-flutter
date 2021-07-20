import 'package:hmssdk_flutter/enum/hms_track_kind.dart';
import 'package:hmssdk_flutter/enum/hms_track_source.dart';

abstract class HMSTrack {
  final String trackId;
  final HMSTrackKind kind;
  final HMSTrackSource source;
  final String trackDescription;

  bool isMute();

  const HMSTrack({
    required this.kind,
    required this.source,
    required this.trackId,
    required this.trackDescription,
  });
}
