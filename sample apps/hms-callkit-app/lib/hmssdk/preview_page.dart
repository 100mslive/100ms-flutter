import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hms_callkit/utility_functions.dart';
import 'package:hms_callkit/app_navigation/app_router.dart';
import 'package:hms_callkit/hmssdk/hmssdk_interactor.dart';
import 'package:hms_callkit/app_navigation/navigation_service.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewPage extends StatefulWidget {
  final String? authToken;
  final String userName;
  const PreviewPage({
    super.key,
    this.authToken,
    required this.userName,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    implements HMSPreviewListener, HMSActionResultListener {
  Offset position = const Offset(5, 5);
  bool isPreviewSuccessful = false;
  HMSPeer? localPeer;
  HMSVideoTrack? localPeerVideoTrack;
  bool isLocalVideoOn = true, isLocalAudioOn = true;
  @override
  void initState() {
    super.initState();
    joinCall();
  }

  void joinCall() async {
    HMSSDKInteractor.hmsSDK ??= HMSSDK();
    await HMSSDKInteractor.hmsSDK?.build();
    if (widget.authToken != null) {
      HMSSDKInteractor.hmsSDK?.addPreviewListener(listener: this);
      HMSSDKInteractor.hmsSDK?.preview(
          config: HMSConfig(
              authToken: widget.authToken!, userName: widget.userName));
    } else {
      log("authToken is null");
      NavigationService.instance.pushNamedIfNotCurrent(AppRoute.homePage);
    }
  }

  @override
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        log("Peer is ${peer.toString()}");
        localPeer = peer;
      }
    });
    for (var track in localTracks) {
      if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
        log("Peer track is ${track.toString()}");
        localPeerVideoTrack = track as HMSVideoTrack?;
        isLocalVideoOn = !(localPeerVideoTrack?.isMute ?? false);
      } else {
        isLocalAudioOn = ((track as HMSAudioTrack?)?.isMute ?? false);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    HMSSDKInteractor.hmsSDK?.removePreviewListener(listener: this);
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    log("On peer Update $update");
    if (update == HMSPeerUpdate.networkQualityUpdated) {
      return;
    }
    if (update == HMSPeerUpdate.peerJoined) {
      if (!peer.isLocal) {
        NavigationService.instance.pushNamedAndRemoveUntil(AppRoute.callingPage,
            args: widget.authToken);
      }
    } else if (update == HMSPeerUpdate.peerLeft) {
      if (peer.isLocal) {
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
      }
    }
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    log("On Room Update $update");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        HMSSDKInteractor.hmsSDK?.leave(hmsActionResultListener: this);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              peerTile(Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                  localPeerVideoTrack, localPeer, context,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          HMSSDKInteractor.hmsSDK?.toggleCameraMuteState(),
                          if (mounted)
                            {
                              setState(() {
                                isLocalVideoOn = !isLocalVideoOn;
                              })
                            }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          child: Icon(
                            isLocalVideoOn
                                ? Icons.videocam
                                : Icons.videocam_off_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {
                          HMSSDKInteractor.hmsSDK?.toggleMicMuteState(),
                          if (mounted)
                            {
                              setState(() {
                                isLocalAudioOn = !isLocalAudioOn;
                              })
                            }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          child: Icon(
                            isLocalAudioOn ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Ringing...",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget peerTile(
      Key key, HMSVideoTrack? videoTrack, HMSPeer? peer, BuildContext context,
      {double height = 150, double width = 100}) {
    return Container(
      height: height,
      width: width,
      key: key,
      color: Colors.grey.shade900,
      child: (videoTrack != null && !(videoTrack.isMute))
          ? HMSVideoView(
              scaleType: ScaleType.SCALE_ASPECT_FILL,
              track: videoTrack,
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(4),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Text(
                  peer?.name.substring(0, 1) ?? "D",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }

  @override
  void onException(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    if (methodType == HMSActionResultListenerMethod.leave) {
      log("Error occured in leave");
    }
  }

  @override
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments}) {
    if (methodType == HMSActionResultListenerMethod.leave) {
      endCurrentCall();
      NavigationService.instance.pushNamedIfNotCurrent(AppRoute.homePage);
    }
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }
}
