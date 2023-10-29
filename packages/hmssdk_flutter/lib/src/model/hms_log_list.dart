///100ms HMSLogList
///
///HMSLogList contains the list of [String].
class HMSLogList {
  late List<String> hmsLog;

  HMSLogList({required this.hmsLog});

  factory HMSLogList.fromMap(List<dynamic> logs) {
    List<String> listHMSLog = [];

    for (var element in logs) {
      if (element != null) {
        listHMSLog.add(element);
      }
    }

    return HMSLogList(hmsLog: listHMSLog);
  }

  @override
  String toString() {
    String result = "";
    for (var element in hmsLog) {
      result += "$element\n";
    }
    return result;
  }
}
