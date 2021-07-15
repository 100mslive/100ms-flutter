import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';

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

  static Stream<PlatformMethodResponse> listenToPlatformCalls() {
    return _meetingEventChannel
        .receiveBroadcastStream()
        .map<PlatformMethodResponse>((event) {
      PlatformMethod method =
          PlatformMethodValues.getMethodFromName(event['event_name']);
      Map<String, dynamic>? data = {};
      if (event is Map && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }
      PlatformMethodResponse response =
          PlatformMethodResponse(method: method, data: data, response: event);
      if (method == PlatformMethod.unknown) {
        print(event);
      }
      switch (response.method) {
        case PlatformMethod.joinMeeting:
          return response;
        case PlatformMethod.leaveMeeting:
          return response;
        case PlatformMethod.onJoinRoom:
          return response;
        case PlatformMethod.onUpdateRoom:
          return response;
        case PlatformMethod.onPeerUpdate:
          return response;
        case PlatformMethod.onTrackUpdate:
          return response;
        case PlatformMethod.onError:
          return response;
        case PlatformMethod.onMessage:
          return response;
        case PlatformMethod.onUpdateSpeaker:
          return response;
        case PlatformMethod.onReconnecting:
          return response;
        case PlatformMethod.onReconnected:
          return response;
        default:
          return response;
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
