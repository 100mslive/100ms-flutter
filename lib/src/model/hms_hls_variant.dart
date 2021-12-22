import 'dart:core';

class HMSHLSVariant{

  final String hlsStreamUrl;
  final String meetingUrl;
  final String metadata;
  final double startedAt;

  HMSHLSVariant(
      {required this.hlsStreamUrl,required this.meetingUrl,required this.metadata,required this.startedAt});

  Map<String, dynamic> toMap() {
    return {
      'hlsStreamUrl': this.hlsStreamUrl,
      'meetingUrl': this.meetingUrl,
      'metadata': this.metadata,
      'startedAt': this.startedAt,
    };
  }

  factory HMSHLSVariant.fromMap(Map<String, dynamic> map) {
    return HMSHLSVariant(
      hlsStreamUrl: map['hlsStreamUrl'] as String,
      meetingUrl: map['meetingUrl'] as String,
      metadata: map['metadata'] as String,
      startedAt: map['startedAt'] as double,
    );
  }
}