import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '100ms Integration Guide'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool res = false;

  void navigate() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (_) => const MeetingPage()));
  }

  static Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ))),
            onPressed: () async => {
              res = await getPermissions(),
              if (res) {navigate()}
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Join',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  String userName = "Enter username here";
  String roomCode = "zhr-seow-tuj"; //Enter your room code here
  Offset position = const Offset(5, 5);
  bool isJoinSuccessful = false;
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

//To know more about HMSSDK setup and initialization checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/install-the-sdk/hmssdk
  void initHMSSDK() async {
    hmsSDK = HMSSDK();
    await hmsSDK.build();
    hmsSDK.addUpdateListener(listener: this);
    var authToken = await hmsSDK.getAuthTokenByRoomCode(roomCode: roomCode);
    if ((authToken is String?) && authToken != null) {
      hmsSDK.join(config: HMSConfig(authToken: authToken, userName: userName));
    } else {
      log("Error in getting auth token");
    }
  }

  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
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
      List<HMSAudioDevice>? availableAudioDevice}) {
    // Checkout the docs about handling onAudioDeviceChanged updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // Checkout the docs for handling the unmute request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/track/remote-mute-unmute
  }

  @override
  void onHMSError({required HMSException error}) {
    // To know more about handling errors please checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/debugging/error-handling
  }

  @override
  void onMessage({required HMSMessage message}) {
    // Checkout the docs for chat messaging here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/chat
  }

  @override
  void onReconnected() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onReconnecting() {
    // Checkout the docs for reconnection handling here: https://www.100ms.live/docs/flutter/v2/how--to-guides/handle-interruptions/reconnection-handling
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // Checkout the docs for handling the peer removal here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/remove-peer
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // Checkout the docs for handling the role change request here: https://www.100ms.live/docs/flutter/v2/how--to-guides/interact-with-room/peer/change-role#accept-role-change-request
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // Checkout the docs for room updates here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // Checkout the docs for handling the updates regarding who is currently speaking here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/show-audio-level
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // Checkout the docs for sessions store here: https://www.100ms.live/docs/flutter/v2/how-to-guides/interact-with-room/room/session-store
  }

  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // Checkout the docs for onPeerListUpdate here: https://www.100ms.live/docs/flutter/v2/how--to-guides/listen-to-room-updates/update-listeners
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        hmsSDK.leave();
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (remotePeerVideoTrack == null)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 1),
                  children: [
                    if (remotePeerVideoTrack != null && remotePeer != null)
                      peerTile(
                          Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                          remotePeerVideoTrack,
                          remotePeer,
                          context),
                    peerTile(
                        Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                        localPeerVideoTrack,
                        localPeer,
                        context)
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          hmsSDK.leave();
                          Navigator.pop(context);
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget peerTile(
      Key key, HMSVideoTrack? videoTrack, HMSPeer? peer, BuildContext context) {
    return Container(
      key: key,
      color: Colors.black,
      child: (videoTrack != null && !(videoTrack.isMute))
// To know more about HMSVideoView checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/overview
          ? HMSVideoView(
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
}
