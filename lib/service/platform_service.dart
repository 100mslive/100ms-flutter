import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';

class PlatformService {
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');
  static const EventChannel _meetingEventChannel =
      const EventChannel('meeting_event_channel');

  static Future<dynamic> invokeMethod(PlatformMethod method,
      {Map? arguments}) async {
    var result = await _channel.invokeMethod(
        PlatformMethodValues.getName(method), arguments);
    print(result);
    return result;
  }

  static Stream<PlatformMethod> listenToPlatformCalls() {
    return _meetingEventChannel
        .receiveBroadcastStream()
        .map<PlatformMethod>((event) {
      PlatformMethod method = PlatformMethodValues.getMethodFromName(event);
      switch (PlatformMethodValues.getMethodFromName(event)) {
        case PlatformMethod.joinMeeting:
          return method;
        case PlatformMethod.leaveMeeting:
          return method;
        case PlatformMethod.onJoinRoom:
          return method;
        case PlatformMethod.onUpdateRoom:
          return method;
        case PlatformMethod.onPeerUpdate:
          return method;
        case PlatformMethod.onTrackUpdate:
          return method;
        case PlatformMethod.onError:
          return method;
        case PlatformMethod.onMessage:
          return method;
        case PlatformMethod.onUpdateSpeaker:
          return method;
        case PlatformMethod.onReconnecting:
          return method;
        case PlatformMethod.onReconnected:
          return method;
        default:
          return method;
      }
    });

    // _channel.setMethodCallHandler((call) async {
    //   print(call.method);
    //   switch (PlatformMethodValues.getMethodFromName(call.method)) {
    //     case PlatformMethod.joinMeeting:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.leaveMeeting:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onJoinRoom:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onUpdateRoom:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onPeerUpdate:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onTrackUpdate:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onError:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onMessage:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onUpdateSpeaker:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onReconnecting:
    //       print(call.method);
    //       return call.method;
    //     case PlatformMethod.onReconnected:
    //       print(call.method);
    //       return call.method;
    //     default:
    //       print('No method found');
    //   }
    // });
  }
}
