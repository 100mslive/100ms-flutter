import 'dart:developer';

import 'package:data_store_example/meeting/peer_track_node.dart';
import 'package:data_store_example/utilities.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener, HMSActionResultListener {
  List<PeerTrackNode> nodes = [];
  late HMSSDK _hmssdk;
  bool isAudioOn = true, isVideoOn = true;

  @override
  void initState() {
    super.initState();
    _hmssdk = HMSSDK();
    _hmssdk.build();
    _hmssdk.addUpdateListener(listener: this);
    _hmssdk.join(config: Utilities.getHMSConfig());
  }

  @override
  void onHMSError({required HMSException error}) {
    Utilities.showToast(msg: "${error.message}");
    log(error.message??"");
  }

  //Here we will get track updates after joining the room
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
      setState((() => {}));
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
      setState((() => {}));
    }
  }

//Here we will get all the peer update after joining the room
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        int index =
            nodes.indexWhere((node) => node.uid == "${peer.peerId}mainVideo");
        if (index == -1) {
          if (peer.isLocal) {
            nodes.insert(
                0, PeerTrackNode(peer: peer, uid: "${peer.peerId}mainVideo"));
          } else {
            nodes
                .add(PeerTrackNode(peer: peer, uid: "${peer.peerId}mainVideo"));
          }
        }
        setState((() => {}));
        break;
      case HMSPeerUpdate.peerLeft:
        int index =
            nodes.indexWhere((node) => node.uid == "${peer.peerId}mainVideo");
        if (index != -1) {
          nodes.removeAt(index);
        }
        setState((() => {}));
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

  void leaveMeeting() {
    _hmssdk.removeUpdateListener(listener: this);
    _hmssdk.leave(hmsActionResultListener: this);
    Navigator.pop(context);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                  ),
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
            (nodes.isNotEmpty && nodes[0].peer.isLocal)
                ? Padding(
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
                                  child: Icon(
                                      isAudioOn ? Icons.mic : Icons.mic_off,
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
                                  child:
                                      Icon(Icons.call_end, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void onJoin({required HMSRoom room}) {
    Utilities.showToast(msg: "Room Joined successfully");
  }

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

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
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        log("Error occured ${hmsException.message}");
        break;
    }
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
    }
  }
}
