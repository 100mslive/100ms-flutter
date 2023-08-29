import 'dart:io';

import 'package:hmssdk_flutter/src/manager/hms_sdk_manager.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';
import '../hmssdk_flutter.dart';

/// The public interface of 100ms SDK. Create an instance of HMSSDK to start using the SDK.
///
/// Parameters:
///
/// **hmsTrackSetting** - To modify local peer's audio & video tracks settings. Only required for advanced use cases. Refer [hmsTrackSetting guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/set-track-settings)
///
/// **iOSScreenshareConfig** - It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
///
/// **hmsLogSettings** - It is used to set the Log Level setting. Refer [hmsLogSettings guide here](https://www.100ms.live/docs/flutter/v2/features/error-handling#setting-log-levels-in-sdk)
///
/// **appGroup[Deprecated]** - It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
///
/// **preferredExtension[Deprecated]** - It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
///
/// `Note: [appGroup] and [preferredExtension] are deprecated use iOSScreenshareConfig instead.`
///
/// **Key Concepts**
///
/// **Room** - A room represents real-time audio, and video sessions, the basic building block of the 100mslive Video SDK
///
/// **Track** - A track represents either the audio or video that makes up a stream
///
/// **Peer** - A peer represents all participants connected to a room. Peers can be "local" or "remote"
///
/// **Broadcast** - A local peer can send any message/data to all remote peers in the room
///
/// HMSSDK has other methods which the client app can use to get more info about the Room, Peer and Tracks
///
/// Refer [HMSSDK quick start guide available here](https://www.100ms.live/docs/flutter/v2/guides/quickstart)

class HMSSDK {
  /// The public interface of 100ms SDK. Create an instance of HMSSDK to start using the SDK.
  ///
  /// Parameters:
  ///
  /// **hmsTrackSetting** - To modify local peer's audio & video tracks settings. Only required for advanced use cases. Refer [hmsTrackSetting guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/set-track-settings)
  ///
  /// **iOSScreenshareConfig** - It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
  ///
  /// **hmsLogSettings** - It is used to set the Log Level setting. Refer [hmsLogSettings guide here](https://www.100ms.live/docs/flutter/v2/features/error-handling#setting-log-levels-in-sdk)
  ///
  /// **appGroup[Deprecated]** -  It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
  ///
  /// **preferredExtension[Deprecated]** - It is required for starting Screen share (broadcast screen) in iOS. Refer [iOS Screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
  ///
  /// `Note: [appGroup] and [preferredExtension] are deprecated use iOSScreenshareConfig instead.`
  ///
  /// **Key Concepts**
  ///
  /// **Room** - A room represents real-time audio, and video sessions, the basic building block of the 100mslive Video SDK
  ///
  /// **Track** - A track represents either the audio or video that makes up a stream
  ///
  /// **Peer** - A peer represents all participants connected to a room. Peers can be "local" or "remote"
  ///
  /// **Broadcast** - A local peer can send any message/data to all remote peers in the room
  ///
  /// HMSSDK has other methods which the client app can use to get more info about the Room, Peer and Tracks
  ///
  /// Refer [HMSSDK quick start guide available here](https://www.100ms.live/docs/flutter/v2/guides/quickstart)
  HMSSDK(
      {this.hmsTrackSetting,
      this.iOSScreenshareConfig,
      this.hmsLogSettings,
      @Deprecated("Use iOSScreenshareConfig") this.appGroup,
      @Deprecated("Use iOSScreenshareConfig") this.preferredExtension,
      this.isPrebuilt = false});

  /// The build function should be called after creating an instance of the [HMSSDK].
  ///
  /// Await the result & if true then create [HMSConfig] object to join or preview a room.
  Future<void> build() async {
    await HmsSdkManager().createHMSSdk(hmsTrackSetting, iOSScreenshareConfig,
        appGroup, preferredExtension, hmsLogSettings, isPrebuilt);
  }

