class HMSHLSMeetingURLVariant {
  String meetingUrl;
  String metadata;

  HMSHLSMeetingURLVariant({required this.meetingUrl, required this.metadata});

  Map<String, String> toMap() {
    return {
      'meeting_url': this.meetingUrl,
      'meta_data': this.metadata,
    };
  }

  factory HMSHLSMeetingURLVariant.fromMap(Map<String, dynamic> map) {
    return HMSHLSMeetingURLVariant(
      meetingUrl: map['meeting_url'] as String,
      metadata: map['meta_data'] as String,
    );
  }
}
