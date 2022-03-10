import 'package:flutter/cupertino.dart';
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
    return Selector<PeerTrackNode, Tuple2<String,bool>>(
        selector: (_, peerTrackNode) => Tuple2(peerTrackNode.peer.name,peerTrackNode.track?.isDegraded??true),
        builder: (_, data, __) {
          print("Built Again");
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:3.0),
              child: Text("${data.item1} ${ data.item2? "Degraded" : ""}"),
            ),
          );
        });
  }
}
