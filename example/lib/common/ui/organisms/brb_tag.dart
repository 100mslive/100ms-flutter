import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class BRBTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_,metadata,__){
         return  metadata?.contains("\"isBRBOn\":true")??false?
          Positioned(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color:  Colors.red)),
                    child: Text(
                      "BRB",
                      style: TextStyle(color:Colors.red),
                    ),
                  ),
          ),
          top: 10.0,
          right: 5.0,
        )
      : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
