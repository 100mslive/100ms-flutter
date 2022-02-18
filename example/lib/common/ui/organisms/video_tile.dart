// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final PeerTrackNode peerTrackNode;
  final bool audioView;
  final int index;

  VideoTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.peerTrackNode,
    required this.audioView,
    required this.index,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String name = "";
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return VisibilityDetector(
      key: Key(context
          .select<PeerTrackNode, String>((peerTrackNode) => peerTrackNode.uid)),
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction * 100;
        if (visiblePercentage <= 40) {
          context.read<PeerTrackNode>().isVideoOn = false;
        } else {
          context.read<PeerTrackNode>().isVideoOn = !(context
                  .select<PeerTrackNode, HMSVideoTrack?>(
                      (peerTrackNode) => peerTrackNode.track)
                  ?.isMute ??
              true);
        }
      },
      child: InkWell(
        onLongPress: () {
          final peer = context.select<PeerTrackNode, HMSPeer>(
              (peerTrackNode) => peerTrackNode.peer);
          bool mutePermission = peer.role.permissions.mute ?? false;
          bool unMutePermission = peer.role.permissions.unMute ?? false;
          bool removePeerPermission =
              peer.role.permissions.removeOthers ?? false;
          if (!mutePermission || !unMutePermission || !removePeerPermission)
            return;
          if (!widget.audioView &&
              (!(context
                  .select<PeerTrackNode, HMSPeer>(
                      (peerTrackNode) => peerTrackNode.peer)
                  .isLocal)))
            showDialog(
                context: context,
                builder: (_) => Column(
                      children: [
                        // ChangeTrackOptionDialog(
                        //     isAudioMuted:
                        //     filteredList[index].audioTrack?.isMute,
                        //     isVideoMuted: filteredList[index].track == null
                        //         ? true
                        //         : filteredList[index].track?.isMute,
                        //     peerName: filteredList[index].name,
                        //     changeVideoTrack: (mute, isVideoTrack) {
                        //       Navigator.pop(context);
                        //       _meetingStore.changeTrackState(
                        //           filteredList[index].track!, mute);
                        //     },
                        //     changeAudioTrack: (mute, isAudioTrack) {
                        //       Navigator.pop(context);
                        //       _meetingStore.changeTrackState(
                        //           filteredList[index].audioTrack!, mute);
                        //     },
                        //     removePeer: () async {
                        //       Navigator.pop(context);
                        //       var peer = await _meetingStore.getPeer(
                        //           peerId: filteredList[index].peerId);
                        //       _meetingStore.removePeerFromRoom(peer!);
                        //     },
                        //     mute: mutePermission,
                        //     unMute: unMutePermission,
                        //     removeOthers: removePeerPermission),
                      ],
                    ));
        },
        child: Container(
          color: Colors.transparent,
          key: key,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.all(2),
          height: widget.itemHeight + 110,
          width: widget.itemWidth - 5.0,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  HMSVideoTrack? track =
                      context.select<PeerTrackNode, HMSVideoTrack?>(
                          (peerTrackNode) => peerTrackNode.track);

                  bool isVideoOn = (context.select<PeerTrackNode, bool?>(
                          (peerTrackNode) => peerTrackNode.isVideoOn) ??
                      true);
                  if ((track == null) || !isVideoOn) {
                    return Container(
                      height: widget.itemHeight + 100,
                      width: widget.itemWidth - 5,
                      child: Center(
                          child: CircleAvatar(
                              child: Text(Utilities.getAvatarTitle(
                                  context.select<PeerTrackNode, String>(
                                      (peerTrackNode) =>
                                          peerTrackNode.peer.name))))),
                    );
                  }

                  return Container(
                    height: widget.itemHeight + 100,
                    width: widget.itemWidth - 5,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                    child: HMSVideoView(
                      track: track,
                      setMirror: false,
                      matchParent: false,
                    ),
                  );
                },
              ),
              LayoutBuilder(builder: (context, _) {
                final peer = context.select<PeerTrackNode, HMSPeer>(
                    (peerTrackNode) => peerTrackNode.peer);
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("${peer.name} ${peer.isLocal ? "(You)" : ""}"),
                );
              }),
              (context.select<PeerTrackNode, bool>((peerTrackNode) =>
                      peerTrackNode.peer.metadata
                          ?.contains("\"isHandRaised\":true") ??
                      false))
                  ? Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Image.asset(
                          'assets/icons/raise_hand.png',
                          color: Colors.amber.shade300,
                        ),
                      ),
                      top: 5.0,
                      left: 5.0,
                    )
                  : Container(),
              // Consumer<MeetingStore>(builder: (context, _meetingStore, _) {
              //   print("${_meetingStore.activeSpeakerIds}");
              //   bool isHighestSpeaker =
              //       _meetingStore.isActiveSpeaker(data.uid);
              //   return Container(
              //     height: widget.itemHeight + 110,
              //     width: widget.itemWidth - 4,
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             color: isHighestSpeaker ? Colors.blue : Colors.grey,
              //             width: isHighestSpeaker ? 3.0 : 1.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //   );
              // })
            ],
          ),
        ),
      ),
    );
  }
}
