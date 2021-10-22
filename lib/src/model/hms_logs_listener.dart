import 'package:hmssdk_flutter/src/model/hms_log.dart';

abstract class HMSLogListener {
  void onLogMessage({required HMSLog});
}
