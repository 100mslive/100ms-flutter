import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSHLSConfig
///
///[HMSHLSConfig] contains a list of [HMSHLSMeetingURLVariant].
class HMSHLSConfig {
  List<HMSHLSMeetingURLVariant> meetingURLVariant;
  HMSHLSRecordingConfig? hmsHLSRecordingConfig;
  HMSHLSConfig({required this.meetingURLVariant, this.hmsHLSRecordingConfig});

  Map<String, dynamic> toMap() {
    List<Map<String, String>> list = [];

    meetingURLVariant.forEach((element) {
      list.add(element.toMap());
    });
    Map recordingConfig =
        hmsHLSRecordingConfig?.toMap() ?? HMSHLSRecordingConfig().toMap();
    return {'meeting_url_variants': list, 'recording_config': recordingConfig};
  }
}
