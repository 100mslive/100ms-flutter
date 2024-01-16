import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/hms_poll_listener.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSInteractivityCenter {
  static void addPollUpdateListener({required HMSPollListener listener}) async {
    PlatformService.addPollUpdateListener(listener);
  }

  static void removePollUpdateListener() async {
    PlatformService.removePollUpdateListener();
  }
}

abstract class PollBuilder {
  late bool _anonymous;
  late Duration _duration;
  late HMSPollUserTrackingMode _pollUserTrackingMode;
  late HMSPollCategory _pollCategory;
  late String _pollId;
  late int questionId;
  
}
