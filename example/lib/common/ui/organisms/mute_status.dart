import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MuteStatus extends StatefulWidget {
  @override
  State<MuteStatus> createState() => _MuteStatusState();
}

class _MuteStatusState extends State<MuteStatus> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        selector: (_, peerTrackNode) => peerTrackNode.isMicMuted,
        builder: (_, data, __) {
          print("Built Again");
          return Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:3.0),
              child: data? Icon(Icons.mic_off,color: Colors.red,):Container()
            ),
          );
        });
  }
}
