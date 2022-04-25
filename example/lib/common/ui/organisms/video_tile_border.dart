import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class VideoTileBorder extends StatelessWidget {
  double itemHeight;
  double itemWidth;
  VideoTileBorder({required this.itemHeight, required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Selector<PeerTrackNode,bool>(
      selector: (_,peerTrackNode) => peerTrackNode.isHighestSpeaker,
      builder: (_,isHighestSpeaker,__) {
        return Container(
          height: itemHeight + 110,
          width: itemWidth - 4,
          decoration: BoxDecoration(
              border: Border.all(color: isHighestSpeaker?Colors.blue:Colors.grey, width: isHighestSpeaker?3.0:1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        );
      }
    );
  }
}
