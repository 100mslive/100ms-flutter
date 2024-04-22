//Dart imports
import 'dart:core';

///Project imports
import 'package:hmssdk_flutter/src/enum/hms_hls_playlist_type.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///100ms HMSHLSVarient
///
///[HMSHLSVariant] contains the information about HLS Streaming Url, meeting Url, metadata and startedAt.
class HMSHLSVariant {
  final String? hlsStreamUrl;
  final String? meetingUrl;
  final String? metadata;
  final DateTime? startedAt;
  final HMSHLSPlaylistType playlistType;

  HMSHLSVariant(
      {required this.hlsStreamUrl,
      required this.meetingUrl,
      required this.metadata,
      required this.startedAt,
      required this.playlistType});

  Map<String, dynamic> toMap() {
    return {
      'hlsStreamUrl': this.hlsStreamUrl,
      'meetingUrl': this.meetingUrl,
      'metadata': this.metadata,
      'startedAt': this.startedAt,
      'playlist_type': this.playlistType,
    };
  }

  @override
  String toString() {
    return 'HMSHLSVariant{hlsStreamUrl: $hlsStreamUrl, meetingUrl: $meetingUrl, metadata: $metadata, startedAt: $startedAt}';
  }

  factory HMSHLSVariant.fromMap(Map map) {
    return HMSHLSVariant(
        hlsStreamUrl: map['hls_stream_url'] as String?,
        meetingUrl: map['meeting_url'] as String?,
        metadata: map['metadata'] as String?,
        startedAt: map['started_at'] != null
            ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
            : null,
        playlistType: HMSHLSPlaylistTypeValues.getHMSHLSPlaylistTypeFromString(
            map["playlist_type"]));
  }
}
