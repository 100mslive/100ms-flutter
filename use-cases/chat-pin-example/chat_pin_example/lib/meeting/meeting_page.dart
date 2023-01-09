import 'dart:developer';

import 'package:chat_pin_example/meeting/peer_track_node.dart';
import 'package:chat_pin_example/utilities.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener, HMSActionResultListener {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<PeerTrackNode> nodes = [];
  // HMSSDK instance
  late HMSSDK _hmssdk;

  // Audio and Video state of local peer
  bool isAudioOn = true, isVideoOn = true;

  // Store value of localpeer
  late HMSLocalPeer localPeer;

  //Variable to store session metadata(pin chat)
  String? sessionMetadata;

  //lists of messages
  List<HMSMessage> messages = [];

  // textfield controller
  TextEditingController messageTextController = TextEditingController();

  // listview scrollcontroller
  ScrollController scrollController = ScrollController();

  //variable to hide messages
  bool isMessageVisible = true;

  getSessionMetadata() async {
    //fetching sessionMetadata(current pin message)
    sessionMetadata = await _hmssdk.getSessionMetadata();
    setState(() {});
  }

  _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    _hmssdk = HMSSDK();
    _hmssdk.build();
    _hmssdk.addUpdateListener(listener: this);
    _hmssdk.join(config: Utilities.getHMSConfig());
  }

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onJoin({required HMSRoom room}) {}

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (peer.isLocal) {
      if (trackUpdate == HMSTrackUpdate.trackMuted) {
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          isAudioOn = false;
        } else {
          isVideoOn = false;
        }
      } else if (trackUpdate == HMSTrackUpdate.trackUnMuted) {
        if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
          isAudioOn = true;
        } else {
          isVideoOn = true;
        }
      }
      setState(() {});
    }
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      int index =
          nodes.indexWhere((node) => node.uid == "${peer.peerId}mainVideo");
      if (index != -1) {
        nodes[index].track = track as HMSVideoTrack;
      } else {
        if (track.source == "SCREEN") {
          nodes.add(PeerTrackNode(
              peer: peer,
              uid: "${peer.peerId}${track.trackId}",
              track: track as HMSVideoTrack));
        } else {
          if (peer.isLocal) {
            nodes.insert(
                0,
                PeerTrackNode(
                    peer: peer,
                    uid: "${peer.peerId}mainVideo",
                    track: track as HMSVideoTrack));
          } else {
            nodes.add(PeerTrackNode(
                peer: peer,
                uid: "${peer.peerId}mainVideo",
                track: track as HMSVideoTrack));
          }
        }
      }
      setState(() {});
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        int index =
            nodes.indexWhere((node) => node.uid == "${peer.peerId}mainVideo");
        if (index == -1) {
          nodes.add(PeerTrackNode(peer: peer, uid: "${peer.peerId}mainVideo"));
        }
        setState(() {});
        break;
      case HMSPeerUpdate.peerLeft:
        int index =
            nodes.indexWhere((node) => node.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          nodes.removeAt(index);
        }
        setState(() {});
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
    }
  }

  @override
  void onMessage({required HMSMessage message}) {
    if (message.type == "metadata") {
      getSessionMetadata();
      return;
    }
    // Adding message to list
    messages.add(message);
    _scrollToBottom();
    setState(() {});
  }

  void leaveMeeting() {
    _hmssdk.removeUpdateListener(listener: this);
    _hmssdk.leave(hmsActionResultListener: this);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final heightofEachTile = MediaQuery.of(context).size.height / 2;
    final widthofEachTile = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        leaveMeeting();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisExtent: widthofEachTile,
                      crossAxisSpacing: 5,
                      childAspectRatio: heightofEachTile / widthofEachTile),
                  delegate: SliverChildBuilderDelegate(
                      ((context, index) => (nodes[index].track == null ||
                              nodes[index].track!.isMute)
                          ? Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(20, 23, 28, 1),
                              ),
                              child: Center(
                                child: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    radius: 36,
                                    child: Text(
                                      nodes[index].peer.name[0],
                                      style: const TextStyle(
                                          fontSize: 36, color: Colors.white),
                                    )),
                              ),
                            )
                          : HMSVideoView(
                              key: Key(nodes[index].uid),
                              track: nodes[index].track!,
                              scaleType: ScaleType.SCALE_ASPECT_FILL,
                            )),
                      childCount: nodes.length),
                )
              ],
            ),
            if (nodes.isNotEmpty && nodes[0].peer.isLocal)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    width: widthofEachTile - 20,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(29, 34, 41, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            _hmssdk.switchAudio(isOn: isAudioOn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withAlpha(60),
                                    blurRadius: 3.0,
                                    spreadRadius: 5.0,
                                  ),
                                ]),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.red,
                              child: Icon(isAudioOn ? Icons.mic : Icons.mic_off,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            _hmssdk.switchVideo(isOn: isVideoOn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withAlpha(60),
                                    blurRadius: 3.0,
                                    spreadRadius: 5.0,
                                  ),
                                ]),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.red,
                              child: Icon(
                                  isVideoOn
                                      ? Icons.videocam
                                      : Icons.videocam_off_rounded,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMessageVisible = !isMessageVisible;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withAlpha(60),
                                    blurRadius: 3.0,
                                    spreadRadius: 5.0,
                                  ),
                                ]),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  isMessageVisible ? Colors.red : Colors.grey,
                              child: const Icon(Icons.message,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            leaveMeeting();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
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
            if (nodes.isNotEmpty && isMessageVisible)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 100, left: 10, right: 10),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (itemBuilder, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.purple,
                                              radius: 15,
                                              child: Text(
                                                messages[index].sender!.name[0],
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                messages[index].sender!.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                messages[index].message,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 50,
                                          )
                                        ],
                                      ),
                                      PopupMenuButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              child: const Text(
                                                'Pin Message',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onTap: () {
                                                // Setting session metadata to senderName: Message by calling "setSessionMetadata" method of HMSSDK
                                                _hmssdk.setSessionMetadata(
                                                    metadata:
                                                        "${messages[index].sender!.name}: ${messages[index].message}",
                                                    hmsActionResultListener:
                                                        this);
                                              },
                                            )
                                          ];
                                        },
                                        child: const Icon(
                                          Icons.more_vert_outlined,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 0.5, color: Colors.white),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 75.0,
                                  child: TextField(
                                    controller: messageTextController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 11,
                                            top: 11,
                                            right: 15),
                                        hintText: "Type a Message"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    String message = messageTextController.text;
                                    if (message.isEmpty) return;
                                    _hmssdk.sendBroadcastMessage(
                                        message: message,
                                        hmsActionResultListener: this);
                                    messageTextController.clear();
                                  },
                                  child: const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Send",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            if (isMessageVisible &&
                sessionMetadata != null &&
                sessionMetadata != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 310),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.push_pin_rounded,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 18.5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.66,
                              child: Text(
                                sessionMetadata!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 0.4,
                                    height: 16 / 12,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              // Removing session metadata by setting it value to null.
                              _hmssdk.setSessionMetadata(
                                  metadata: null,
                                  hmsActionResultListener: this);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    log("Error: type: ${methodType.name} hmsException: ${hmsException.message} arguments:$arguments");
  }

  @override
  void onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        _hmssdk.destroy();
        log("Leave room successful");
        break;
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        log("message send successfully");
        if (arguments!['type'] != null && arguments['type'] == "metadata") {
          getSessionMetadata();
          break;
        }
        // creating message if sendBroadcastMessage is success and adding it to messages list.
        HMSMessage message = HMSMessage(
            sender: nodes[0].peer,
            message: arguments['message'],
            type: arguments['type'] ?? "chat",
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: null,
                recipientRoles: null,
                hmsMessageRecipientType: HMSMessageRecipientType.BROADCAST));
        messages.add(message);
        _scrollToBottom();
        setState(() {});
        break;
      case HMSActionResultListenerMethod.setSessionMetadata:
        log("session metadata set successfully");
        getSessionMetadata();
        break;
      default:
        log("Success: type: ${methodType.name} arguments:$arguments");
        break;
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
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}
}
