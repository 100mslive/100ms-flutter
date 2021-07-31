import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/enum/hms_room_update.dart';
import 'package:hmssdk_flutter/enum/hms_track_update.dart';
import 'package:hmssdk_flutter/enum/hms_update_listener_method.dart';
import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_role_change_request.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_speaker.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/model/hms_update_listener.dart';
import 'package:hmssdk_flutter/model/platform_method_response.dart';

class PlatformService {
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');
  static const EventChannel _meetingEventChannel =
      const EventChannel('meeting_event_channel');
  static List<HMSUpdateListener> listeners = [];
  static bool isStartedListening = false;

  static void addListener(HMSUpdateListener newListener) {
    listeners.add(newListener);
  }

  static Future<dynamic> invokeMethod(PlatformMethod method,
      {Map? arguments}) async {
    if (!isStartedListening) {
      isStartedListening = true;
      updatesFromPlatform();
    }
    var result = await _channel.invokeMethod(
        PlatformMethodValues.getName(method), arguments);
    print(result);
    return result;
  }

  static Stream<PlatformMethodResponse> listenToPlatformCalls() {
    return Stream.periodic(Duration(seconds: 1), (_) {
      return PlatformMethodResponse(
          response: {}, method: PlatformMethod.onReconnecting, data: {});
    });
    // return _meetingEventChannel
    //     .receiveBroadcastStream()
    //     .map<PlatformMethodResponse>((event) {
    //   PlatformMethod method =
    //       PlatformMethodValues.getMethodFromName(event['event_name']);
    //
    //   Map<String, dynamic>? data = {};
    //   if (event is Map && event['data'] is Map) {
    //     (event['data'] as Map).forEach((key, value) {
    //       data[key.toString()] = value;
    //     });
    //   }
    //   PlatformMethodResponse response =
    //       PlatformMethodResponse(method: method, data: data, response: event);
    //   if (method == PlatformMethod.unknown) {
    //     print(event);
    //   }
    //   switch (response.method) {
    //     case PlatformMethod.joinMeeting:
    //       return response;
    //     case PlatformMethod.leaveMeeting:
    //       return response;
    //     case PlatformMethod.onJoinRoom:
    //       return response;
    //     case PlatformMethod.onUpdateRoom:
    //       return response;
    //     case PlatformMethod.onPeerUpdate:
    //       return response;
    //     case PlatformMethod.onTrackUpdate:
    //       return response;
    //     case PlatformMethod.onError:
    //       return response;
    //     case PlatformMethod.onMessage:
    //       return response;
    //     case PlatformMethod.onUpdateSpeaker:
    //       return response;
    //     case PlatformMethod.onReconnecting:
    //       return response;
    //     case PlatformMethod.onReconnected:
    //       return response;
    //     default:
    //       return response;
    //   }
    // });
  }

