///Package imports
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/common/constants.dart';
import 'package:hms_room_kit/src/service/app_secrets.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/hms_prebuilt_options.dart';
import 'package:hms_room_kit/src/hmssdk_interactor.dart';
import 'package:hms_room_kit/src/service/app_debug_config.dart';

class HMSStore extends ChangeNotifier
    implements HMSPreviewListener, HMSLogListener {
  HMSStore({required String roomCode, HMSPrebuiltOptions? options}) {
    hmsSDKInteractor = HMSSDKInteractor(
        iOSScreenshareConfig: options?.iOSScreenshareConfig,
        joinWithMutedAudio: AppDebugConfig.joinWithMutedAudio,
        joinWithMutedVideo: AppDebugConfig.joinWithMutedVideo,
        isSoftwareDecoderDisabled: AppDebugConfig.isSoftwareDecoderDisabled,
        isAudioMixerDisabled: AppDebugConfig.isAudioMixerDisabled);

    hmsSDKInteractor.build();
  }

  ///Store Variables

  ///[hmsSDKInteractor] can be used for calling SDK methods
  late HMSSDKInteractor hmsSDKInteractor;

  ///To store the room object
  HMSRoom? room;

  ///To store the local peer
  HMSPeer? localPeer;



  ///HMSPreviewListener overrides.....................................................................................
  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onHMSError({required HMSException error}) {
    // TODO: implement onHMSError
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    log("onPreview-> room: ${room.toString()}");
    this.room = room;
    for (HMSPeer each in room.peers!) {
      if (each.isLocal) {
        localPeer = each;
        if (each.role.name.indexOf("hls-") == 0) {
          isHLSLink = true;
        }
        if (!each.role.publishSettings!.allowed.contains("video")) {
          isVideoOn = false;
        }
        peerCount = room.peerCount;
        notifyListeners();
        break;
      }
    }
    List<HMSVideoTrack> videoTracks = [];
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        isVideoOn = !(track.isMute);
        videoTracks.add(track as HMSVideoTrack);
      }
      if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
        isAudioOn = !(track.isMute);
      }
    }
    this.localTracks = videoTracks;
    Utilities.saveStringData(key: "meetingLink", value: meetingUrl);
    getRoles();
    getCurrentAudioDevice();
    getAudioDevicesList();
    notifyListeners();
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  ///................................................................................................................

  ///HMSLogListener overrides.....................................................................................

  @override
  void onLogMessage({required HMSLogList hmsLogList}) {
    // TODO: implement onLogMessage
  }

  ///................................................................................................................

  Future<HMSException?> startPreview(
      {required String userName, required String meetingLink}) async {
    String? tokenEndPoint;
    String? initEndPoint;

    if (meetingLink.contains("app.100ms.live")) {
      List<String?>? roomData = RoomService().getCode(meetingLink);

      //If the link is not valid then we might not get the code and whether the link is a
      //PROD or QA so we return the error in this case
      if (roomData == null || roomData.isEmpty) {
        return HMSException(
            message: "Invalid meeting URL",
            description: "Provided meeting URL is invalid",
            action: "Please Check the meeting URL",
            isTerminal: false);
      }

      //qaTokenEndPoint is only required for 100ms internal testing
      //It can be removed and should not affect the join method call
      //For _endPoint just pass it as null
      //the endPoint parameter in getAuthTokenByRoomCode can be passed as null
      tokenEndPoint = roomData[1] == "true" ? null : qaTokenEndPoint;
      initEndPoint = roomData[1] == "true" ? "" : qaInitEndPoint;

      Constant.meetingCode = roomData[0] ?? '';
    } else {
      Constant.meetingCode = meetingLink;
    }

    //We use this to get the auth token from room code
    dynamic tokenData = await hmsSDKInteractor.getAuthTokenByRoomCode(
        roomCode: Constant.meetingCode, endPoint: tokenEndPoint);

    if ((tokenData is String?) && tokenData != null) {
      HMSConfig roomConfig = HMSConfig(
          authToken: tokenData,
          userName: userName,
          captureNetworkQualityInPreview: true,
          // endPoint is only required by 100ms Team. Client developers should not use `endPoint`
          //This is only for 100ms internal testing, endPoint can be safely removed from
          //the HMSConfig for external usage
          endPoint: initEndPoint);
      hmsSDKInteractor.startHMSLogger(
          Constant.webRTCLogLevel, Constant.sdkLogLevel);
      hmsSDKInteractor.addPreviewListener(this);
      hmsSDKInteractor.preview(config: roomConfig);
      Constant.meetingUrl = meetingLink;
      return null;
    }
    return tokenData;
  }
}
