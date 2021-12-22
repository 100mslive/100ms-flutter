///PlatformService helps to connect to android or ios depending on device
///
///It has two FlutterEvent Channels one for meetingUpdates and another for preview updates.
///
///It has one MethodChannel to use different functionalities present at Android and Ios side.You can check them in PlatformMethod enum.
///
///You can add as many as [meeting_event_listeners] and [preview_event_listeners].
///
///[hmssdk_flutter] will send updates to all the listeners when there is any change in anything.
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/common/platform_methods.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';
import 'package:hmssdk_flutter/src/model/hms_log.dart';
import 'package:hmssdk_flutter/src/model/hms_logs_listener.dart';
import 'package:hmssdk_flutter/src/model/hms_track_change_request.dart';

class PlatformService {
  ///used to pass data to platform using methods
  static const MethodChannel _channel = const MethodChannel('hmssdk_flutter');

  ///used to get stream of data from platform side happening in the room.
  static const EventChannel _meetingEventChannel =
      const EventChannel('meeting_event_channel');

  ///used to get stream of data from platform side happening in the preview.
  static const EventChannel _previewEventChannel =
      const EventChannel('preview_event_channel');

  static const EventChannel _logsEventChannel =
      const EventChannel("logs_event_channel");

  ///add meeting listeners.
  static List<HMSUpdateListener> meetingListeners = [];

  static List<HMSLogListener> logsListeners = [];

  ///add preview listeners.
  static List<HMSPreviewListener> previewListeners = [];
  static bool isStartedListening = false;

  ///add meetingListener
  static void addMeetingListener(HMSUpdateListener newListener) {
    meetingListeners.add(newListener);
  }

  ///remove meetingListener just pass the listener instance you want to remove.
  static void removeMeetingListener(HMSUpdateListener listener) {
    if (meetingListeners.contains(listener)) meetingListeners.remove(listener);
  }

  ///add previewListener
  static void addPreviewListener(HMSPreviewListener newListener) {
    previewListeners.add(newListener);
  }

  ///remove previewListener just pass the listener instance you want to remove.
  static void removePreviewListener(HMSPreviewListener listener) {
    if (previewListeners.contains(listener)) previewListeners.remove(listener);
  }



  static void addLogsListener(
    HMSLogListener hmsLogListener,
  ) {
    logsListeners.add(hmsLogListener);
  }

  static void removeLogsListener(HMSLogListener hmsLogListener) {
    logsListeners.remove(hmsLogListener);
  }

  ///used to invoke different methods at platform side and returns something but not neccessarily
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