  static void updatesFromPlatform() {
    // _meetingEventChannel.receiveBroadcastStream().listen((event) {
    //   print('bol hello');
    // });

    // _meetingEventChannel
    //     .receiveBroadcastStream()
    //     .map((event) => event)
    //     .listen((event) {
    //   print('bol hello kuster');
    // });

    _meetingEventChannel
        .receiveBroadcastStream()
        .map<HMSUpdateListenerMethodResponse>((event) {
      Map<String, dynamic>? data = {};
      if (event is Map && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }
      HMSUpdateListenerMethod method =
          HMSUpdateListenerMethodValues.getMethodFromName(event['event_name']);
      return HMSUpdateListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      // Map<String, dynamic>? data = {};
      // if (event is Map && event['data'] is Map) {
      //   (event['data'] as Map).forEach((key, value) {
      //     data[key.toString()] = value;
      //   });
      // }
      HMSUpdateListenerMethod method = event.method;
      Map data = event.data;
      switch (method) {
        case HMSUpdateListenerMethod.onJoinRoom:
          HMSRoom? room = HMSRoom.fromMap(data['room']);
          notifyListeners(method, {'room': room});
          break;
        case HMSUpdateListenerMethod.onUpdateRoom:
          HMSRoom? room = HMSRoom.fromMap(data['room']);
          HMSRoomUpdate? update =
              HMSRoomUpdateValues.getHMSRoomUpdateFromName(data['update']);
          notifyListeners(method, {'room': room, 'update': update});
          break;
        case HMSUpdateListenerMethod.onPeerUpdate:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSPeerUpdate? update =
              HMSPeerUpdateValues.getHMSPeerUpdateFromName(data['update']);
          notifyListeners(method, {'peer': peer, 'update': update});
          break;
        case HMSUpdateListenerMethod.onTrackUpdate:
          HMSPeer? peer = HMSPeer.fromMap(event.data['peer']);
          HMSTrack? track = HMSTrack.fromMap(data['track'], peer);
          HMSTrackUpdate? update =
              HMSTrackUpdateValues.getHMSTrackUpdateFromName(data['update']);

          notifyListeners(
              method, {'track': track, 'peer': peer, 'update': update});
          break;
        case HMSUpdateListenerMethod.onError:
          HMSError error = HMSError.fromMap(data['error']);
          notifyListeners(method, {'error': error});
          break;
        case HMSUpdateListenerMethod.onMessage:
          HMSMessage message = HMSMessage.fromMap(data['message']);
          notifyListeners(method, {'message': message});
          break;
        case HMSUpdateListenerMethod.onUpdateSpeaker:
          List<HMSSpeaker> speakers = [];
          if (data.containsKey('speakers') && data['speakers'] is List) {
            (data['speakers'] as List)
                .map((e) => speakers.add(HMSSpeaker.fromMap(e)));
          }
          notifyListeners(method, {'speakers': speakers});
          break;
        case HMSUpdateListenerMethod.onReconnecting:
          notifyListeners(method, {});
          break;
        case HMSUpdateListenerMethod.onReconnected:
          notifyListeners(method, {});
          break;
        case HMSUpdateListenerMethod.onRoleChangeRequest:
          HMSRoleChangeRequest roleChangeRequest =
              HMSRoleChangeRequest.fromMap(data['role_change_request']);
          notifyListeners(method, {});
          break;
        case HMSUpdateListenerMethod.unknown:
          print('Unknown method called');
          break;
      }
    });

    // HMSUpdateListenerMethodResponse response =
    //     HMSUpdateListenerMethodResponse(
    //         method: updateMethod, data: data, response: event);
    // if (updateMethod == HMSUpdateListenerMethod.unknown) {
    //   print(event);
    // }
  }

  static void notifyListeners(
      HMSUpdateListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSUpdateListenerMethod.onJoinRoom:
        listeners.forEach((e) => e.onJoin(room: arguments['room']));
        break;
      case HMSUpdateListenerMethod.onUpdateRoom:
        listeners.forEach((e) => e.onRoomUpdate(
            room: arguments['room'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onPeerUpdate:
        listeners.forEach((e) => e.onPeerUpdate(
            peer: arguments['peer'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onTrackUpdate:
        listeners.forEach((e) => e.onTrackUpdate(
            track: arguments['track'],
            trackUpdate: arguments['update'],
            peer: arguments['peer']));
        break;
      case HMSUpdateListenerMethod.onError:
        listeners.forEach((e) => e.onError(error: arguments['error']));
        break;
      case HMSUpdateListenerMethod.onMessage:
        listeners.forEach((e) => e.onMessage(message: arguments['message']));
        break;
      case HMSUpdateListenerMethod.onUpdateSpeaker:
        listeners.forEach(
            (e) => e.onUpdateSpeakers(updateSpeakers: arguments['speakers']));
        break;
      case HMSUpdateListenerMethod.onReconnecting:
        listeners.forEach((e) => e.onReconnecting());
        break;
      case HMSUpdateListenerMethod.onReconnected:
        listeners.forEach((e) => e.onReconnected());
        break;
      case HMSUpdateListenerMethod.onRoleChangeRequest:
        listeners.forEach((e) => e.onRoleChangeRequest(
            roleChangeRequest: arguments['role_change_request']));
        break;
      case HMSUpdateListenerMethod.unknown:
        break;
    }
  }
}
