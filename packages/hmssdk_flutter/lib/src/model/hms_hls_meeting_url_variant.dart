///100ms HMSHLSMeetingURLVariant
///
///[HMSHLSMeetingURLVariant] contains information about the meeting Url and metadata about the HMS HLS Meeting.
class HMSHLSMeetingURLVariant {
  String? meetingUrl;
  String metadata;

  HMSHLSMeetingURLVariant({required this.meetingUrl, required this.metadata});

  Map<String, dynamic> toMap() {
    return {
      'meeting_url': this.meetingUrl ?? null,
      'meta_data': this.metadata,
    };
  }

  factory HMSHLSMeetingURLVariant.fromMap(Map<String, dynamic> map) {
    return HMSHLSMeetingURLVariant(
      meetingUrl: map['meeting_url'],
      metadata: map['meta_data'] as String,
    );
  }
}
