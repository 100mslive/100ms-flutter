// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final PeerTrackNode peerTrackNode;
  final bool audioView;

  VideoTile({
    Key? key,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.peerTrackNode,
    required this.audioView,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String name = "";
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    
    bool mutePermission =
        widget.peerTrackNode.peer.role.permissions.mute ?? false;
    bool unMutePermission =
        widget.peerTrackNode.peer.role.permissions.unMute ?? false;
    bool removePeerPermission =
        widget.peerTrackNode.peer.role.permissions.removeOthers ?? false;

    return VisibilityDetector(
      key: Key(widget.peerTrackNode.uid),
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage <= 40) {
          widget.peerTrackNode.isVideoOn = false;
        } else {
          widget.peerTrackNode.isVideoOn =
              !(widget.peerTrackNode.track?.isMute ?? true);
        }
      },
      child: InkWell(
        onLongPress: () {
          if (!mutePermission || !unMutePermission || !removePeerPermission)
            return;
          if (!widget.audioView && (!(widget.peerTrackNode.peer.isLocal)))
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
        child:Container(
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
                    if ((widget.peerTrackNode.track == null) ||
                        !(widget.peerTrackNode.isVideoOn ?? true)) {
                      
                      return Container(
                        height: widget.itemHeight + 100,
                        width: widget.itemWidth - 5,
                        child: Center(child: CircleAvatar(child: Text(Utilities.getAvatarTitle(widget.peerTrackNode.peer.name)))),
                      );
                    }

                    return Container(
                      height: widget.itemHeight + 100,
                      width: widget.itemWidth - 5,
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 15.0),
                      child: HMSVideoView(
                        track: widget.peerTrackNode.track!,
                        setMirror: false,
                        matchParent: false,
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                      "${widget.peerTrackNode.peer.name} ${widget.peerTrackNode.peer.isLocal ? "(You)" : ""}"),
                ),
                (widget.peerTrackNode.peer.metadata ==
                      "{\"isHandRaised\":true}")?
                   Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Image.asset(
                          'assets/icons/raise_hand.png',
                          color: Colors.amber.shade300,
                        ),
                      ),
                      top: 5.0,
                      left: 5.0,
                    ):
                  Container(),
                // Consumer<MeetingStore>(builder: (context, _meetingStore, _) {
                //   print("${_meetingStore.activeSpeakerIds}");
                //   bool isHighestSpeaker =
                //       _meetingStore.isActiveSpeaker(widget.peerTrackNode.uid);
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
