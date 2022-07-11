import 'dart:io';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/manager/hms_sdk_manager.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../hmssdk_flutter.dart';

/// The public interface of 100ms SDK. Create an instance of HMSSDK to start using the SDK.
///
/// **Key Concepts**
///
/// **Room** - A room represents a real-time audio, video session, the basic building block of the 100mslive Video SDK
///
/// **Track** - A track represents either the audio or video that makes up a stream
///
/// **Peer** - A peer represents all participants connected to a room. Peers can be "local" or "remote"
///
/// **Broadcast** - A local peer can send any message/data to all remote peers in the room
///
/// HMSSDK has other methods which the client app can use to get more info about the Room, Peer and Tracks
///

class HMSSDK {
  HMSSDK({this.hmsTrackSetting, this.appGroup, this.preferredExtension});

  /// The build function should be called after creating an instance of the [HMSSDK].
  /// Await the result & if true then create [HMSConfig] object to join or preview a room.
  Future<bool> build() async {
    return await HmsSdkManager()
        .createHMSSdk(hmsTrackSetting, appGroup, preferredExtension);
  }

  ///add MeetingListener it will add all the listeners.
  void addUpdateListener({required HMSUpdateListener listener}) {
    PlatformService.addUpdateListener(listener);
  }

  void addStatsListener({required HMSStatsListener listener}) {
    PlatformService.addRTCStatsListener(listener);
  }

  void removeStatsListener({required HMSStatsListener listener}) {
    PlatformService.removeRTCStatsListener(listener);
  }

  /// Join the room with configuration options passed as a [HMSConfig] object
  dynamic join({
    required HMSConfig config,
  }) async {
    if (previewState) {
      return HMSException(
          message: "Preview in progress",
          description: "Preview in progress",
          action: "PREVIEW",
          isTerminal: false,
          params: {...config.getJson()});
    }
    return await PlatformService.invokeMethod(PlatformMethod.join,
        arguments: {...config.getJson()});
  }

  ///add one or more previewListeners.
  void addPreviewListener({required HMSPreviewListener listener}) {
    PlatformService.addPreviewListener(listener);
  }

  /// Begin a preview so that the local peer's audio and video can be displayed to them before they join a call.
  /// The details of the call they want to join is passed using [HMSConfig]. This may affect whether they are allowed to publish audio or video at all.
  Future<void> preview({
    required HMSConfig config,
  }) async {
    previewState = true;
    await PlatformService.invokeMethod(PlatformMethod.preview, arguments: {
      ...config.getJson(),
    });
    previewState = false;
    return null;
  }

