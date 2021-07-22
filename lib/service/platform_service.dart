import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';

class PlatformService {
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');
  static const EventChannel _meetingEventChannel =
      const EventChannel('meeting_event_channel');

  static Future<dynamic> invokeMethod(PlatformMethod method,
      {Map? arguments}) async {
    debugPrint("invokeMethod");
    var result = await _channel.invokeMethod(
        PlatformMethodValues.getName(method), arguments);
    print(result);
    return result;
  }

  static Stream<PlatformMethodResponse> listenToPlatformCalls() {
    return _meetingEventChannel
        .receiveBroadcastStream()
        .map<PlatformMethodResponse>((event) {
          debugPrint(event['event_name'].toString()+"AAAAAAAAAAHHHHHHRRRROOOONNNNN");
      PlatformMethod method =
          PlatformMethodValues.getMethodFromName(event['event_name']);
          debugPrint(method.toString()+"AAAAAAAAAAHHHHHHRRRROOOONNNNN");
      Map<String, dynamic>? data = {};
      if (event is Map && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }
      debugPrint("DATA"+data.toString()+"AAAAAAAAAAAAHHHHHHHHHHHHRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOONNNNNNNNNNN");
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

  }
}
