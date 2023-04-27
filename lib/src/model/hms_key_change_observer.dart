import 'package:hmssdk_flutter/src/model/hms_key_change_listener.dart';

class HMSKeyChangeObserver {
  final String uid;
  final HMSKeyChangeListener hmsKeyChangeListener;

  HMSKeyChangeObserver({required this.uid, required this.hmsKeyChangeListener});
}
