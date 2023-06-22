//Project imports
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

///100ms HMSHLSCue
///
///[HMSHLSCue] is used to parse the timed metadata sent across the platforms.
///Checkout the docs [here](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-get-hls-callbacks)
class HMSHLSCue {
  // Unique id of the timed event
  final String? id;

  // startDate of the timed event
  final DateTime startDate;

  // endDate of the timed event
  final DateTime? endDate;

  // String payload of the timed event
  final String? payload;

  HMSHLSCue({this.id, required this.startDate, this.endDate, this.payload});

  factory HMSHLSCue.fromMap(Map map) {
    return HMSHLSCue(
        startDate: HMSDateExtension.convertDate(map["start_date"]),
        endDate: map["end_date"] == null
            ? null
            : HMSDateExtension.convertDate(map["end_date"]),
        id: map["id"],
        payload: map["payload"]);
  }
}
