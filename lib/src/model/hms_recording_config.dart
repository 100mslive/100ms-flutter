import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSRecordingConfg
///
///[HMSRecordingConfig] contains meeting Url, record status, rtmp Urls list and video resolution.
class HMSRecordingConfig {
  ///Single click meeting url to start/stop recording/streaming.
  final String meetingUrl;

  ///true if recording/streaming should be started. false if recording/streaming should be stoppped.
  final bool toRecord;
  // The RTMP ingest url or urls where the meeting will be streamed.
  List<String>? rtmpUrls;

  ///The resolution that rtmp stream should be.
  ///
  ///Width Range:500-1280. If height>720 them max width=720.
  ///Default 1280.
  ///
  ///Height Range:480-1280. If width>720 them max height=720.
  ///Default 720.
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
