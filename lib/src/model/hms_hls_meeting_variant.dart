

class HMSHLSMeetingURLVariant{
  final String meetingURL;
  String metadata;

  HMSHLSMeetingURLVariant({required this.meetingURL, this.metadata=""});

  Map<String, dynamic> toMap() {
    return {
      'meeting_url': this.meetingURL,
      'metadata': this.metadata,
    };
  }

  factory HMSHLSMeetingURLVariant.fromMap(Map<String, String> map) {
    return HMSHLSMeetingURLVariant(
      meetingURL: map['meeting_url'] as String,
      metadata: map['metadata'] as String,
    );
  }
}