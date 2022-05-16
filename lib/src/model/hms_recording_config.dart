///100ms HMSRecordingConfg
///
///[HMSRecordingConfig] contains meeting Url, record status anf rtmp Urls list.
class HMSRecordingConfig {
  final String meetingUrl;
  final bool toRecord;
  List<String>? rtmpUrls;

  HMSRecordingConfig(
      {required this.meetingUrl, required this.toRecord, this.rtmpUrls});

  Map<String, dynamic> getJson() {
    return {
      "meeting_url": meetingUrl,
      "to_record": toRecord,
      "rtmp_urls": rtmpUrls
    };
  }
}
