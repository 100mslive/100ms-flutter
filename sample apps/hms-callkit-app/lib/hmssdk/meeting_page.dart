//Dart imports
import 'dart:developer';

//Package imports
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hms_callkit/utility_functions.dart';
import 'package:hms_callkit/app_navigation/app_router.dart';
import 'package:hms_callkit/hmssdk/hmssdk_interactor.dart';
import 'package:hms_callkit/app_navigation/navigation_service.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class MeetingPage extends StatefulWidget {
  final String? authToken;
  final String userName;
  const MeetingPage({
    super.key,
    this.authToken,
    required this.userName,
  });

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    with WidgetsBindingObserver
    implements HMSUpdateListener, HMSActionResultListener {
  Offset position = const Offset(5, 5);
  bool isJoinSuccessful = false;
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  bool isLocalVideoOn = true, isLocalAudioOn = true;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    joinCall();
  }

  void joinCall() async {
    if (!isJoinSuccessful) {
      HMSSDKInteractor.hmsSDK ??= HMSSDK();
      print("HMSSDK instance created");
      await HMSSDKInteractor.hmsSDK?.build();
      HMSSDKInteractor.hmsSDK?.addUpdateListener(listener: this);
      if (widget.authToken != null) {
        log("Join called...");
        isJoinSuccessful = true;
        HMSSDKInteractor.hmsSDK?.join(
            config: HMSConfig(
                authToken: widget.authToken!, userName: widget.userName));
      } else {
        log("authToken is null");
        NavigationService.instance.pushNamedIfNotCurrent(AppRoute.homePage);
      }
    }
  }

  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onJoin({required HMSRoom room}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
        }
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        }
      }
    });
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (update == HMSPeerUpdate.networkQualityUpdated) {
      return;
    }
    if (update == HMSPeerUpdate.peerJoined) {
      if (!peer.isLocal) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              remotePeer = peer;
            });
          });
        }
      }
    } else if (update == HMSPeerUpdate.peerLeft) {
      if (!peer.isLocal) {
        if (mounted) {
          setState(() {
            remotePeer = null;
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
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      if (trackUpdate == HMSTrackUpdate.trackRemoved) {
        if (peer.isLocal) {
          if (mounted) {
            setState(() {
              localPeerVideoTrack = null;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              remotePeerVideoTrack = null;
            });
          }
        }
        return;
      }
      if (peer.isLocal) {
        if (mounted) {
          setState(() {
            localPeerVideoTrack = track as HMSVideoTrack;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            remotePeerVideoTrack = track as HMSVideoTrack;
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
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onMessage({required HMSMessage message}) {}

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
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

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
              (remotePeerVideoTrack != null && remotePeer != null)
                  ? peerTile(
                      Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                      remotePeerVideoTrack,
                      remotePeer,
                      context,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Waiting for other peer to join",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        ],
                      )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          HMSSDKInteractor.hmsSDK
                              ?.leave(hmsActionResultListener: this);
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.red.withAlpha(60),
                              blurRadius: 3.0,
                              spreadRadius: 5.0,
                            ),
                          ]),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.call_end, color: Colors.white),
                          ),
                        ),
                      ),
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
              DraggableWidget(
                topMargin: 10,
                bottomMargin: 130,
                horizontalSpace: 10,
                child: peerTile(
                    Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                    localPeerVideoTrack,
                    localPeer,
                    context),
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
      isJoinSuccessful = false;
      endAllCalls();
      NavigationService.instance.pushNamedAndRemoveUntil(AppRoute.homePage);
    }
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // TODO: implement onSessionStoreAvailable
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }
}
