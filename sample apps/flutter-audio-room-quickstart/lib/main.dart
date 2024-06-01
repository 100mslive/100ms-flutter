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
      home: const MyHomePage(title: '100ms Audio Room Guide'),
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

    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                'Join Audio Room',
                style: TextStyle(fontSize: 20, color: Colors.white),
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
    implements HMSUpdateListener, HMSActionResultListener {
  late HMSSDK _hmsSDK;

  //Enter the username and authToken from dashboard for the corresponding role here.
  String userName = "Enter username here";

  ///For speaker role roomCode: "yim-wofo-ytk"
  ///For listener role roomCode: "iai-nkis-oob"
  String roomCode = "yim-wofo-ytk";
  Offset position = const Offset(5, 5);
  bool isJoinSuccessful = false;
  final List<PeerTrackNode> _listeners = [];
  final List<PeerTrackNode> _speakers = [];
  bool _isMicrophoneMuted = false;
  HMSPeer? _localPeer;

  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

//To know more about HMSSDK setup and initialization checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/install-the-sdk/hmssdk
  void initHMSSDK() async {
    _hmsSDK = HMSSDK();
    await _hmsSDK.build();
    _hmsSDK.addUpdateListener(listener: this);
    var authToken = await _hmsSDK.getAuthTokenByRoomCode(roomCode: roomCode);
    if ((authToken is String?) && authToken != null) {
      _hmsSDK.join(config: HMSConfig(authToken: authToken, userName: userName));
    } else {
      log("Error in getting auth token");
    }
  }

  @override
  void dispose() {
    //We are clearing the room state here
    _speakers.clear();
    _listeners.clear();
    super.dispose();
  }

  //Here we will be getting updates about peer join, leave, role changed, name changed etc.
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (peer.isLocal) {
      _localPeer = peer;
    }
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == "${peer.peerId}speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            } else {
              _speakers.add(PeerTrackNode(
                uid: "${peer.peerId}speaker",
                peer: peer,
              ));
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == "${peer.peerId}listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            } else {
              _listeners.add(
                  PeerTrackNode(uid: "${peer.peerId}listener", peer: peer));
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.peerLeft:
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == "${peer.peerId}speaker");
            if (index != -1) {
              _speakers.removeAt(index);
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == "${peer.peerId}listener");
            if (index != -1) {
              _listeners.removeAt(index);
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        if (peer.role.name == "speaker") {
          //This means previously the user must be a listener earlier in our case
          //So we remove the peer from listener and add it to speaker list
          int index = _listeners
              .indexWhere((node) => node.uid == "${peer.peerId}listener");
          if (index != -1) {
            _listeners.removeAt(index);
          }
          _speakers.add(PeerTrackNode(
            uid: "${peer.peerId}speaker",
            peer: peer,
          ));
          if (peer.isLocal) {
            _isMicrophoneMuted = peer.audioTrack?.isMute ?? true;
          }
          setState(() {});
        } else if (peer.role.name == "listener") {
          //This means previously the user must be a speaker earlier in our case
          //So we remove the peer from speaker and add it to listener list
          int index = _speakers
              .indexWhere((node) => node.uid == "${peer.peerId}speaker");
          if (index != -1) {
            _speakers.removeAt(index);
          }
          _listeners.add(PeerTrackNode(
            uid: "${peer.peerId}listener",
            peer: peer,
          ));
          setState(() {});
        }
        break;
      case HMSPeerUpdate.metadataChanged:
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == "${peer.peerId}speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == "${peer.peerId}listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.nameChanged:
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == "${peer.peerId}speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == "${peer.peerId}listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.defaultUpdate:
        // TODO: Handle this case.
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        // TODO: Handle this case.
        break;
      case HMSPeerUpdate.handRaiseUpdated:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    switch (peer.role.name) {
      case "speaker":
        int index =
            _speakers.indexWhere((node) => node.uid == "${peer.peerId}speaker");
        if (index != -1) {
          _speakers[index].audioTrack = track;
        } else {
          _speakers.add(PeerTrackNode(
              uid: "${peer.peerId}speaker", peer: peer, audioTrack: track));
        }
        if (peer.isLocal) {
          _isMicrophoneMuted = track.isMute;
        }
        setState(() {});
        break;
      case "listener":
        int index = _listeners
            .indexWhere((node) => node.uid == "${peer.peerId}listener");
        if (index != -1) {
          _listeners[index].audioTrack = track;
        } else {
          _listeners.add(PeerTrackNode(
              uid: "${peer.peerId}listener", peer: peer, audioTrack: track));
        }
        setState(() {});
        break;
      default:
        //Handle the case if you have other roles in the room
        break;
    }
  }

  @override
  void onJoin({required HMSRoom room}) {
    //Checkout the docs about handling onJoin here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/join#join-a-room
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        _localPeer = peer;
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == "${peer.peerId}speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            } else {
              _speakers.add(PeerTrackNode(
                uid: "${peer.peerId}speaker",
                peer: peer,
              ));
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == "${peer.peerId}listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            } else {
              _listeners.add(
                  PeerTrackNode(uid: "${peer.peerId}listener", peer: peer));
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
      }
    });
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
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {
    // TODO: implement onPeerListUpdate
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    // TODO: implement onSessionStoreAvailable
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // Checkout the docs for handling the updates regarding who is currently speaking here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/show-audio-level
  }

  /// ******************************************************************************************************************************************************
  /// Action result listener methods

  @override
  void onException(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        log("Not able to leave error occured");
        break;
      default:
        break;
    }
  }

  @override
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        _hmsSDK.removeUpdateListener(listener: this);
        _hmsSDK.destroy();
        break;
      default:
        break;
    }
  }

  /// ******************************************************************************************************************************************************
  /// Functions

  final List<Color> _colors = [
    Colors.amber,
    Colors.blue.shade600,
    Colors.purple,
    Colors.lightGreen,
    Colors.redAccent
  ];

  final RegExp _REGEX_EMOJI = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  String _getAvatarTitle(String name) {
    if (name.contains(_REGEX_EMOJI)) {
      name = name.replaceAll(_REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return '😄';
      }
    }
    List<String>? parts = name.trim().split(" ");
    if (parts.length == 1) {
      name = parts[0][0];
    } else if (parts.length >= 2) {
      name = parts[0][0];
      if (parts[1] == "" || parts[1] == " ") {
        name += parts[0][1];
      } else {
        name += parts[1][0];
      }
    }
    return name.toUpperCase();
  }

  Color _getBackgroundColour(String name) {
    if (name.isEmpty) return Colors.blue.shade600;
    if (name.contains(_REGEX_EMOJI)) {
      name = name.replaceAll(_REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return Colors.blue.shade600;
      }
    }
    return _colors[name.toUpperCase().codeUnitAt(0) % _colors.length];
  }

  /// ******************************************************************************************************************************************************

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _hmsSDK.leave(hmsActionResultListener: this);
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        body: Container(
          color: Colors.grey.shade900,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  /**
                   * We have a custom scroll view to display listeners and speakers
                   * we have divided them in two sections namely listeners and speakers
                   * On the top we show all the speakers, then we have a listener
                   * section where we show all the listeners in the room.
                   */
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Text(
                          "Speakers",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      //This is the list of all the speakers
                      /**
                       * UI is something like this:    
                       *    
                       *         CircleAvatar Widget
                       *         SizedBox  
                       *         Name of the peer(Text)
                       * 
                       * We have 4 speakers in a row defined by crossAxisCount
                       * in gridDelegate
                       */
                      SliverGrid.builder(
                          itemCount: _speakers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {},
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: _getBackgroundColour(
                                        _speakers[index].peer.name),
                                    child: Text(
                                      _getAvatarTitle(
                                          _speakers[index].peer.name),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _speakers[index].peer.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, mainAxisSpacing: 5)),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Text(
                          "Listener",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      //This is the list of all the speakers
                      /**
                       * UI is something like this:    
                       *    
                       *         CircleAvatar Widget
                       *         SizedBox  
                       *         Name of the peer(Text)
                       * 
                       * We have 5 listeners in a row defined by crossAxisCount
                       * in gridDelegate
                       */
                      SliverGrid.builder(
                          itemCount: _listeners.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {},
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: _getBackgroundColour(
                                          _listeners[index].peer.name),
                                      child: Text(
                                        _getAvatarTitle(
                                            _listeners[index].peer.name),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _listeners[index].peer.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 5, crossAxisCount: 5)),
                    ],
                  ),
                ),
              ),
              //This section takes care of the leave button and the microphone mute/unmute option
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          _hmsSDK.leave(hmsActionResultListener: this);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '✌️ Leave quietly',
                          style: TextStyle(color: Colors.redAccent),
                        )),
                    const Spacer(),
                    //We only show the mic icon if a peer has permission to publish audio
                    if (_localPeer?.role.publishSettings?.allowed
                            .contains("audio") ??
                        false)
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              padding: EdgeInsets.zero,
                              shape: const CircleBorder()),
                          onPressed: () {
                            _hmsSDK.toggleMicMuteState();
                            setState(() {
                              _isMicrophoneMuted = !_isMicrophoneMuted;
                            });
                          },
                          child: Icon(
                            _isMicrophoneMuted ? Icons.mic_off : Icons.mic,
                            color:
                                _isMicrophoneMuted ? Colors.red : Colors.green,
                          )),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class PeerTrackNode {
  String uid;
  HMSPeer peer;
  bool isRaiseHand;
  HMSTrack? audioTrack;
  PeerTrackNode(
      {required this.uid,
      required this.peer,
      this.audioTrack,
      this.isRaiseHand = false});

  @override
  String toString() {
    return 'PeerTrackNode{uid: $uid, peerId: ${peer.peerId},track: $audioTrack}';
  }
}