  /// Call this method to leave the room
  /// [HMSActionResultListener] callback will be used by SDK to inform application if there was a success or failure when the leave was executed
  void leave({HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.leave);
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.leave);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.leave,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  /// To switch local peer's audio on/off.
  /// Pass bool value to [isOn] to change current audio status
  Future<HMSException?> switchAudio({bool isOn = false}) async {
    bool result = await PlatformService.invokeMethod(PlatformMethod.switchAudio,
        arguments: {'is_on': isOn});

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Switch Audio failed",
          description: "Cannot toggle audio status",
          action: "AUDIO",
          isTerminal: false,
          params: {'is_on': isOn});
    }
  }

  /// To switch local peer's video on/off.
  /// Pass bool value to [isOn] to change current video status
  Future<HMSException?> switchVideo({bool isOn = false}) async {
    bool result = await PlatformService.invokeMethod(PlatformMethod.switchVideo,
        arguments: {'is_on': isOn});

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Switch Video failed",
          description: "Cannot toggle video status",
          action: "VIDEO",
          params: {'is_on': isOn},
          isTerminal: false);
    }
  }

  /// Switch camera to front or rear mode
  Future<void> switchCamera() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
  }

  /// To start capturing the local peer's video & send it to other peer's in the room
  Future<bool> startCapturing() async {
    return await PlatformService.invokeMethod(PlatformMethod.startCapturing);
  }

  /// To stop capturing the local peer's video.
  Future<bool> stopCapturing() async {
    return await PlatformService.invokeMethod(PlatformMethod.stopCapturing);
  }

  /// To check the audio status of a peer is mute/unmute
  /// Pass in the [peer] object for the peer whose audio status you want to check
  Future<bool> isAudioMute({HMSPeer? peer}) async {
    return await PlatformService.invokeMethod(PlatformMethod.isAudioMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
  }

  /// To check the video status of a peer is mute/unmute
  /// Pass in the [peer] object for the peer whose video status you want to check
  Future<bool> isVideoMute({HMSPeer? peer}) async {
    return await PlatformService.invokeMethod(PlatformMethod.isVideoMute,
        arguments: {"peer_id": peer != null ? peer.peerId : "null"});
  }

  /// To mute audio of all peers in the room for yourself
  /// Audio from other peers will be stopped for the local peer after invoking [muteAll]
  /// Note: Other peers can still listen each other in the room, just you (the local peer) won't listen any audio from the peers in the room
  Future<void> muteAll() async {
    return await PlatformService.invokeMethod(PlatformMethod.muteAll);
  }

  /// To unmute audio of all peers in the room for yourself if you had previously invoked [muteAll]
  Future<void> unMuteAll() async {
    return await PlatformService.invokeMethod(PlatformMethod.unMuteAll);
  }

  /// To mute/umute video of all peers in the room for yourself. Use the [allow] bool to toggle the status
  /// Video from other peers will be stopped for the local peer after invoking [setPlayBackAllowed] with [allow] as false
  /// Note: Other peers can still see each other in the room, just you (the local peer) won't see any video from the peers in the room
  Future<void> setPlayBackAllowed({required bool allow}) async {
    return await PlatformService.invokeMethod(PlatformMethod.setPlayBackAllowed,
        arguments: {"allowed": allow});
  }

  /// Get the [HMSRoom] room object which the local peer has currently joined. Returns nil if no room is joined.
  Future<HMSRoom?> getRoom() async {
    var hmsRoomMap = await PlatformService.invokeMethod(PlatformMethod.getRoom);
    if (hmsRoomMap == null) return null;
    return HMSRoom.fromMap(hmsRoomMap);
  }

  /// Returns an instance of the local peer if one existed. A local peer only exists during a preview and an active call.
  Future<HMSLocalPeer?> getLocalPeer() async {
    return HMSLocalPeer.fromMap(
        await PlatformService.invokeMethod(PlatformMethod.getLocalPeer) as Map);
  }

  /// Returns only remote peers. The peer's own instance will not be included in this. To get all peers including the local one consider getPeers or for only the local one consider getLocalPeer.
  Future<List<HMSPeer>?> getRemotePeers() async {
    List peers =
        await PlatformService.invokeMethod(PlatformMethod.getRemotePeers);

    List<HMSPeer> listOfRemotePeers = [];
    peers.forEach((element) {
      listOfRemotePeers.add(HMSPeer.fromMap(element as Map));
    });
    return listOfRemotePeers;
  }

  /// Returns all peers, remote and local.
  Future<List<HMSPeer>?> getPeers() async {
    List peers = await PlatformService.invokeMethod(PlatformMethod.getPeers);

    List<HMSPeer> listOfPeers = [];
    peers.forEach((element) {
      listOfPeers.add(HMSPeer.fromMap(element as Map));
    });
    return listOfPeers;
  }

  /// Sends a message to everyone in the call. [message] contains the content of the message.
  /// The [hmsActionResultListener] informs about whether the message was successfully sent, or the kind of error if not.
  void sendBroadcastMessage(
      {required String message,
      String? type,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {"message": message, "type": type};
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendBroadcastMessage,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result != null && result["error"] != null) {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.sendBroadcastMessage,
            arguments: arguments,
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.sendBroadcastMessage,
            arguments: arguments);
      }
    }
  }

  /// Sends a message to all the peers of a role defined in [roleName]. All peers currently with that role will receive the message.
  /// [message] contains the content of the message.
  /// The [hmsActionResultListener] informs about whether the message was successfully sent, or the kind of error if not.
  void sendGroupMessage(
      {required String message,
      required List<HMSRole> hmsRolesTo,
      String? type,
      HMSActionResultListener? hmsActionResultListener}) async {
    List<String> rolesMap = [];
    hmsRolesTo.forEach((role) => rolesMap.add(role.name));

    var arguments = {"message": message, "type": type, "roles": rolesMap};
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendGroupMessage,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result != null && result["error"] != null) {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.sendGroupMessage,
            arguments: {"message": message, "type": type, "roles": hmsRolesTo},
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.sendGroupMessage,
            arguments: {"message": message, "type": type, "roles": hmsRolesTo});
      }
    }
  }

  /// Sends a message a particular peer only. The one specified in [peer].
  /// [message] contains the content of the message.
  /// The [hmsActionResultListener] informs about whether the message was successfully sent, or the kind of error if not.
  void sendDirectMessage(
      {required String message,
      required HMSPeer peerTo,
      String? type,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {
      "message": message,
      "peer_id": peerTo.peerId,
      "type": type
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendDirectMessage,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result != null && result["error"] != null) {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.sendDirectMessage,
            arguments: {"message": message, "peer": peerTo, "type": type},
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.sendDirectMessage,
            arguments: {"message": message, "peer": peerTo, "type": type});
      }
    }
  }

  /// Returns all the [HMSRole] roles possible in the room
  Future<List<HMSRole>> getRoles() async {
    List<HMSRole> roles = [];
    var result = await PlatformService.invokeMethod(PlatformMethod.getRoles);
    if (result is Map && result.containsKey('roles')) {
      if (result['roles'] is List) {
        for (var each in (result['roles'] as List)) {
          HMSRole role = HMSRole.fromMap(each);
          roles.add(role);
        }
      }
    }
    return roles;
  }

  /// Requests a change of HMSRole to a new role.
  /// The [peer] HMSPeer whose role should be requested to be changed.
  /// The [roleName] new role the HMSPeer would have if they accept or are forced to change to.
  /// Set [forceChange] to false if the peer should be requested to accept the new role (they can choose to deny). Set [forceChange] to true if their role should be changed without asking them.
  /// [hmsActionResultListener] - Listener that will return HMSActionResultListener.onSuccess if the role change request is successful else will call [HMSActionResultListener.onException] with the error received from server
  void changeRole(
      {required HMSPeer forPeer,
      required HMSRole toRole,
      bool force = false,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {
      'peer_id': forPeer.peerId,
      'role_name': toRole.name,
      'force_change': force
    };
    var result = await PlatformService.invokeMethod(PlatformMethod.changeRole,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.changeRole,
            arguments: {
              'peer': forPeer,
              'role_name': toRole,
              'force_change': force
            });
      else
        hmsActionResultListener.onException(
            arguments: {
              'peer': forPeer,
              'role_name': toRole,
              'force_change': force
            },
            methodType: HMSActionResultListenerMethod.changeRole,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  ///accept the change role request
  /// When a peer is requested to change their role (see [changeRole]) to accept the new role this has to be called. Once this method is called, the peer's role will be changed to the requested one. The HMSRoleChangeRequest that the SDK had sent to this peer (in HMSUpdateListener.onRoleChangeRequest) to inform them that a role change was requested.
  /// [hmsActionResultListener] - Listener that will return HMSActionResultListener.onSuccess if the role change request is successful else will call HMSActionResultListener.onException with the error received from server

  void acceptChangeRole(
      {required HMSRoleChangeRequest hmsRoleChangeRequest,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.acceptChangeRole);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.acceptChangeRole);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.acceptChangeRole,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// To change the mute status of a single remote peer's track
  /// Set [mute] to true if the track needs to be muted, false otherwise.
  /// [hmsActionResultListener] - the callback that would be called by SDK in case of a success or failure.
  void changeTrackState(
      {required HMSTrack forRemoteTrack,
      required bool mute,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {
      "track_id": forRemoteTrack.trackId,
      "mute": mute,
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeTrackState,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(arguments: {
          "track": forRemoteTrack,
          "mute": mute,
        }, methodType: HMSActionResultListenerMethod.changeTrackState);
      else
        hmsActionResultListener.onException(
            arguments: {
              "track": forRemoteTrack,
              "mute": mute,
            },
            methodType: HMSActionResultListenerMethod.changeTrackState,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// To change the mute status of one or many remote HMSTrack for all peers of a particular role, or all tracks of a particular source, type or source AND type.
  /// Set [mute] true if the track needs to be muted, false otherwise
  /// [type] is the HMSTrackType which should be affected. If this and source are specified, it is considered an AND operation. If not specified, all track sources are affected.
  /// [source] is the HMSTrackSource which should be affected. If this and type are specified, it is considered an AND operation. If not specified, all track types are affected.
  /// [roles] is a list of roles, may have a single item in a list, whose tracks should be affected. If not specified, all roles are affected.
  /// [hmsActionResultListener] - the callback that would be called by SDK in case of a success or failure.
  void changeTrackStateForRole(
      {required bool mute,
      required HMSTrackKind? kind,
      required String? source,
      required List<HMSRole>? roles,
      HMSActionResultListener? hmsActionResultListener}) async {
    List<String> rolesMap = [];

    if (roles != null) roles.forEach((role) => rolesMap.add(role.name));

    var arguments = {
      "mute": mute,
      "type": HMSTrackKindValue.getValueFromHMSTrackKind(
          kind ?? HMSTrackKind.unknown),
      "source": source,
      "roles": roles == null ? roles : rolesMap
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeTrackStateForRole,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(arguments: {
          "mute": mute,
          "type": HMSTrackKindValue.getValueFromHMSTrackKind(
              kind ?? HMSTrackKind.unknown),
          "source": source,
          "roles": roles
        }, methodType: HMSActionResultListenerMethod.changeTrackStateForRole);
      else
        hmsActionResultListener.onException(
            arguments: {
              "mute": mute,
              "type": HMSTrackKindValue.getValueFromHMSTrackKind(
                  kind ?? HMSTrackKind.unknown),
              "source": source,
              "roles": roles
            },
            methodType: HMSActionResultListenerMethod.changeTrackStateForRole,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// Removes the given peer from the room
  /// A [reason] string will be shown to them.
  /// [hmsActionResultListener] is the callback that would be called by SDK in case of a success or failure
  void removePeer(
      {required HMSPeer peer,
      required String reason,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {"peer_id": peer.peerId, "reason": reason};
    var result = await PlatformService.invokeMethod(PlatformMethod.removePeer,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            arguments: {"peer": peer, "reason": reason},
            methodType: HMSActionResultListenerMethod.removePeer);
      } else {
        hmsActionResultListener.onException(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.removePeer,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  /// Remove all the peers from the room & end the room.
  /// [reason] is the reason why the room is being ended.
  /// [lock] bool is whether rejoining the room should be disabled for the foreseeable future.
  /// [hmsActionResultListener] is the callback that would be called by SDK in case of a success or failure

  void endRoom(
      {required bool lock,
      required String reason,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {"lock": lock, "reason": reason};
    var result = await PlatformService.invokeMethod(PlatformMethod.endRoom,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.endRoom,
            arguments: arguments);
      } else {
        hmsActionResultListener.onException(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.endRoom,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  /// Starts rtmp streaming or recording on the parameters described in config.
  /// [config] is the HMSRecordingConfig which defines streaming/recording parameters for this start request.
  /// [hmsActionResultListener] is the callback that would be called by SDK in case of a success or failure.
  void startRtmpOrRecording(
      {required HMSRecordingConfig hmsRecordingConfig,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = hmsRecordingConfig.getJson();
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startRtmpOrRecording,
        arguments: arguments) as Map?;

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.startRtmpOrRecording);
      else
        hmsActionResultListener.onException(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.startRtmpOrRecording,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// Stops a previously started rtmp recording or stream. See startRtmpOrRecording for starting.
  /// [hmsActionResultListener] is the callback that would be called by SDK in case of a success or failure.

  void stopRtmpAndRecording(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopRtmpAndRecording);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.stopRtmpAndRecording);
      else
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.stopRtmpAndRecording,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// Starts HLS streaming for the [meetingUrl] room.
  /// You can set a custom [metadata] for the HLS Stream
  /// [hmsActionResultListener] is callback whose [HMSActionResultListener.onSuccess] will be called when the the action completes successfully.
  void startHlsStreaming(
      {required HMSHLSConfig hmshlsConfig,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startHlsStreaming,
        arguments: hmshlsConfig.toMap());
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.hlsStreamingStarted);
      else
        hmsActionResultListener.onException(
            hmsException: HMSException.fromMap(result["error"]),
            methodType: HMSActionResultListenerMethod.hlsStreamingStarted);
    }
  }

  /// Stops ongoing HLS streaming in the room
  /// [hmsActionResultListener] is callback whose [HMSActionResultListener.onSuccess] will be called when the the action completes successfully.
  void stopHlsStreaming(
      {HMSHLSConfig? hmshlsConfig,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.stopHlsStreaming,
        arguments: hmshlsConfig != null ? hmshlsConfig.toMap() : null);
    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.hlsStreamingStopped);
      else
        hmsActionResultListener.onException(
            hmsException: HMSException.fromMap(result["error"]),
            methodType: HMSActionResultListenerMethod.hlsStreamingStopped);
    }
  }

  /// Change the metadata that appears inside [HMSPeer.metadata]. This change is persistent and all peers joining after the change will still see these values.
  /// [metadata] is the string data to be set now
  /// [hmsActionResultListener] is callback whose [HMSActionResultListener.onSuccess] will be called when the the action completes successfully.
  void changeMetadata(
      {required String metadata,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {"metadata": metadata};
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeMetadata,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.changeMetadata);
      else
        hmsActionResultListener.onException(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.changeMetadata,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  ///Method to change name of localPeer
  /// Change the name that appears inside [HMSPeer.name] This change is persistent and all peers joining after the change will still see these values.
  /// [name] is the string which is to be set as the [HMSPeer.name]
  /// [hmsActionResultListener] is the callback whose [HMSActionResultListener.onSuccess] will be called when the the action completes successfully.
  void changeName(
      {required String name,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {"name": name};
    var result = await PlatformService.invokeMethod(PlatformMethod.changeName,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.changeName);
      else
        hmsActionResultListener.onException(
            arguments: arguments,
            methodType: HMSActionResultListenerMethod.changeName,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  /// API to start screen share of your android device. Note: This API is not available on iOS.
  /// [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess]
  ///  and [HMSActionResultListener.onException] will be called
  /// [preferredExtension] is only used for screen share (broadcast screen) in iOS.
  void startScreenShare(
      {HMSActionResultListener? hmsActionResultListener}) async {
    HMSLocalPeer? localPeer = await getLocalPeer();
    if (localPeer?.role.publishSettings?.allowed.contains("screen") ?? false) {
      var result =
          await PlatformService.invokeMethod(PlatformMethod.startScreenShare);

      if (hmsActionResultListener != null) {
        if (result == null) {
          hmsActionResultListener.onSuccess(
              methodType: HMSActionResultListenerMethod.startScreenShare);
        } else {
          hmsActionResultListener.onException(
              methodType: HMSActionResultListenerMethod.startScreenShare,
              hmsException: HMSException.fromMap(result["error"]));
        }
      }
    } else {
      if (hmsActionResultListener != null) {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.startScreenShare,
            hmsException: HMSException(
                message: "Permission denied",
                description: "Screen share is not included in publish settings",
                action: "Enable screen share from dashboard for current role",
                isTerminal: false));
      }
    }
  }

  /// A method to check if the screen share is currently active on device i.e. is this Android device doing screen share. Note: This API is not available on iOS.
  Future<bool> isScreenShareActive() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.isScreenShareActive,
    );
  }

  /// API to stop screen share
  /// [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess]
  ///  and [HMSActionResultListener.onException] will be called
  void stopScreenShare(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopScreenShare);
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.stopScreenShare);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.stopScreenShare,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  ///remove a update listener
  void removeUpdateListener({required HMSUpdateListener listener}) {
    PlatformService.removeUpdateListener(listener);
  }

  ///remove a preview listener
  void removePreviewListener({required HMSPreviewListener listener}) {
    PlatformService.removePreviewListener(listener);
  }

  ///Method to start HMSLogger for logs
  void startHMSLogger(
      {required HMSLogLevel webRtclogLevel, required HMSLogLevel logLevel}) {
    PlatformService.invokeMethod(PlatformMethod.startHMSLogger, arguments: {
      "web_rtc_log_level":
          HMSLogLevelValue.getValueFromHMSLogLevel(webRtclogLevel),
      "log_level": HMSLogLevelValue.getValueFromHMSLogLevel(logLevel)
    });
  }

  ///Method to remove attached HMSLogger
  void removeHMSLogger() {
    PlatformService.invokeMethod(PlatformMethod.removeHMSLogger);
  }

  ///Method to add Log Listener to listen to the logs
  void addLogListener({required HMSLogListener hmsLogListener}) {
    PlatformService.addLogsListener(hmsLogListener);
  }

  ///Method to remove Log Listener
  void removeLogListener({required HMSLogListener hmsLogListener}) {
    PlatformService.removeLogsListener(hmsLogListener);
  }

  ///Method to get available audio devices(Android Only)
  Future<List<HMSAudioDevice>> getAudioDevicesList() async {
    if (Platform.isAndroid) {
      List result = await PlatformService.invokeMethod(
          PlatformMethod.getAudioDevicesList);
      return result
          .map((e) => HMSAudioDeviceValues.getHMSAudioDeviceFromName(e))
          .toList();
    }
    return [];
  }

  ///Method to get current audio output device(Android Only)
  Future<HMSAudioDevice> getCurrentAudioDevice() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.getCurrentAudioDevice);
      return HMSAudioDeviceValues.getHMSAudioDeviceFromName(result);
    }
    return HMSAudioDevice.UNKNOWN;
  }

  ///Method to switch audio output device(Android Only)
  void switchAudioOutput(HMSAudioDevice audioDevice) {
    if (Platform.isAndroid)
      PlatformService.invokeMethod(PlatformMethod.switchAudioOutput,
          arguments: {"audio_device_name": audioDevice.name});
  }

  /// To modify local peer's audio & video track settings use the [hmsTrackSetting]. Only required for advanced use-cases.
  HMSTrackSetting? hmsTrackSetting;

  /// [appGroup] is only used for screen share (broadcast screen) in iOS.
  String? appGroup;

  /// [preferredExtension] is only used for screen share (broadcast screen) in iOS.
  String? preferredExtension;

  bool previewState = false;
}
