///100ms HMSRoom
///
///To use,import package import `package:hmssdk_flutter/model/hms_room`.
///
///HMSRoom building block around which whole system is made contains all stuff related to room.
///
/// This library depends only on core Dart libraries and the `hms_peer.dart` library.
///
///A [room] is the basic object that 100ms SDKs return on successful connection. This contains references to peers, tracks and everything you need to render a live a/v app.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_browser_recording_state.dart';

import 'package:hmssdk_flutter/src/model/hms_server_recording_state.dart';

import 'hms_rtmp_streaming_state.dart';

class HMSRoom {
  ///[id] of the room
  String? id;
  String? name;
  String? metaData;
  HMSPeer hmsLocalPeer;
  HMSBrowserRecordingState? hmsBrowserRecordingState;
  HMSRtmpStreamingState? hmsRtmpStreamingState;
  HMSServerRecordingState? hmsServerRecordingState;

  ///[peers] list which are in the room.
  final List<HMSPeer>? peers;

  HMSRoom(
      {this.id,
      this.name,
      required this.peers,
      this.metaData,
      required this.hmsLocalPeer,
      this.hmsServerRecordingState,
      this.hmsRtmpStreamingState,
      this.hmsBrowserRecordingState});

  factory HMSRoom.fromMap(Map map) {
    List<HMSPeer> peers = [];
    print("${map} MAP");
    if (map.containsKey('peers') && map['peers'] is List) {
      for (var each in (map['peers'] as List)) {
        try {
          HMSPeer peer = HMSPeer.fromMap(each);
          peers.add(peer);
        } catch (e) {
          print(e);
        }
      }
    }

    return HMSRoom(
        hmsBrowserRecordingState: map["browser_recording_state"] != null
            ? HMSBrowserRecordingState.fromMap(map["browser_recording_state"])
            : null,
        hmsRtmpStreamingState: map["rtmp_streaming_state"] != null
            ? HMSRtmpStreamingState.fromMap(map["rtmp_streaming_state"])
            : null,
        hmsServerRecordingState: map["server_recording_state"] != null
            ? HMSServerRecordingState.fromMap(map["server_recording_state"])
            : null,
        id: map['id'],
        name: map['name'],
        peers: peers,
        metaData: map['meta_data'],
        hmsLocalPeer: HMSPeer.fromMap(
          map["local_peer"],
        ));
  }

  @override
  String toString() {
    return 'HMSRoom{id: $id, name: $name, metaData: $metaData, hmsLocalPeer: $hmsLocalPeer, hmsBrowserRecordingState: $hmsBrowserRecordingState, hmsRtmpStreamingState: $hmsRtmpStreamingState, hmsServerRecordingState: $hmsServerRecordingState, peers: $peers}';
  }
}
