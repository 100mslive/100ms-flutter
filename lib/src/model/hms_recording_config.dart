import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSRecordingConfg
///
///[HMSRecordingConfig] contains meeting Url, record status, rtmp Urls list and video resolution.
class HMSRecordingConfig {
  final String meetingUrl;
  final bool toRecord;
  List<String>? rtmpUrls;
  HMSResolution? resolution;
  HMSRecordingConfig(
      {required this.meetingUrl,
      required this.toRecord,
      this.rtmpUrls,
      this.resolution});

  Map<String, dynamic> getJson() {
    return {
      "meeting_url": meetingUrl,
      "to_record": toRecord,
      "rtmp_urls": rtmpUrls,
      "resolution": resolution?.toMap() ?? null
    };
  }
}