  ///recieves all the meeting updates here as streams
  static void updatesFromPlatform() {
    _logsEventChannel.receiveBroadcastStream({'name': 'logs'}).map((event) {
      print(event.toString() + 'LOGSCHANNEL');
      Map<String, dynamic>? data = {};
      if (event is Map && event['data'] != null && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }

      HMSLogsUpdateListenerMethod method =
          HMSLogsUpdateListenerMethodValues.getMethodFromName(
              event['event_name']);
      return HMSLogsUpdateListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      HMSLogsUpdateListenerMethod method = event.method;
      print("flutterdata1 ${event.method}");
      Map<String, dynamic> data = event.data;

      switch (method) {
        case HMSLogsUpdateListenerMethod.onLogsUpdate:
          notifyLogsUpdateListeners(method, data);
          break;
        case HMSLogsUpdateListenerMethod.unknown:
          break;
      }
    });

    _meetingEventChannel.receiveBroadcastStream(
        {'name': 'meeting'}).map<HMSUpdateListenerMethodResponse>((event) {
      Map<String, dynamic>? data = {};
      print("flutterdata2 ${event["event_name"]} ${event["data"]}");
      if (event is Map && event['data'] != null && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }

      HMSUpdateListenerMethod method =
          HMSUpdateListenerMethodValues.getMethodFromName(event['event_name']);
      return HMSUpdateListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      HMSUpdateListenerMethod method = event.method;
      print("flutterdata1 ${event.method}");
      Map data = event.data;

      switch (method) {
        case HMSUpdateListenerMethod.onJoinRoom:
          HMSRoom? room = HMSRoom.fromMap(data['room']);
          notifyMeetingListeners(method, {'room': room});
          break;
        case HMSUpdateListenerMethod.onUpdateRoom:
          HMSRoom? room =
              data['room'] != null ? HMSRoom.fromMap(data['room']) : null;

          HMSRoomUpdate? update =
              HMSRoomUpdateValues.getHMSRoomUpdateFromName(data['room']['update']);
          notifyMeetingListeners(method, {'room': room, 'update': update});
          break;
        case HMSUpdateListenerMethod.onPeerUpdate:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          print(data['update']);
          HMSPeerUpdate? update =
              HMSPeerUpdateValues.getHMSPeerUpdateFromName(data['update']);
          notifyMeetingListeners(method, {'peer': peer, 'update': update});
          break;
        case HMSUpdateListenerMethod.onTrackUpdate:
          HMSPeer? peer = HMSPeer.fromMap(event.data['peer']);
          //print("HMSUpdateListeneronTrackupdate ${peer.toString()}");
          HMSTrack? track = data['track']['instance_of']
              ? HMSVideoTrack.fromMap(map: data['track'], peer: peer)
              : HMSAudioTrack.fromMap(map: data['track'], peer: peer);
          HMSTrackUpdate? update =
              HMSTrackUpdateValues.getHMSTrackUpdateFromName(data['update']);
          print("UpdateTrack $update  ${data['update']}");
          notifyMeetingListeners(
              method, {'track': track, 'peer': peer, 'update': update});
          break;
        case HMSUpdateListenerMethod.onError:
          HMSException error = HMSException.fromMap(data['error'] as Map);
          notifyMeetingListeners(method, {'error': error});
          break;
        case HMSUpdateListenerMethod.onMessage:
          HMSMessage message = HMSMessage.fromMap(data['message']);
          notifyMeetingListeners(method, {'message': message});
          break;
        case HMSUpdateListenerMethod.onUpdateSpeaker:
          List<HMSSpeaker> speakers = [];
          if (data.containsKey('speakers') && data['speakers'] is List) {
            if ((data['speakers'] as List).isNotEmpty) {
              (data['speakers'] as List).forEach((element) {
                speakers.add(HMSSpeaker.fromMap(element as Map));
              });
            }
          }

          print("${speakers.length} speakersLength ");
          notifyMeetingListeners(method, {'speakers': speakers});
          break;
        case HMSUpdateListenerMethod.onReconnecting:
          notifyMeetingListeners(method, {});
          break;
        case HMSUpdateListenerMethod.onReconnected:
          notifyMeetingListeners(method, {});
          break;
        case HMSUpdateListenerMethod.onRoleChangeRequest:
          HMSRoleChangeRequest? roleChangeRequest =
              HMSRoleChangeRequest.fromMap(data['role_change_request']);
          notifyMeetingListeners(
              method, {'role_change_request': roleChangeRequest});
          break;
        case HMSUpdateListenerMethod.onChangeTrackStateRequest:
          print("flutter listener $data");
          HMSTrackChangeRequest trackChangeRequest =
              HMSTrackChangeRequest.fromMap(
                  data['track_change_request'] as Map);
          notifyMeetingListeners(
              method, {'track_change_request': trackChangeRequest});
          break;
        case HMSUpdateListenerMethod.unknown:
          print('Unknown method called');
          break;
        case HMSUpdateListenerMethod.onRemovedFromRoom:
          HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer =
              HMSPeerRemovedFromPeer.fromMap(data['removed_from_room'] as Map);
          notifyMeetingListeners(
              method, {'removed_from_room': hmsPeerRemovedFromPeer});
          break;
      }
    });

    ///recieves all updates regaring preview as streams
    _previewEventChannel.receiveBroadcastStream({'name': 'preview'}).map<
        HMSPreviewUpdateListenerMethodResponse>((event) {
      Map<String, dynamic>? data = {};
      if (event is Map && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }
      HMSPreviewUpdateListenerMethod method =
          HMSPreviewUpdateListenerMethodValues.getMethodFromName(
              event['event_name']);
      return HMSPreviewUpdateListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      HMSPreviewUpdateListenerMethod method = event.method;

      switch (method) {
        case HMSPreviewUpdateListenerMethod.onPreviewVideo:
          HMSRoom? room = HMSRoom.fromMap(event.data['room']);
          List<HMSTrack> tracks = HMSTrack.getHMSTracksFromList(
              listOfMap: event.data['local_tracks']);
          notifyPreviewListeners(
              method, {'room': room, 'local_tracks': tracks});
          break;
        case HMSPreviewUpdateListenerMethod.onError:
          HMSException? error =
              HMSException.fromMap(event.data["error"] as Map);
          notifyPreviewListeners(method, {'error': error});
          break;
        case HMSPreviewUpdateListenerMethod.unknown:
          break;
      }
    });
  }

