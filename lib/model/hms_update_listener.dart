import 'package:hmssdk_flutter/enum/hms_peer_update.dart';
import 'package:hmssdk_flutter/enum/hms_room_update.dart';
import 'package:hmssdk_flutter/enum/hms_track_update.dart';
import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_message.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_role_change_request.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_speaker.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';

abstract class HMSUpdateListener {
  void onJoin({required HMSRoom room});

  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer});

  void onError({required HMSError error});

  void onMessage({required HMSMessage message});

  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});

  void onReconnecting();

  void onReconnected();
}
