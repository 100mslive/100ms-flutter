class HMSRecordingConfig {
  final String meetingUrl;
  final bool toRecord;
  List<String>? rtmpUrls;

  HMSRecordingConfig(
      {required this.meetingUrl, required this.toRecord, rtmpUrls});

  Map<String, dynamic> getJson() {
    return {
      "meeting_url": meetingUrl,
      "to_record": toRecord,
      "rtmpUrls": rtmpUrls
    };
  }
}
