import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';

class HMSHLSCue {
  final String? id;
  final DateTime startDate;
  final DateTime? endDate;
  final String? payload;

  HMSHLSCue({this.id, required this.startDate, this.endDate, this.payload});

  factory HMSHLSCue.fromMap(Map map) {
    return HMSHLSCue(
        startDate: HMSDateExtension.convertDate(map["start_date"]),
        endDate: map["end_date"]==null?null:HMSDateExtension.convertDate(map["end_date"]),
        id: map["id"],
        payload: map["payload"]);
  }
}
