///100ms HMSRecordingConfg
///
///[HMSRecordingConfig] contains meeting Url, record status anf rtmp Urls list.
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