  ///[getAuthTokenByRoomCode] is used to get the authentication token to join the room
  ///using room codes.
  ///
  ///This returns an object of Future<dynamic> which can be either
  ///of HMSException type or String type based on whether
  ///method execution is completed successfully or not
  ///To know more about the implementation checkout [getAuthTokenByRoomCode](https://www.100ms.live/docs/flutter/v2/get-started/quickstart#fetch-token-using-room-code-methodrecommended)
  Future<dynamic> getAuthTokenByRoomCode(
      {required String roomCode, String? userId, String? endPoint}) async {
    var arguments = {
      "room_code": roomCode,
      "user_id": userId,
      "end_point": endPoint
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.getAuthTokenByRoomCode,
        arguments: arguments);

    //If the method is executed successfully we get the "success":"true"
    //Hence we pass the String directly
    //Else we parse it with HMSException
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///[getRoomLayout] is used to get the layout themes for the room
  /// set in the dashboard.
  ///
  ///This returns an object of Future<dynamic> which can be either
  ///of HMSException type or a Json String type based on whether
  ///method execution is completed successfully or not.
  Future<dynamic> getRoomLayout(
      {required String authToken, String? endPoint}) async {
    var arguments = {"auth_token": authToken, "endpoint": endPoint};
    var result = await PlatformService.invokeMethod(
        PlatformMethod.getRoomLayout,
        arguments: arguments);

    //If the method is executed successfully we get the "success":"true"
    //Hence we pass the String directly
    //Else we parse it with HMSException
    if (result["success"]) {
      return result["data"];
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  ///add UpdateListener it will add all the listeners.
  ///
  ///HMSSDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing HMSUpdateListener.
  ///
  /// Implement this listener in a class where you want to perform UI Actions, update App State, etc. These updates can be used to render the video on screen or to display other info regarding the room.
  ///
  /// Depending on your use case, you'll need to implement specific methods of the Update Listener. The most common ones are onJoin, onPeerUpdate, onTrackUpdate & onHMSError.
  void addUpdateListener({required HMSUpdateListener listener}) {
    PlatformService.addUpdateListener(listener);
  }

  /// Join the room with configuration options passed as an [HMSConfig] object.
  /// Refer [Join Room guide here](https://www.100ms.live/docs/flutter/v2/features/join).
  Future<dynamic> join({
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
  ///
  ///[HMSPreviewListener] listens to updates when you preview.
  ///
  ///Just implement it and get the preview updates.
  ///
  ///Check out the [Sample App](https://github.com/100mslive/100ms-flutter/blob/main/example/lib/preview/preview_store.dart) how we are using it.

  void addPreviewListener({required HMSPreviewListener listener}) {
    PlatformService.addPreviewListener(listener);
  }

  /// Begin a preview so that the local peer's audio and video can be displayed to them before they join a call.
  /// The details of the call they want to join are passed using [HMSConfig]. This may affect whether they are allowed to publish audio or video at all.
  ///
  /// Refer [Preview guide here](https://www.100ms.live/docs/flutter/v2/features/preview).
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
  /// [HMSActionResultListener] callback will be used by SDK to inform the application if there was a success or failure when the leave was executed
  ///
  /// Refer [leave guide here](https://www.100ms.live/docs/flutter/v2/features/leave).
  Future<void> leave({HMSActionResultListener? hmsActionResultListener}) async {
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
  /// Pass the bool value to [isOn] to change the current audio status
  ///
  /// Refer [switch audio guide here](https://www.100ms.live/docs/flutter/v2/features/mute).
  @Deprecated('Use [toggleMicMuteState]')
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

  /// To switch local peer's audio on/off.
  /// This function toggles the current microphone state i.e
  /// If it's unmuted it will get muted
  /// If it's muted it will get unmuted
  /// Refer [toggle microphone state guide here](https://www.100ms.live/docs/flutter/v2/features/mute).
  Future<HMSException?> toggleMicMuteState() async {
    bool result =
        await PlatformService.invokeMethod(PlatformMethod.toggleMicMuteState);

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Microphone mute/unmute failed",
          description: "Cannot toggle microphone status",
          action: "AUDIO",
          isTerminal: false,
          params: {});
    }
  }

  /// To switch local peer's video on/off.
  /// Pass the bool value to [isOn] to change the current video status
  ///
  /// Refer [switch video guide here](https://www.100ms.live/docs/flutter/v2/features/mute).
  @Deprecated('Use [toggleCameraMuteState]')
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

  /// To switch local peer's video on/off.
  /// This function toggles the current camera state i.e
  /// If camera is unmuted it will get muted
  /// If camera is muted it will get unmuted
  /// Refer [toggle camera state guide here](https://www.100ms.live/docs/flutter/v2/features/mute).
  Future<HMSException?> toggleCameraMuteState() async {
    bool result = await PlatformService.invokeMethod(
        PlatformMethod.toggleCameraMuteState);

    if (result) {
      return null;
    } else {
      return HMSException(
          message: "Camera mute/unmute failed",
          description: "Cannot toggle camera status",
          action: "VIDEO",
          params: {},
          isTerminal: false);
    }
  }

  /// Switch camera to the front or rear mode
  ///
  /// Refer [switch camera guide here](https://www.100ms.live/docs/flutter/v2/features/mute).
  Future<void> switchCamera(
      {HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
      PlatformMethod.switchCamera,
    );
    if (hmsActionResultListener != null) {
      if (result != null && result["error"] != null) {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.switchCamera,
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsActionResultListener.onSuccess(
          methodType: HMSActionResultListenerMethod.switchCamera,
        );
      }
    }
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

  /// To mute the audio of all peers in the room for yourself.
  ///
  /// Audio from other peers will be stopped for the local peer after invoking [muteRoomAudioLocally].
  ///
  /// Note: Other peers can still listen to each other in the room, just you (the local peer) won't listen to any audio from the peers in the room.
  ///
  /// Refer [muteRoomAudioLocally guide here](https://www.100ms.live/docs/flutter/v2/features/mute#mute-remote-peers-locally)
  Future<void> muteRoomAudioLocally() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.muteRoomAudioLocally);
  }

  /// To unmute the audio of all peers in the room for yourself if you had previously invoked [muteRoomAudioLocally].
  ///
  /// Refer [unMuteRoomAudioLocally guide here](https://www.100ms.live/docs/flutter/v2/features/mute#mute-remote-peers-locally)
  Future<void> unMuteRoomAudioLocally() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.unMuteRoomAudioLocally);
  }

  /// To mute the video of all peers in the room for yourself.
  ///
  /// Video from other peers will be stopped for the local peer after invoking [muteRoomVideoLocally].
  ///
  /// Note: Other peers can still see each other in the room, just you (the local peer) won't see any video from the peers in the room.
  ///
  /// Refer [muteRoomVideoLocally guide here](https://www.100ms.live/docs/flutter/v2/features/mute#mute-remote-peers-locally)
  Future<void> muteRoomVideoLocally() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.muteRoomVideoLocally);
  }

  /// To unmute the video of all peers in the room for yourself.
  ///
  /// Video from other peers will be displayed for the local peer after invoking [unMuteRoomVideoLocally] if they were previously muted using [muteRoomVideoLocally].
  ///
  /// Refer [unMuteRoomVideoLocally guide here](https://www.100ms.live/docs/flutter/v2/features/mute#mute-remote-peers-locally)
  Future<void> unMuteRoomVideoLocally() async {
    return await PlatformService.invokeMethod(
        PlatformMethod.unMuteRoomVideoLocally);
  }

  /// Get the [HMSRoom] room object that the local peer has currently joined. Returns null if no room is joined.
  Future<HMSRoom?> getRoom() async {
    var hmsRoomMap = await PlatformService.invokeMethod(PlatformMethod.getRoom);
    if (hmsRoomMap == null) return null;
    return HMSRoom.fromMap(hmsRoomMap);
  }

  /// Returns an instance of the local peer if one existed. A local peer only exists during a preview and an active call. Returns null if no room is joined.
  Future<HMSLocalPeer?> getLocalPeer() async {
    Map? hmsLocalPeerMap =
        await PlatformService.invokeMethod(PlatformMethod.getLocalPeer);
    if (hmsLocalPeerMap == null) return null;
    return HMSLocalPeer.fromMap(hmsLocalPeerMap);
  }

  /// Returns only remote peers. The peer's own instance will not be included in this. To get all peers including the local one consider [getPeers] or for only the local one consider [getLocalPeer]. Returns null if no room is joined.
  Future<List<HMSPeer>?> getRemotePeers() async {
    List? peers =
        await PlatformService.invokeMethod(PlatformMethod.getRemotePeers);
    if (peers == null) return null;
    List<HMSPeer> listOfRemotePeers = [];
    peers.forEach((element) {
      listOfRemotePeers.add(HMSPeer.fromMap(element as Map));
    });
    return listOfRemotePeers;
  }

  /// Returns all peers, remote and local. Returns null if no room is joined.
  Future<List<HMSPeer>?> getPeers() async {
    List? peers = await PlatformService.invokeMethod(PlatformMethod.getPeers);
    if (peers == null) return null;
    List<HMSPeer> listOfPeers = [];
    peers.forEach((element) {
      listOfPeers.add(HMSPeer.fromMap(element as Map));
    });
    return listOfPeers;
  }

  /// Utility Function to parse messages from
  /// [sendBroadcastMessage], [sendGroupMessage], [sendDirectMessage]
  /// to send the HMSMessage object from the server back to the application
  Map<String, dynamic>? _hmsMessageToMap(Map<dynamic, dynamic>? result) {
    return result == null
        ? null
        : {
            'message_id': result["message"]["message_id"],
            'sender': result["message"]["sender"],
            'message': result["message"]["message"],
            'hms_message_recipient': result["message"]["hms_message_recipient"],
            'type': result["message"]["type"],
            'time': result["message"]["time"],
          };
  }

  /// Sends a message to everyone on the call.
  ///
  /// **Parameters**:
  ///
  /// **message** - contains the content of the message.
  ///
  /// **type** - The type of the message, default is chat.
  ///
  /// **hmsActionResultListener** - It contain informs about whether the message was successfully sent, or the kind of error if not.
  ///
  /// Refer [sendBroadcastMesssage guide here](https://www.100ms.live/docs/flutter/v2/features/chat#sending-broadcast-messages)
  Future<void> sendBroadcastMessage(
      {required String message,
      String type = "chat",
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
            arguments: _hmsMessageToMap(result));
      }
    }
  }

  /// Sends a message to all the peers of a role defined in [hmsRolesTo].
  ///
  /// **Parameters**:
  ///
  ///  **hmsRolesTo** - All peers currently in that role will receive the message.
  ///
  /// **message**  - contains the content of the message.
  ///
  /// **type** - The type of the message, default is chat.
  ///
  /// **hmsActionResultListener** - It contain informs about whether the message was successfully sent, or the kind of error if not.
  ///
  /// Refer [sendGroupMessage guide here](https://www.100ms.live/docs/flutter/v2/features/chat#sending-group-messages)
  Future<void> sendGroupMessage(
      {required String message,
      required List<HMSRole> hmsRolesTo,
      String type = "chat",
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
            arguments: _hmsMessageToMap(result));
      }
    }
  }

  /// Sends a message to a particular peer only.
  ///
  ///  **Parameters**:
  ///
  ///  **peerTo** - The one specified [HMSPeer].
  ///
  /// **message** - contains the content of the message.
  ///
  /// **type** - The type of the message, default is chat.
  ///
  /// **hmsActionResultListener** - It contain informs about whether the message was successfully sent, or the kind of error if not.
  ///
  /// Refer [sendDirectMessage guide here](https://www.100ms.live/docs/flutter/v2/features/chat#sending-direct-messages)
  Future<void> sendDirectMessage(
      {required String message,
      required HMSPeer peerTo,
      String type = "chat",
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
            arguments: _hmsMessageToMap(result));
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
  ///
  /// **Parameters**:
  ///
  /// **forPeer** - HMSPeer whose role should be requested to be changed.
  ///
  /// **toRole** - new role the HMSPeer would have if they accept or are forced to change to.
  ///
  /// **force** - Set [force] to false if the peer should be requested to accept the new role (they can choose to deny). Set [force] to true if their role should be changed without asking them.
  ///
  /// **hmsActionResultListener** - Listener that will return HMSActionResultListener.onSuccess if the role change request is successful else will call [HMSActionResultListener.onException] with the error received from the server.
  ///
  /// Refer [changeRoleOfPeer guide here](https://www.100ms.live/docs/flutter/v2/features/change-role#single-peer-role-change).
  Future<void> changeRoleOfPeer(
      {required HMSPeer forPeer,
      required HMSRole toRole,
      bool force = false,
      HMSActionResultListener? hmsActionResultListener}) async {
    var arguments = {
      'peer_id': forPeer.peerId,
      'role_name': toRole.name,
      'force_change': force
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeRoleOfPeer,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result == null)
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.changeRoleOfPeer,
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
            methodType: HMSActionResultListenerMethod.changeRoleOfPeer,
            hmsException: HMSException.fromMap(result["error"]));
    }
  }

  ///Method to change the role of all the peers with the same role
  ///
  /// **Parameters**:
  ///
  /// **toRole** - [toRole] is the role that you wish the peer to be in.
  ///
  /// **ofRoles** - [ofRoles] is a list of roles whose roles you wish to change.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is an object of [HMSActionResultListener] to listen to the success or error callbacks.
  ///
  /// Refer [changeRoleOfPeersWithRoles guide here](https://www.100ms.live/docs/flutter/v2/features/change-role#bulk-role-change).
  void changeRoleOfPeersWithRoles(
      {required HMSRole toRole,
      required List<HMSRole> ofRoles,
      HMSActionResultListener? hmsActionResultListener}) async {
    List<String> ofRolesMap = [];
    ofRoles.forEach((role) => ofRolesMap.add(role.name));
    var arguments = {"to_role": toRole.name, "of_roles": ofRolesMap};
    var result = await PlatformService.invokeMethod(
        PlatformMethod.changeRoleOfPeersWithRoles,
        arguments: arguments);

    if (hmsActionResultListener != null) {
      if (result != null && result["error"] != null) {
        hmsActionResultListener.onException(
            methodType:
                HMSActionResultListenerMethod.changeRoleOfPeersWithRoles,
            arguments: arguments,
            hmsException: HMSException.fromMap(result["error"]));
      } else {
        hmsActionResultListener.onSuccess(
            methodType:
                HMSActionResultListenerMethod.changeRoleOfPeersWithRoles,
            arguments: arguments);
      }
    }
  }

  ///accept the change role request
  ///
  /// When a peer is requested to change their role (see [changeRoleOfPeer]) to accept the new role this has to be called. Once this method is called, the peer's role will be changed to the requested one. The HMSRoleChangeRequest that the SDK had sent to this peer (in HMSUpdateListener.onRoleChangeRequest) to inform them that a role change was requested.
  ///
  /// **Parameters**:
  ///
  /// **hmsRoleChangeRequest** - Pass the [HMSRoleChangeRequest] which will be received from [HMSUpdateListenerMethod.onRoleChangeRequest].
  ///
  /// **hmsActionResultListener** - Listener that will return HMSActionResultListener.onSuccess if the role change request is successful else will call HMSActionResultListener.onException with the error received from the server
  ///
  /// Refer [acceptChangeRole guide here](https://www.100ms.live/docs/flutter/v2/features/change-role#accept-role-change-request)
  Future<void> acceptChangeRole(
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

  /// Preview for a specific Role before changing it.
  ///
  /// By previewing before doing a Role Change, users can see their expected Audio & Video tracks which will be visible to other Peers in Room post changing the Role.
  /// **Parameters**:
  ///
  /// **role** - The new [role] into which the Peer is going to be changed into.
  ///
  /// This returns an object of Future<dynamic> which can be either
  /// of HMSException type or a List<HMSTrack> type based on whether
  /// method execution is completed successfully or not.
  ///
  /// Refer [previewForRole guide here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/change-role)
  Future<dynamic> previewForRole({required String role}) async {
    var arguments = {
      "role_name": role,
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.previewForRole,
        arguments: arguments);

    if (result["success"]) {
      List<HMSTrack> tracks = [];
      (result["data"] as List).forEach((track) {
        tracks.add(track['instance_of']
            ? HMSVideoTrack.fromMap(map: track, isLocal: true)
            : HMSAudioTrack.fromMap(map: track, isLocal: true));
      });

      return tracks;
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  /// Cancel the Previewing for Role invocation.
  /// If a [previewForRole] call was performed previously then calling this method clears the tracks created anticipating a Change of Role
  /// This method only needs to be called if the user declined the request for role change.
  ///
  /// This returns an object of Future<dynamic> which can be either
  /// of HMSException type or a boolean value [true] based on whether
  /// method execution is completed successfully or not.
  ///
  /// Refer the [cancelPreview guide here](https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/peer/change-role)
  Future<dynamic> cancelPreview() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.cancelPreview);

    if (result["success"]) {
      return null;
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }

  /// To change the mute status of a single remote peer's track.
  ///
  /// **Parameters**:
  ///
  /// **forRemoteTrack** - [HMSTrack] which you want to mute/unmute.
  ///
  /// **mute** - Set [mute] to true if the track needs to be muted, false otherwise.
  ///
  /// [hmsActionResultListener] - the callback that would be called by SDK in case of success or failure.
  ///
  ///Refer [changeTrackState guide here](https://www.100ms.live/docs/flutter/v2/features/remote-mute-unmute)
  Future<void> changeTrackState(
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
  ///
  /// **Parameters**:
  ///
  /// **mute** - Set [mute] true if the track needs to be muted, false otherwise.
  ///
  /// **kind** - [kind] is the HMSTrackKind that should be affected. If this and the source are specified, it is considered an AND operation. If not specified, all track sources are affected.
  ///
  /// **source** - [source] is the HMSTrackSource that should be affected. If this and type are specified, it is considered an AND operation. If not specified, all track types are affected.
  ///
  /// **roles** - [roles] is a list of roles, that may have a single item in a list, whose tracks should be affected. If not specified, all roles are affected.
  ///
  /// **hmsActionResultListener** - the callback that would be called by SDK in case of success or failure.
  ///
  /// Refer [changeTrackStateForRole guide here](https://www.100ms.live/docs/flutter/v2/features/remote-mute-unmute)
  Future<void> changeTrackStateForRole(
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

  /// Removes the given peer from the room.
  ///
  /// **Parameters**:
  ///
  /// **peer** - is the HMSRemotePeer that you'd like to be removed from the video call room. reason: is the string that should be conveyed to them as the reason for being removed. hmsActionResultListener: is the listener that will convey the success or error of the server accepting the request.
  ///
  /// **reason** - A [reason] string will be shown to them.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is the callback that would be called by SDK in case of success or failure.
  ///
  /// Refer [removePeer guide here](https://www.100ms.live/docs/flutter/v2/features/remove-peer)
  Future<void> removePeer(
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
  ///
  /// **Parameters**:
  ///
  /// **reason** - [reason] is the reason why the room is being ended.
  ///
  /// **lock** - [lock] bool is whether rejoining the room should be disabled for the foreseeable future.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is the callback that would be called by SDK in case of success or failure
  ///
  /// Refer [endRoom guide here](https://www.100ms.live/docs/flutter/v2/features/end-room)
  Future<void> endRoom(
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
  ///
  /// Parameters:
  ///
  /// **hmsRecordingConfig** - [hmsRecordingConfig] is the HMSRecordingConfig which defines streaming/recording parameters for this start request.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is the callback that would be called by SDK in case of success or failure.
  ///
  ///Refer [RTMP and Recording guide here](https://www.100ms.live/docs/flutter/v2/features/recording)
  Future<void> startRtmpOrRecording(
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
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is the callback that would be called by SDK in case of success or failure.
  ///
  /// Refer [RTMP and Recording guide here](https://www.100ms.live/docs/flutter/v2/features/recording)

  Future<void> stopRtmpAndRecording(
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
  /// [hmsActionResultListener] is a callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  /// Refer [HLS Streaming guide here](https://www.100ms.live/docs/flutter/v2/features/hls)
  Future<HMSException?> startHlsStreaming(
      {HMSHLSConfig? hmshlsConfig,
      HMSActionResultListener? hmsActionResultListener}) async {
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startHlsStreaming,
        arguments: hmshlsConfig?.toMap());
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.hlsStreamingStarted);
        return null;
      } else {
        hmsActionResultListener.onException(
            hmsException: HMSException.fromMap(result["error"]),
            methodType: HMSActionResultListenerMethod.hlsStreamingStarted);
        return HMSException.fromMap(result["error"]);
      }
    }
    return null;
  }

  /// Stops ongoing HLS streaming in the room
  /// [hmsActionResultListener] is a callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  /// Refer [HLS Streaming guide here](https://www.100ms.live/docs/flutter/v2/features/hls)
  Future<void> stopHlsStreaming(
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

  ///Method to send Timed metadata for HLS Stream
  ///
  ///**Parameters**:
  ///
  /// **metadata** - [metadata] the data which you wish to send as metadata
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  ///Refer [send HLS Timed Metadata](https://www.100ms.live/docs/flutter/v2/how-to-guides/record-and-live-stream/hls-player#how-to-send-hls-timed-metadata)
  Future<void> sendHLSTimedMetadata(
      {required List<HMSHLSTimedMetadata> metadata,
      HMSActionResultListener? hmsActionResultListener}) async {
    var args = {"metadata": metadata.map((e) => e.toMap()).toList()};

    var result = await PlatformService.invokeMethod(
        PlatformMethod.sendHLSTimedMetadata,
        arguments: args);

    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.sendHLSTimedMetadata,
            arguments: args);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.sendHLSTimedMetadata,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  /// Change the metadata that appears inside [HMSPeer.metadata]. This change is persistent and all peers joining after the change will still see these values.
  ///
  /// **Parameters**:
  ///
  /// **metadata** - [metadata] is the string data to be set now.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  /// Refer [changeMetadata guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/peer-metadata-update)
  Future<void> changeMetadata(
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

  /// Method to change name of local peer.
  ///
  /// Change the name that appears inside [HMSPeer.name] This change is persistent and all peers joining after the change will still see these values.
  ///
  /// **Parameters**:
  ///
  /// **name** - [name] is the string that is to be set as the [HMSPeer.name].
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is the callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  /// Refer [changeName guide here](https://www.100ms.live/docs/flutter/v2/features/change-user-name)
  Future<void> changeName(
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

  /// Method to start screen share.
  ///
  /// Parameters:
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess] and [HMSActionResultListener.onException] will be called
  ///
  /// `Note: Pass [preferredExtension] and [appGroup] in HMSSDK instance for use screen share (broadcast screen) in iOS.`
  ///
  /// Refer [screen share in android](https://www.100ms.live/docs/flutter/v2/features/screen-share#android-setup)
  ///
  /// Refer [screen share in iOS](https://www.100ms.live/docs/flutter/v2/features/screen-share#i-os-setup)
  ///
  Future<void> startScreenShare(
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
                action:
                    "Enable screen share from the dashboard for the current role",
                isTerminal: false));
      }
    }
  }

  /// A method to check if the screen share is currently active on the device i.e. is this Android device doing screen share Note: This API is not available on iOS.
  ///
  /// Refer [screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share)
  Future<bool> isScreenShareActive() async {
    return await PlatformService.invokeMethod(
      PlatformMethod.isScreenShareActive,
    );
  }

  /// Method to stop screen share
  ///
  /// **Parameter**:
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess] and [HMSActionResultListener.onException] will be called.
  ///
  /// Refer [stop screen share guide here](https://www.100ms.live/docs/flutter/v2/features/screen-share#how-to-stop-screenshare)

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

  ///remove an update listener
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

  ///Method to get all the logs from the SDK
  Future<HMSLogList?> getAllLogs() async {
    var result = await PlatformService.invokeMethod(PlatformMethod.getAllLogs);
    if (result != null) {
      return HMSLogList.fromMap(result);
    }
    return null;
  }

  ///Method to get available audio devices
  ///
  ///Refer [audio output routing guide here](https://www.100ms.live/docs/flutter/v2/features/audio-output-routing)
  Future<List<HMSAudioDevice>> getAudioDevicesList() async {
    List result =
        await PlatformService.invokeMethod(PlatformMethod.getAudioDevicesList);
    return result
        .map((e) => HMSAudioDeviceValues.getHMSAudioDeviceFromName(e))
        .toList();
  }

  ///Method to get current audio output device(Android Only)
  ///
  ///Refer [audio output routing guide here](https://www.100ms.live/docs/flutter/v2/features/audio-output-routing)
  Future<HMSAudioDevice> getCurrentAudioDevice() async {
    if (Platform.isAndroid) {
      var result = await PlatformService.invokeMethod(
          PlatformMethod.getCurrentAudioDevice);
      return HMSAudioDeviceValues.getHMSAudioDeviceFromName(result);
    }
    return HMSAudioDevice.UNKNOWN;
  }

  ///Method to switch audio output device
  ///
  ///**parameter**:
  ///
  ///**audioDevice** - requires [audioDevice] parameter compulsorily for switching Audio Device.
  ///
  ///Refer [audio output routing guide here](https://www.100ms.live/docs/flutter/v2/features/audio-output-routing)
  void switchAudioOutput({required HMSAudioDevice audioDevice}) {
    PlatformService.invokeMethod(PlatformMethod.switchAudioOutput,
        arguments: {"audio_device_name": audioDevice.name});
  }

  ///**** Only for iOS ****
  /// Method to show the native iOS UI for switching the audio output device.
  /// This method natively switches the audio output to the selected device.
  /// Refer [switch audio output iOS UI](https://www.100ms.live/docs/flutter/v2/how-to-guides/configure-your-device/speaker/audio-output-routing#switch-audio-output-device-ui-ios-only)
  void switchAudioOutputUsingiOSUI() {
    if (Platform.isIOS) {
      PlatformService.invokeMethod(PlatformMethod.switchAudioOutputUsingiOSUI);
    }
  }

  ///Method to start audio share of other apps. (Android Only)
  ///
  ///**Parameter**:
  ///
  ///**audioMixingMode** - the modes of type [HMSAudioMixingMode] in which the user wants to stream.
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess] and [HMSActionResultListener.onException] will be called.
  ///
  ///Refer [audio share guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing)
  Future<void> startAudioShare(
      {HMSActionResultListener? hmsActionResultListener,
      HMSAudioMixingMode audioMixingMode =
          HMSAudioMixingMode.TALK_AND_MUSIC}) async {
    if (!Platform.isAndroid) return;
    var result = await PlatformService.invokeMethod(
        PlatformMethod.startAudioShare,
        arguments: {"audio_mixing_mode": audioMixingMode.name});
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.startAudioShare);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.startAudioShare,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  ///Method to stop audio share of other apps. (Android Only)
  ///
  ///**Parameter**:
  ///
  /// **hmsActionResultListener** - [hmsActionResultListener] is a callback instance on which [HMSActionResultListener.onSuccess] and [HMSActionResultListener.onException] will be called.
  ///
  ///Refer [audio share guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing)
  Future<void> stopAudioShare(
      {HMSActionResultListener? hmsActionResultListener}) async {
    if (!Platform.isAndroid) return;
    var result =
        await PlatformService.invokeMethod(PlatformMethod.stopAudioShare);
    if (hmsActionResultListener != null) {
      if (result == null) {
        hmsActionResultListener.onSuccess(
            methodType: HMSActionResultListenerMethod.stopAudioShare);
      } else {
        hmsActionResultListener.onException(
            methodType: HMSActionResultListenerMethod.startAudioShare,
            hmsException: HMSException.fromMap(result["error"]));
      }
    }
  }

  ///Method to change the audio mixing mode of shared audio from other apps. (Android only)
  ///
  ///**Parameter**:
  ///
  ///**audioMixingMode** - To change the audio sharing mode
  ///
  ///Refer [setAudioMixingMode guide here](https://www.100ms.live/docs/flutter/v2/features/audio_sharing#how-to-change-the-audio-mixing-mode)
  void setAudioMixingMode({required HMSAudioMixingMode audioMixingMode}) {
    if (Platform.isAndroid)
      PlatformService.invokeMethod(PlatformMethod.setAudioMixingMode,
          arguments: {"audio_mixing_mode": audioMixingMode.name});
  }

  ///Method to get Track Settings.
  Future<HMSTrackSetting> getTrackSettings() async {
    var result =
        await PlatformService.invokeMethod(PlatformMethod.getTrackSettings);
    HMSTrackSetting trackSetting = HMSTrackSetting.fromMap(result);
    return trackSetting;
  }

  ///Method to destroy HMSSDK instance.
  void destroy() {
    PlatformService.invokeMethod(PlatformMethod.destroy);
  }

  ///Method to toggle the always screen on capabilities(similar to wakelock)
  ///
  ///Refer [always screen on guide here](https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/always-screen-on)
  void toggleAlwaysScreenOn() {
    PlatformService.invokeMethod(PlatformMethod.toggleAlwaysScreenOn);
  }

  ///Method to activate pipMode in the application
  ///
  ///**Parameters**:
  ///
  ///**aspectRatio** - Ratio for PIP window,List of int indicating ratio for PIP window as [width,height]
  ///
  ///**autoEnterPip** - Enable [autoEnterPip] will start pip mode automatically when app minimized.
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  ///
  ///`Note: Minimum version required to support PiP is Android 8.0 (API level 26)`
  @Deprecated('use [HMSPIPAndroidController] class')
  Future<bool> enterPipMode(
      {List<int>? aspectRatio, bool? autoEnterPip}) async {
    final bool? result = await PlatformService.invokeMethod(
        PlatformMethod.enterPipMode,
        arguments: {
          "aspect_ratio": aspectRatio ?? [16, 9],
          "auto_enter_pip": autoEnterPip ?? false
        });
    return result ?? false;
  }

  ///Method to check whether pip mode is active currently
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  @Deprecated('use [HMSPIPAndroidController] class')
  Future<bool> isPipActive() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipActive);
    return result ?? false;
  }

  ///Method to check whether pip mode is available for the current device
  ///
  ///Refer [PIP mode guide here](https://www.100ms.live/docs/flutter/v2/advanced-features/pip-mode)
  @Deprecated('use [HMSPIPAndroidController] class')
  Future<bool> isPipAvailable() async {
    final bool? result =
        await PlatformService.invokeMethod(PlatformMethod.isPipAvailable);
    return result ?? false;
  }

  /// add listener to RTC Stats of the room to diagnose Metrics
  ///
  /// Refer [Call stats guide here](https://www.100ms.live/docs/flutter/v2/features/call-stats)
  void addStatsListener({required HMSStatsListener listener}) {
    PlatformService.addRTCStatsListener(listener);
  }

  /// remove listener to RTC Stats of the room to diagnose Metrics
  ///
  /// Refer [Call stats guide here](https://www.100ms.live/docs/flutter/v2/features/call-stats)
  void removeStatsListener({required HMSStatsListener listener}) {
    PlatformService.removeRTCStatsListener(listener);
  }

  /// To modify local peer's audio & video tracks settings use the [hmsTrackSetting]. Only required for advanced use cases.
  HMSTrackSetting? hmsTrackSetting;

  ///  [HMSIOSScreenshareConfig] is required for starting Screen share (Broadcast screen) from iOS devices like iPhones & iPads. To learn more about Screen Share, refer to the guide [here](https://www.100ms.live/docs/flutter/v2/features/screen-share).
  ///
  /// `Note: You can find appGroup and preferredExtension name in Xcode under Signing and Capabilities section under target > yourExtensionName.`
  HMSIOSScreenshareConfig? iOSScreenshareConfig;

  /// [appGroup] is only used for screen share (broadcast screen) in iOS.
  ///
  /// `Note: appGroup is deprecated use [iOSScreenshareConfig].`
  String? appGroup;

  /// [preferredExtension] is only used for screen share (broadcast screen) in iOS.
  ///
  /// `Note: preferredExtension is deprecated use [iOSScreenshareConfig].`
  String? preferredExtension;

  /// [hmsLogSettings] is used to set the Log Level setting.
  HMSLogSettings? hmsLogSettings;

  bool previewState = false;

  final bool isPrebuilt;
}
