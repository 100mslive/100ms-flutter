import 'package:flutter/cupertino.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class PeerName extends StatefulWidget {
  @override
  State<PeerName> createState() => _PeerNameState();
}

class _PeerNameState extends State<PeerName> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String>(
        selector: (_, peerTrackNode) => peerTrackNode.peer.name,
        builder: (_, name, __) {
          print("Built Again");
          return Align(
            alignment: Alignment.bottomCenter,
            child: Text("${name} ${false ? "(You)" : ""}"),
          );
        });
  }
}
