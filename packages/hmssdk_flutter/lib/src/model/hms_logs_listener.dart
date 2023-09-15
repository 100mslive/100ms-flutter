import 'package:hmssdk_flutter/src/model/hms_log_list.dart';

abstract class HMSLogListener {
  void onLogMessage({required HMSLogList hmsLogList});
}
