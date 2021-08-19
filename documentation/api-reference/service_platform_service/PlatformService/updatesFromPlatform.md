


# updatesFromPlatform method




    *[<Null safety>](https://dart.dev/null-safety)*




void updatesFromPlatform
()





<p>recieves all the meeting updates here as streams</p>



## Implementation

```dart
static void updatesFromPlatform() {
  _meetingEventChannel.receiveBroadcastStream(
      {'name': 'meeting'}).map<HMSUpdateListenerMethodResponse>((event) {
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
    HMSUpdateListenerMethod method = event.method;
    Map data = event.data;
    switch (method) {
      case HMSUpdateListenerMethod.onJoinRoom:
        HMSRoom? room = HMSRoom.fromMap(data['room']);
        notifyMeetingListeners(method, {'room': room});
        break;
      case HMSUpdateListenerMethod.onUpdateRoom:
        HMSRoom? room = HMSRoom.fromMap(data['room']);
        HMSRoomUpdate? update =
            HMSRoomUpdateValues.getHMSRoomUpdateFromName(data['update']);
        notifyMeetingListeners(method, {'room': room, 'update': update});
        break;
      case HMSUpdateListenerMethod.onPeerUpdate:
        HMSPeer? peer = HMSPeer.fromMap(data['peer']);
        HMSPeerUpdate? update =
            HMSPeerUpdateValues.getHMSPeerUpdateFromName(data['update']);
        notifyMeetingListeners(method, {'peer': peer, 'update': update});
        break;
      case HMSUpdateListenerMethod.onTrackUpdate:
        HMSPeer? peer = HMSPeer.fromMap(event.data['peer']);
        HMSTrack? track = HMSTrack.fromMap(map: data['track'], peer: peer);
        HMSTrackUpdate? update =
            HMSTrackUpdateValues.getHMSTrackUpdateFromName(data['update']);

        notifyMeetingListeners(
            method, {'track': track, 'peer': peer, 'update': update});
        break;
      case HMSUpdateListenerMethod.onError:

        HMSError error = HMSError.fromMap(data['error'] as Map);
        notifyMeetingListeners(method, {'error': error});
        break;
      case HMSUpdateListenerMethod.onMessage:
        HMSMessage message = HMSMessage.fromMap(data['message']);
        notifyMeetingListeners(method, {'message': message});
        break;
      case HMSUpdateListenerMethod.onUpdateSpeaker:
        List<HMSSpeaker> speakers = [];
        if (data.containsKey('speakers') && data['speakers'] is List) {
          (data['speakers'] as List)
              .map((e) => speakers.add(HMSSpeaker.fromMap(e)));
        }
        notifyMeetingListeners(method, {'speakers': speakers});
        break;
      case HMSUpdateListenerMethod.onReconnecting:
        notifyMeetingListeners(method, {});
        break;
      case HMSUpdateListenerMethod.onReconnected:
        notifyMeetingListeners(method, {});
        break;
      case HMSUpdateListenerMethod.onRoleChangeRequest:
        HMSRoleChangeRequest roleChangeRequest =
            HMSRoleChangeRequest.fromMap(data['role_change_request']);
        notifyMeetingListeners(
            method, {'role_change_request': roleChangeRequest});
        break;
      case HMSUpdateListenerMethod.unknown:
        print('Unknown method called');
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
        HMSError? error = HMSError.fromMap(event.data["error"] as Map);
        notifyPreviewListeners(method, {'error':error});
        break;
      case HMSPreviewUpdateListenerMethod.unknown:
        break;
    }
  });
}
```







