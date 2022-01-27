import 'package:hmssdk_flutter/src/model/hms_hls_meeting_url_variant.dart';

class HMSHLSConfig {
  List<HMSHLSMeetingURLVariant> meetingURLVariants;

  HMSHLSConfig(this.meetingURLVariants);

  Map<String, dynamic> toMap() {

    List<Map<String,String>> list = [];

    meetingURLVariants.forEach((element) {
      list.add(element.toMap());
    });

    return {
      'meeting_url_variants': list,
    };
  }
}
