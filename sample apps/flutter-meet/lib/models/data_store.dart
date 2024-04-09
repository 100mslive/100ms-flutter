//Dart imports
import 'dart:developer';

//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

//File imports
import 'package:google_meet/services/sdk_initializer.dart';

class UserDataStore extends ChangeNotifier
    implements HMSUpdateListener, HMSActionResultListener {
  HMSTrack? remoteVideoTrack;
  HMSPeer? remotePeer;
  HMSTrack? remoteAudioTrack;
  HMSVideoTrack? localTrack;
  bool _disposed = false;
  late HMSPeer localPeer;
  bool isRoomEnded = false;

  void startListen() {
    SdkInitializer.hmssdk.addUpdateListener(listener: this);
  }

  void leaveRoom() async {
    SdkInitializer.hmssdk.leave(hmsActionResultListener: this);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void onJoin({required HMSRoom room}) {
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        localPeer = each;
        break;
      }
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        remotePeer = peer;
        remoteAudioTrack = peer.audioTrack;
        remoteVideoTrack = peer.videoTrack;
        break;
      case HMSPeerUpdate.peerLeft:
        remotePeer = null;
        break;
      case HMSPeerUpdate.roleUpdated:
        break;
      case HMSPeerUpdate.metadataChanged:
        break;
      case HMSPeerUpdate.nameChanged:
        break;
      case HMSPeerUpdate.defaultUpdate:
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        break;
      case HMSPeerUpdate.handRaiseUpdated:
        break;
    }
    notifyListeners();
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    switch (trackUpdate) {
      case HMSTrackUpdate.trackAdded:
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          if (!peer.isLocal) remoteAudioTrack = track;
        } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          if (!peer.isLocal) {
            remoteVideoTrack = track;
          } else {
            localTrack = track as HMSVideoTrack;
          }
        }
        break;
      case HMSTrackUpdate.trackRemoved:
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          if (!peer.isLocal) remoteAudioTrack = null;
        } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          if (!peer.isLocal) {
            remoteVideoTrack = null;
          } else {
            localTrack = null;
          }
        }
        break;
      case HMSTrackUpdate.trackMuted:
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          if (!peer.isLocal) remoteAudioTrack = track;
        } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          if (!peer.isLocal) {
            remoteVideoTrack = track;
          } else {
            localTrack = null;
          }
        }
        break;
      case HMSTrackUpdate.trackUnMuted:
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          if (!peer.isLocal) remoteAudioTrack = track;
        } else if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
          if (!peer.isLocal) {
            remoteVideoTrack = track;
          } else {
            localTrack = track as HMSVideoTrack;
          }
        }
        break;
      case HMSTrackUpdate.trackDescriptionChanged:
        break;
      case HMSTrackUpdate.trackDegraded:
        break;
      case HMSTrackUpdate.trackRestored:
        break;
      case HMSTrackUpdate.defaultUpdate:
        break;
    }
    notifyListeners();
  }

  @override
  void onHMSError({required HMSException error}) {
    log(error.message ?? "");
  }

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    hmsSessionStore?.setSessionMetadataForKey(
        key: "pinnedMessage", data: "Hey there");
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    if (addedPeers.isNotEmpty) {
      if (!addedPeers[0].isLocal) {
        remotePeer = addedPeers[0];
        remoteAudioTrack = addedPeers[0].audioTrack;
        remoteVideoTrack = addedPeers[0].videoTrack;
        log("User joined: ${addedPeers[0].name}");
      }
    }
  }

  @override
  void onException(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        log("Leave room error ${hmsException.message}");
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        break;
      case HMSActionResultListenerMethod.endRoom:
        break;
      case HMSActionResultListenerMethod.removePeer:
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.changeName:
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        break;
      case HMSActionResultListenerMethod.switchCamera:
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        break;
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.quickStartPoll:
        break;
      case HMSActionResultListenerMethod.addSingleChoicePollResponse:
        break;
      case HMSActionResultListenerMethod.addMultiChoicePollResponse:
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
    }
  }

  @override
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        isRoomEnded = true;
        log("Updated leave");
        notifyListeners();
        break;
      case HMSActionResultListenerMethod.changeTrackState:
        break;
      case HMSActionResultListenerMethod.changeMetadata:
        break;
      case HMSActionResultListenerMethod.endRoom:
        break;
      case HMSActionResultListenerMethod.removePeer:
        break;
      case HMSActionResultListenerMethod.acceptChangeRole:
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeer:
        break;
      case HMSActionResultListenerMethod.changeTrackStateForRole:
        break;
      case HMSActionResultListenerMethod.startRtmpOrRecording:
        break;
      case HMSActionResultListenerMethod.stopRtmpAndRecording:
        break;
      case HMSActionResultListenerMethod.changeName:
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        break;
      case HMSActionResultListenerMethod.sendGroupMessage:
        break;
      case HMSActionResultListenerMethod.sendDirectMessage:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStarted:
        break;
      case HMSActionResultListenerMethod.hlsStreamingStopped:
        break;
      case HMSActionResultListenerMethod.startScreenShare:
        break;
      case HMSActionResultListenerMethod.stopScreenShare:
        break;
      case HMSActionResultListenerMethod.startAudioShare:
        break;
      case HMSActionResultListenerMethod.stopAudioShare:
        break;
      case HMSActionResultListenerMethod.switchCamera:
        break;
      case HMSActionResultListenerMethod.changeRoleOfPeersWithRoles:
        break;
      case HMSActionResultListenerMethod.setSessionMetadataForKey:
        break;
      case HMSActionResultListenerMethod.sendHLSTimedMetadata:
        break;
      case HMSActionResultListenerMethod.lowerLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.lowerRemotePeerHand:
        break;
      case HMSActionResultListenerMethod.raiseLocalPeerHand:
        break;
      case HMSActionResultListenerMethod.quickStartPoll:
        break;
      case HMSActionResultListenerMethod.addSingleChoicePollResponse:
        break;
      case HMSActionResultListenerMethod.addMultiChoicePollResponse:
        break;
      case HMSActionResultListenerMethod.unknown:
        break;
    }
  }
}
