//Dart imports
import 'dart:core';

///100ms HMSHLSVarient
///
///[HMSHLSVariant] contains the information about HLS Streaming Url, meeting Url, metadata and startedAt.
class HMSHLSVariant {
  final String? hlsStreamUrl;
  final String? meetingUrl;
  final String? metadata;
  final int? startedAt;

  HMSHLSVariant(
      {required this.hlsStreamUrl,
      required this.meetingUrl,
      required this.metadata,
      required this.startedAt});

  Map<String, dynamic> toMap() {
    return {
      'hlsStreamUrl': this.hlsStreamUrl,
      'meetingUrl': this.meetingUrl,
      'metadata': this.metadata,
      'startedAt': this.startedAt,
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
      startedAt: map['started_at'] as int?,
    );
  }
}
