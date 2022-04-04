import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class HandRaise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_,metadata,__){
         return  metadata?.contains("\"isHandRaised\":true")??false?
          Positioned(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Image.asset(
              'assets/icons/raise_hand.png',
              color: Colors.amber.shade300,
            ),
          ),
          bottom: 5.0,
          left: 5.0,
        )
      : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
