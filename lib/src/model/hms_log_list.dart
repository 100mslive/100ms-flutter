import 'package:hmssdk_flutter/src/model/hms_custom_log.dart';

class HMSLogList {
  late List<HMSCustomLog> hmsLog;

  HMSLogList({required this.hmsLog});

  factory HMSLogList.fromMap(List<dynamic> logs) {
    List<HMSCustomLog> listHMSLog = [];

    logs.forEach((element) {
      Map data = {};
      (element['data'] as Map).forEach((key, value) {
        data[key] = value;
      });
      listHMSLog.add(HMSCustomLog.fromMap(data));
    });

    return HMSLogList(hmsLog: listHMSLog);
  }

  @override
  String toString() {
    String result = "";
    hmsLog.forEach((element) {
      result += element.toMap().toString() + "\n";
    });
    return result;
  }
}
