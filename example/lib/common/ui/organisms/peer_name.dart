import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PeerName extends StatefulWidget {
  @override
  State<PeerName> createState() => _PeerNameState();
}

class _PeerNameState extends State<PeerName> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple3<String, bool, bool>>(
        selector: (_, peerTrackNode) => Tuple3(
            peerTrackNode.peer.name,
            peerTrackNode.track?.isDegraded ?? false,
            peerTrackNode.peer.isLocal),
        builder: (_, data, __) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "${data.item3 ? "You (" : ""}${data.item1}${data.item3 ? ")" : ""} ${data.item2 ? " Degraded" : ""}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
          );
        });
  }
}
