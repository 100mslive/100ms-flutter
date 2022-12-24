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
  String userName = "Enter username here";
  String authToken =
      "Enter your token here";

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
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
            onPressed: () async => {
              if (authToken.isNotEmpty)
                {
                  res = await getPermissions(),
                  if (res)
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (_) => MeetingPage(
                                  authToken: authToken,
                                  userName: userName,
                                )))
                }
              else
                {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                              backgroundColor: Colors.grey,
                              title: Text("Please check the token"),
                            ));
                  })
                }
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
  final String authToken;
  final String userName;
  const MeetingPage(
      {super.key, required this.authToken, required this.userName});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener {
  late HMSSDK hmsSDK;
  Offset position = const Offset(5, 5);
  bool isJoinSuccessful = false, isVideoOn = true, isAudioOn = true;
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;
  int speakerStatus = 0;
  @override
  void initState() {
    super.initState();
    hmsSDK = HMSSDK();
    hmsSDK.build();
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(
        config:
            HMSConfig(authToken: widget.authToken, userName: widget.userName));
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
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    if (updateSpeakers.isEmpty) {
      //If no one is speaking
      speakerStatus = 0;
    } else {
      if (updateSpeakers.length == 2) {
        //If both peers are speaking
        speakerStatus = 2;
      } else if (updateSpeakers[0].peer.peerId == localPeer?.peerId) {
        //If local peer is speaking
        speakerStatus = 3;
      } else {
        //If remote peer is speaking
        speakerStatus = 1;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        hmsSDK.leave();
        hmsSDK.removeUpdateListener(listener: this);
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height-10,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                        height: MediaQuery.of(context).size.height-10,
                    color: Colors.black,
                    child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
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
                              context,
                              (speakerStatus==1 || speakerStatus == 2),
                              ),
                        peerTile(
                            Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                            localPeerVideoTrack,
                            localPeer,
                            context,
                            (speakerStatus==3 || speakerStatus == 2),
                            )
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            hmsSDK.switchAudio(isOn: isAudioOn);
                            setState(() {
                              isAudioOn = !isAudioOn;
                            });
                          },
                          child: Container(
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(60),
                                blurRadius: 3.0,
                                spreadRadius: 5.0,
                              ),
                            ]),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                  isAudioOn
                                      ? Icons.mic_none_outlined
                                      : Icons.mic_off_outlined,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            hmsSDK.switchVideo(isOn: isVideoOn);
                            setState(() {
                              isVideoOn = !isVideoOn;
                            });
                          },
                          child: Container(
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(60),
                                blurRadius: 3.0,
                                spreadRadius: 5.0,
                              ),
                            ]),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                  isVideoOn
                                      ? Icons.videocam_outlined
                                      : Icons.videocam_off_outlined,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            hmsSDK.leave();
                            hmsSDK.removeUpdateListener(listener: this);
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
        ),
      )),
    );
  }

  Widget peerTile(
      Key key, HMSVideoTrack? videoTrack, HMSPeer? peer, BuildContext context,bool isSpeaking) {
    return Container(
      key: key,
      decoration: BoxDecoration(
      color: Color.fromRGBO(0, 0, 0, 1),
      border: Border.all(color:isSpeaking? Colors.yellow:Colors.transparent,width: 2)
      ),
      child: (videoTrack != null && !(videoTrack.isMute))
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
