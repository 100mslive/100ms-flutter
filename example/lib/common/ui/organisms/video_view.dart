import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class VideoView extends StatefulWidget {
  final matchParent;

  final Size? viewSize;

  final bool setMirror;
  final double itemHeight;
  final double itemWidth;

  VideoView(
      {Key? key,
      this.viewSize,
      this.setMirror = false,
      this.matchParent = true,
      this.itemHeight = 200,
      this.itemWidth = 200,})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
     final isVideoOn = context.select<PeerTrackNode,bool>(
            (peerTrackNode)=> peerTrackNode.isVideoOn);
    return Selector<PeerTrackNode, HMSVideoTrack?>(
        builder: (_, track, __) {
         
          print("Video Built Again");
          if ((track == null) || !isVideoOn) {
            return Container(
                height: widget.itemHeight + 100,
                width: widget.itemWidth - 5,
                child: Center(
                    child: CircleAvatar(
                        child: Text(Utilities.getAvatarTitle(
                            context.read<PeerTrackNode>().peer.name)))));
          } else {
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
          }
        },
        selector: (_, peerTrackNode) => peerTrackNode.track);
  }
}
