import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class NetworkIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int?>(
        builder: (_, networkQuality, __) {
          return Positioned(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Image.asset(
                'assets/icons/network_$networkQuality.png',
                color: Colors.amber.shade300,
              ),
            ),
            bottom : 5.0,
            right: 5.0,
          );
        },
        selector: (_, peerTrackNode) => peerTrackNode.networkQuality);
  }
}
