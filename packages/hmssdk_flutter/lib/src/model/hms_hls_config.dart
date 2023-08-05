import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSHLSConfig
///
///[HMSHLSConfig] contains a list of [HMSHLSMeetingURLVariant].
class HMSHLSConfig {
  List<HMSHLSMeetingURLVariant>? meetingURLVariant;
  HMSHLSRecordingConfig? hmsHLSRecordingConfig;
  HMSHLSConfig({this.meetingURLVariant, this.hmsHLSRecordingConfig});

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> map = {};
    if (meetingURLVariant != null) {
      meetingURLVariant?.forEach((element) {
        list.add(element.toMap());
      });
      map["meeting_url_variants"] = list;
    }
    if (hmsHLSRecordingConfig != null) {
      Map recordingConfig = hmsHLSRecordingConfig!.toMap();
      map['recording_config'] = recordingConfig;
    }
    return map;
  }
}
