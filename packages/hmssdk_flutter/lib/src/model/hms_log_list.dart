///100ms HMSLogList
///
///HMSLogList contains the list of [String].
class HMSLogList {
  late List<String> hmsLog;

  HMSLogList({required this.hmsLog});

  factory HMSLogList.fromMap(List<dynamic> logs) {
    List<String> listHMSLog = [];

    logs.forEach((element) {
      if (element != null) {
        listHMSLog.add(element);
      }
    });

    return HMSLogList(hmsLog: listHMSLog);
  }

  @override
  String toString() {
    String result = "";
    hmsLog.forEach((element) {
      result += element + "\n";
    });
    return result;
  }
}
