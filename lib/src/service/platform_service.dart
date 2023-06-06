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

// Flutter imports:
import 'package:flutter/services.dart';
// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_hls_playback_event_method.dart';
import 'package:hmssdk_flutter/src/enum/hms_key_change_listener_method.dart';
import 'package:hmssdk_flutter/src/enum/hms_logs_update_listener.dart';
import 'package:hmssdk_flutter/src/model/hms_key_change_observer.dart';

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

  ///used to get stream of rtc Stats
  static const EventChannel _rtcStatsChannel =
      const EventChannel("rtc_event_channel");

  ///used to get stream of session store changes
  static const EventChannel _sessionStoreChannel =
      const EventChannel("session_event_channel");

  ///used to get stream of session store changes
  static const EventChannel _hlsPlayerChannel =
      const EventChannel("hls_player_channel");

  ///add meeting listeners.
  static List<HMSUpdateListener> updateListeners = [];

  static List<HMSLogListener> logsListeners = [];

  ///add preview listeners.
  static List<HMSPreviewListener> previewListeners = [];

  static List<HMSKeyChangeObserver> keyChangeObservers = [];

  static List<HMSHLSPlaybackEventsListener> hlsPlaybackEventListener = [];

  ///List for event Listener
  static List<HMSStatsListener> statsListeners = [];
  static bool isStartedListening = false;

  ///add meetingListener
  static void addUpdateListener(HMSUpdateListener newListener) {
    updateListeners.add(newListener);
  }

  ///remove meetingListener just pass the listener instance you want to remove.
  static void removeUpdateListener(HMSUpdateListener listener) {
    if (updateListeners.contains(listener)) {
      updateListeners.remove(listener);
    }
  }

  ///add previewListener
  static void addPreviewListener(HMSPreviewListener newListener) {
    previewListeners.add(newListener);
  }

  ///remove previewListener just pass the listener instance you want to remove.
  static void removePreviewListener(HMSPreviewListener listener) {
    if (previewListeners.contains(listener)) previewListeners.remove(listener);
  }

  ///add RTCStats Listener
  static void addRTCStatsListener(HMSStatsListener listener) {
    PlatformService.invokeMethod(PlatformMethod.startStatsListener);
    statsListeners.add(listener);
  }

  ///remove meetingListener just pass the listener instance you want to remove.
  static void removeRTCStatsListener(HMSStatsListener listener) {
    if (statsListeners.contains(listener)) {
      statsListeners.remove(listener);
      PlatformService.invokeMethod(PlatformMethod.removeStatsListener);
    }
  }

  static void addLogsListener(
    HMSLogListener hmsLogListener,
  ) {
    logsListeners.add(hmsLogListener);
  }

  static void removeLogsListener(HMSLogListener hmsLogListener) {
    logsListeners.remove(hmsLogListener);
  }

  static void addKeyChangeObserver(HMSKeyChangeObserver hmsKeyChangeObserver) {
    keyChangeObservers.add(hmsKeyChangeObserver);
  }

  static Future<HMSException?> removeKeyChangeObserver(
      HMSKeyChangeListener hmsKeyChangeListener) async {
    int index = keyChangeObservers.indexWhere((observer) =>
        observer.hmsKeyChangeListener.hashCode ==
        hmsKeyChangeListener.hashCode);
    if (index != -1) {
      var result = await invokeMethod(PlatformMethod.removeKeyChangeListener,
          arguments: {"uid": keyChangeObservers[index].uid});
      if (result["success"]) {
        keyChangeObservers.removeAt(index);
        return null;
      } else {
        return HMSException.fromMap(result["data"]["error"]);
      }
    } else {
      return HMSException(
          message: "hmsKeyChangeListener not found",
          description: "No listener found to remove",
          action: "Listener Error",
          isTerminal: true);
    }
  }

  static void addHLSPlaybackEventListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    hlsPlaybackEventListener.add(hmshlsPlaybackEventsListener);
  }

  static void removeHLSPlaybackEventListener(
      HMSHLSPlaybackEventsListener hmshlsPlaybackEventsListener) {
    hlsPlaybackEventListener.remove(hmshlsPlaybackEventsListener);
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
    return result;
  }

  ///recieves all the meeting updates here as streams
  static void updatesFromPlatform() {
    _meetingEventChannel.receiveBroadcastStream(
        {'name': 'meeting'}).map<HMSUpdateListenerMethodResponse>((event) {
      Map<String, dynamic>? data = {};
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
      Map data = event.data;
      switch (method) {
        case HMSUpdateListenerMethod.onJoinRoom:
          HMSRoom? room = HMSRoom.fromMap(data['room']);
          notifyUpdateListeners(method, {'room': room});
          break;

        case HMSUpdateListenerMethod.onUpdateRoom:
          HMSRoom? room =
              data['room'] != null ? HMSRoom.fromMap(data['room']) : null;

          HMSRoomUpdate? update =
              HMSRoomUpdateValues.getHMSRoomUpdateFromName(data['update']);
          notifyUpdateListeners(method, {'room': room, 'update': update});
          break;

        case HMSUpdateListenerMethod.onPeerUpdate:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSPeerUpdate? update =
              HMSPeerUpdateValues.getHMSPeerUpdateFromName(data['update']);
          notifyUpdateListeners(method, {'peer': peer, 'update': update});
          break;

        case HMSUpdateListenerMethod.onTrackUpdate:
          HMSPeer? peer = HMSPeer.fromMap(event.data['peer']);
          HMSTrack? track = data['track']['instance_of']
              ? HMSVideoTrack.fromMap(map: data['track'], isLocal: peer.isLocal)
              : HMSAudioTrack.fromMap(
                  map: data['track'], isLocal: peer.isLocal);

          HMSTrackUpdate? update =
              HMSTrackUpdateValues.getHMSTrackUpdateFromName(data['update']);
          notifyUpdateListeners(
              method, {'track': track, 'peer': peer, 'update': update});
          break;

        case HMSUpdateListenerMethod.onError:
          HMSException error = HMSException.fromMap(data['error'] as Map);
          notifyUpdateListeners(method, {'error': error});
          break;

        case HMSUpdateListenerMethod.onMessage:
          HMSMessage message = HMSMessage.fromMap(data['message']);
          notifyUpdateListeners(method, {'message': message});
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

          notifyUpdateListeners(method, {'speakers': speakers});
          break;

        case HMSUpdateListenerMethod.onReconnecting:
          notifyUpdateListeners(method, {});
          break;

        case HMSUpdateListenerMethod.onReconnected:
          notifyUpdateListeners(method, {});
          break;

        case HMSUpdateListenerMethod.onRoleChangeRequest:
          HMSRoleChangeRequest? roleChangeRequest =
              HMSRoleChangeRequest.fromMap(data['role_change_request']);
          notifyUpdateListeners(
              method, {'role_change_request': roleChangeRequest});
          break;

        case HMSUpdateListenerMethod.onChangeTrackStateRequest:
          HMSTrackChangeRequest trackChangeRequest =
              HMSTrackChangeRequest.fromMap(
                  data['track_change_request'] as Map);
          notifyUpdateListeners(
              method, {'track_change_request': trackChangeRequest});
          break;

        case HMSUpdateListenerMethod.onRemovedFromRoom:
          HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer =
              HMSPeerRemovedFromPeer.fromMap(data['removed_from_room'] as Map);
          notifyUpdateListeners(
              method, {'removed_from_room': hmsPeerRemovedFromPeer});
          break;
        case HMSUpdateListenerMethod.onAudioDeviceChanged:
          HMSAudioDevice? currentAudioDevice =
              data.containsKey("current_audio_device")
                  ? HMSAudioDeviceValues.getHMSAudioDeviceFromName(
                      data['current_audio_device'])
                  : null;
          List<HMSAudioDevice> availableAudioDevice = [];
          if (data["available_audio_device"] != null)
            for (var device in data["available_audio_device"]) {
              availableAudioDevice
                  .add(HMSAudioDeviceValues.getHMSAudioDeviceFromName(device));
            }

          notifyUpdateListeners(method, {
            'current_audio_device': currentAudioDevice,
            "available_audio_device": data["available_audio_device"] != null
                ? availableAudioDevice
                : null
          });
          break;

        case HMSUpdateListenerMethod.onSessionStoreAvailable:
          notifyUpdateListeners(method, {});
          break;

        case HMSUpdateListenerMethod.unknown:
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

          HMSPeer? localPeer;
          for (var peer in room.peers!) {
            if (peer.isLocal) {
              localPeer = peer;
            }
          }

          List<HMSTrack> tracks = [];
          event.data['local_tracks'].forEach((each) {
            tracks.add(HMSTrack.fromMap(map: each, isLocal: localPeer != null));
          });

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
        case HMSPreviewUpdateListenerMethod.onPeerUpdate:
          HMSPeer? peer = HMSPeer.fromMap(event.data['peer']);
          HMSPeerUpdate? update = HMSPeerUpdateValues.getHMSPeerUpdateFromName(
              event.data['update']);

          notifyPreviewListeners(method, {'peer': peer, 'update': update});
          break;
        case HMSPreviewUpdateListenerMethod.onRoomUpdate:
          HMSRoom? room = event.data['room'] != null
              ? HMSRoom.fromMap(event.data['room'])
              : null;

          HMSRoomUpdate? update = HMSRoomUpdateValues.getHMSRoomUpdateFromName(
              event.data['update']);
          notifyPreviewListeners(method, {'room': room, 'update': update});
          break;
        case HMSPreviewUpdateListenerMethod.onAudioDeviceChanged:
          HMSAudioDevice? currentAudioDevice =
              event.data.containsKey("current_audio_device")
                  ? HMSAudioDeviceValues.getHMSAudioDeviceFromName(
                      event.data['current_audio_device'])
                  : null;
          List<HMSAudioDevice> availableAudioDevice = [];
          if (event.data["available_audio_device"] != null)
            for (var device in event.data["available_audio_device"]) {
              availableAudioDevice
                  .add(HMSAudioDeviceValues.getHMSAudioDeviceFromName(device));
            }

          notifyPreviewListeners(method, {
            'current_audio_device': currentAudioDevice,
            "available_audio_device":
                event.data["available_audio_device"] != null
                    ? availableAudioDevice
                    : null
          });
          break;
      }
    });

    _rtcStatsChannel.receiveBroadcastStream(
        {'name': 'rtc_stats'}).map<HMSStatsListenerMethodResponse>((event) {
      Map<String, dynamic>? data = {};

      if (event is Map && event['data'] is Map) {
        (event['data'] as Map).forEach((key, value) {
          data[key.toString()] = value;
        });
      }

      HMSStatsListenerMethod method =
          HMSStatsListenerMethodValues.getMethodFromName(event['event_name']);
      return HMSStatsListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      HMSStatsListenerMethod method = event.method;
      Map data = event.data;
      switch (method) {
        case HMSStatsListenerMethod.onLocalAudioStats:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSLocalAudioTrack? track =
              HMSLocalAudioTrack.fromMap(map: data['track']);
          HMSLocalAudioStats localAudioStats =
              HMSLocalAudioStats.fromMap(data['local_audio_stats'] as Map);
          notifyStatsListeners(method, {
            'local_audio_stats': localAudioStats,
            "track": track,
            "peer": peer
          });
          break;
        case HMSStatsListenerMethod.onLocalVideoStats:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSLocalVideoTrack? track =
              HMSLocalVideoTrack.fromMap(map: data['track']);
          List<HMSLocalVideoStats> localVideoStats = [];
          for (Map stat in data['local_video_stats']) {
            localVideoStats.add(HMSLocalVideoStats.fromMap(stat));
          }
          notifyStatsListeners(method, {
            'local_video_stats': localVideoStats,
            "track": track,
            "peer": peer
          });
          break;
        case HMSStatsListenerMethod.onRemoteAudioStats:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSRemoteAudioTrack? track =
              HMSRemoteAudioTrack.fromMap(map: data['track']);
          HMSRemoteAudioStats remoteAudioStats =
              HMSRemoteAudioStats.fromMap(data['remote_audio_stats'] as Map);
          notifyStatsListeners(method, {
            'remote_audio_stats': remoteAudioStats,
            "track": track,
            "peer": peer
          });
          break;

        case HMSStatsListenerMethod.onRemoteVideoStats:
          HMSPeer? peer = HMSPeer.fromMap(data['peer']);
          HMSRemoteVideoTrack? track =
              HMSRemoteVideoTrack.fromMap(map: data['track']);
          HMSRemoteVideoStats remoteVideoStats =
              HMSRemoteVideoStats.fromMap(data['remote_video_stats'] as Map);
          notifyStatsListeners(method, {
            'remote_video_stats': remoteVideoStats,
            "track": track,
            "peer": peer
          });
          break;
        case HMSStatsListenerMethod.onRtcStats:
          HMSRTCStatsReport rtcStatsReport =
              HMSRTCStatsReport.fromMap(data['rtc_stats_report'] as Map);
          notifyStatsListeners(method, {'rtc_stats_report': rtcStatsReport});
          break;

        case HMSStatsListenerMethod.unknown:
          break;
      }
    });

    _logsEventChannel.receiveBroadcastStream({'name': 'logs'}).map((event) {
      List<dynamic> data = [];

      HMSLogsUpdateListenerMethod method =
          HMSLogsUpdateListenerMethodValues.getMethodFromName(
              event['event_name']);
      data = event["data"];
      return HMSLogsUpdateListenerMethodResponse(
          method: method, data: data, response: event);
    }).listen((event) {
      HMSLogsUpdateListenerMethod method = event.method;
      List<dynamic> data = event.data;
      switch (method) {
        case HMSLogsUpdateListenerMethod.onLogsUpdate:
          notifyLogsUpdateListeners(method, data);
          break;
        case HMSLogsUpdateListenerMethod.unknown:
          break;
      }
    });

    _sessionStoreChannel
        .receiveBroadcastStream({'name': 'session_store'}).map((event) {
      HMSKeyChangeListenerMethod method =
          HMSKeyChangeListenerMethodValues.getMethodFromName(
              event['event_name']);
      Map data = event['data'];
      return HMSKeyChangeListenerMethodResponse(method: method, data: data);
    }).listen((event) {
      HMSKeyChangeListenerMethod method = event.method;
      switch (method) {
        case HMSKeyChangeListenerMethod.onKeyChanged:
          notifySessionStoreListeners(method, event.data);
          break;
        case HMSKeyChangeListenerMethod.unknown:
          break;
      }
    });

    _hlsPlayerChannel
        .receiveBroadcastStream({'name': 'hls_player'}).map((event) {
      HMSHLSPlaybackEventMethod method =
          HMSHLSPlaybackEventMethodValues.getMethodFromName(
              event['event_name']);
      Map data = event['data'];
      return HMSHLSPlayerPlaybackEventResponse(method: method, data: data);
    }).listen((event) {
      notifyHLSPlaybackEventListeners(event.method, event.data);
    });
  }

  static void notifyLogsUpdateListeners(
      HMSLogsUpdateListenerMethod method, List<dynamic> arguments) {
    switch (method) {
      case HMSLogsUpdateListenerMethod.onLogsUpdate:
        logsListeners.forEach((element) {
          HMSLogList hmsLogList = HMSLogList.fromMap(arguments);
          element.onLogMessage(hmsLogList: hmsLogList);
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
          e.onHMSError(error: arguments["error"]);
        });
        break;
      case HMSPreviewUpdateListenerMethod.unknown:
        break;
      case HMSPreviewUpdateListenerMethod.onPeerUpdate:
        previewListeners.forEach((e) {
          e.onPeerUpdate(peer: arguments['peer'], update: arguments['update']);
        });
        break;
      case HMSPreviewUpdateListenerMethod.onRoomUpdate:
        previewListeners.forEach((e) {
          e.onRoomUpdate(room: arguments['room'], update: arguments['update']);
        });
        break;
      case HMSPreviewUpdateListenerMethod.onAudioDeviceChanged:
        previewListeners.forEach((e) {
          e.onAudioDeviceChanged(
              currentAudioDevice: arguments["current_audio_device"],
              availableAudioDevice: arguments["available_audio_device"]);
        });
        break;
    }
  }

  static void notifyStatsListeners(
      HMSStatsListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSStatsListenerMethod.onLocalAudioStats:
        statsListeners.forEach((e) => e.onLocalAudioStats(
            hmsLocalAudioStats: arguments['local_audio_stats'],
            track: arguments["track"],
            peer: arguments["peer"]));
        break;
      case HMSStatsListenerMethod.onLocalVideoStats:
        statsListeners.forEach((e) => e.onLocalVideoStats(
            hmsLocalVideoStats: arguments['local_video_stats'],
            track: arguments["track"],
            peer: arguments["peer"]));
        break;
      case HMSStatsListenerMethod.onRemoteAudioStats:
        statsListeners.forEach((e) => e.onRemoteAudioStats(
            hmsRemoteAudioStats: arguments['remote_audio_stats'],
            track: arguments["track"],
            peer: arguments["peer"]));
        break;
      case HMSStatsListenerMethod.onRemoteVideoStats:
        statsListeners.forEach((e) => e.onRemoteVideoStats(
            hmsRemoteVideoStats: arguments['remote_video_stats'],
            track: arguments["track"],
            peer: arguments["peer"]));
        break;
      case HMSStatsListenerMethod.onRtcStats:
        statsListeners.forEach((e) =>
            e.onRTCStats(hmsrtcStatsReport: arguments['rtc_stats_report']));
        break;
      case HMSStatsListenerMethod.unknown:
        break;
    }
  }

  ///notifying all updateListeners attached about updates
  static void notifyUpdateListeners(
      HMSUpdateListenerMethod method, Map<String, dynamic> arguments) {
    switch (method) {
      case HMSUpdateListenerMethod.onJoinRoom:
        updateListeners.forEach((e) => e.onJoin(room: arguments['room']));
        break;
      case HMSUpdateListenerMethod.onUpdateRoom:
        updateListeners.forEach((e) => e.onRoomUpdate(
            room: arguments['room'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onPeerUpdate:
        updateListeners.forEach((e) => e.onPeerUpdate(
            peer: arguments['peer'], update: arguments['update']));
        break;
      case HMSUpdateListenerMethod.onTrackUpdate:
        updateListeners.forEach((e) => e.onTrackUpdate(
            track: arguments['track'],
            trackUpdate: arguments['update'],
            peer: arguments['peer']));
        break;
      case HMSUpdateListenerMethod.onError:
        updateListeners.forEach((e) => e.onHMSError(error: arguments['error']));
        break;
      case HMSUpdateListenerMethod.onMessage:
        updateListeners
            .forEach((e) => e.onMessage(message: arguments['message']));
        break;
      case HMSUpdateListenerMethod.onUpdateSpeaker:
        updateListeners.forEach(
            (e) => e.onUpdateSpeakers(updateSpeakers: arguments['speakers']));
        break;
      case HMSUpdateListenerMethod.onReconnecting:
        updateListeners.forEach((e) => e.onReconnecting());
        break;
      case HMSUpdateListenerMethod.onReconnected:
        updateListeners.forEach((e) => e.onReconnected());
        break;
      case HMSUpdateListenerMethod.onRoleChangeRequest:
        updateListeners.forEach((e) => e.onRoleChangeRequest(
            roleChangeRequest: arguments['role_change_request']));
        break;
      case HMSUpdateListenerMethod.onChangeTrackStateRequest:
        updateListeners.forEach((e) => e.onChangeTrackStateRequest(
            hmsTrackChangeRequest: arguments['track_change_request']));
        break;

      case HMSUpdateListenerMethod.onRemovedFromRoom:
        if (updateListeners.isEmpty) break;
        updateListeners.forEach((element) {
          element.onRemovedFromRoom(
              hmsPeerRemovedFromPeer: arguments['removed_from_room']);
        });
        break;

      case HMSUpdateListenerMethod.onAudioDeviceChanged:
        updateListeners.forEach((e) => e.onAudioDeviceChanged(
            currentAudioDevice: arguments["current_audio_device"],
            availableAudioDevice: arguments["available_audio_device"]));
        break;

      case HMSUpdateListenerMethod.onSessionStoreAvailable:
        updateListeners.forEach((e) =>
            e.onSessionStoreAvailable(hmsSessionStore: HMSSessionStore()));
        break;

      case HMSUpdateListenerMethod.unknown:
        break;
    }
  }

  static void notifySessionStoreListeners(
      HMSKeyChangeListenerMethod method, Map arguments) {
    switch (method) {
      case HMSKeyChangeListenerMethod.onKeyChanged:
        int index = keyChangeObservers
            .indexWhere((observer) => observer.uid == arguments["uid"]);
        if (index != -1) {
          keyChangeObservers[index]
              .hmsKeyChangeListener
              .onKeyChanged(key: arguments["key"], value: arguments["value"]);
        }
        break;
      case HMSKeyChangeListenerMethod.unknown:
        break;
    }
  }

  static void notifyHLSPlaybackEventListeners(
      HMSHLSPlaybackEventMethod method, Map arguments) {
    switch (method) {
      case HMSHLSPlaybackEventMethod.onPlaybackFailure:
        hlsPlaybackEventListener
            .forEach((e) => e.onPlaybackFailure(error: arguments["error"]));
        break;
      case HMSHLSPlaybackEventMethod.onPlaybackStateChanged:
        hlsPlaybackEventListener.forEach((e) => e.onPlaybackStateChanged(
            playbackState: HMSHLSPlaybackStateValues.getMethodFromName(
                arguments["playback_state"])));
        break;
      case HMSHLSPlaybackEventMethod.onCue:
        hlsPlaybackEventListener
            .forEach((e) => e.onCue(hlsCue: HMSHLSCue.fromMap(arguments)));
        break;
      case HMSHLSPlaybackEventMethod.onHLSError:
        hlsPlaybackEventListener.forEach(
            (e) => e.onHLSError(hlsException: HMSException.fromMap(arguments)));
        break;
      case HMSHLSPlaybackEventMethod.onHLSEventUpdate:
        hlsPlaybackEventListener.forEach((e) => e.onHLSEventUpdate(
            playerStats: HMSHLSPlayerStats.fromMap(arguments)));
        break;
      case HMSHLSPlaybackEventMethod.unknown:
        break;
    }
  }
}