  static void notifyLogsUpdateListeners(
      HMSLogsUpdateListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSLogsUpdateListenerMethod.onLogsUpdate:
        print("$arguments argumentsLogsUpdateListeners");
        logsListeners.forEach((element) {
          HMSLog hmsLog = HMSLog.fromMap(arguments);
          element.onLogMessage(HMSLog: hmsLog);
        });
        break;
      case HMSLogsUpdateListenerMethod.unknown:
        break;
    }
  }

  ///notifying all previewListeners attached about updates
  static void notifyPreviewListeners(
      HMSPreviewUpdateListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSPreviewUpdateListenerMethod.onPreviewVideo:
        previewListeners.forEach((e) {
          e.onPreview(
              room: arguments['room'], localTracks: arguments['local_tracks']);
        });
        break;
      case HMSPreviewUpdateListenerMethod.onError:
        previewListeners.forEach((e) {
          e.onError(error: arguments["error"]);
        });
        break;
      case HMSPreviewUpdateListenerMethod.unknown:
        break;
    }
  }

  ///notifying all meetingListeners attached about updates
  static void notifyMeetingListeners(
      HMSUpdateListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSUpdateListenerMethod.onJoinRoom:
        meetingListeners.forEach((e) => e.onJoin(room: arguments['room']));
        break;
      case HMSUpdateListenerMethod.onUpdateRoom:
        meetingListeners.forEach((e) => e.onRoomUpdate(
            room: arguments['room'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onPeerUpdate:
        meetingListeners.forEach((e) => e.onPeerUpdate(
            peer: arguments['peer'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onTrackUpdate:
        meetingListeners.forEach((e) => e.onTrackUpdate(
            track: arguments['track'],
            trackUpdate: arguments['update'],
            peer: arguments['peer']));
        break;
      case HMSUpdateListenerMethod.onError:
        meetingListeners.forEach((e) => e.onError(error: arguments['error']));
        break;
      case HMSUpdateListenerMethod.onMessage:
        meetingListeners
            .forEach((e) => e.onMessage(message: arguments['message']));
        break;
      case HMSUpdateListenerMethod.onUpdateSpeaker:
        print("flutterOnUpdateSpeaker $arguments");
        meetingListeners.forEach(
            (e) => e.onUpdateSpeakers(updateSpeakers: arguments['speakers']));
        break;
      case HMSUpdateListenerMethod.onReconnecting:
        meetingListeners.forEach((e) => e.onReconnecting());
        break;
      case HMSUpdateListenerMethod.onReconnected:
        meetingListeners.forEach((e) => e.onReconnected());
        break;
      case HMSUpdateListenerMethod.onRoleChangeRequest:
        meetingListeners.forEach((e) => e.onRoleChangeRequest(
            roleChangeRequest: arguments['role_change_request']));
        break;
      case HMSUpdateListenerMethod.onChangeTrackStateRequest:
        meetingListeners.forEach((e) => e.onChangeTrackStateRequest(
            hmsTrackChangeRequest: arguments['track_change_request']));
        break;

      case HMSUpdateListenerMethod.onRemovedFromRoom:
        if(meetingListeners.isEmpty)break;
        meetingListeners.forEach((element) {
          element.onRemovedFromRoom(
              hmsPeerRemovedFromPeer: arguments['removed_from_room']);
        });
        break;
      case HMSUpdateListenerMethod.unknown:
        break;
    }
  }
}
