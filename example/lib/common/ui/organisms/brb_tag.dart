//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class BRBTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_, metadata, __) {
          return metadata?.contains("\"isBRBOn\":true") ?? false
              ? Positioned(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: SvgPicture.asset(
                      "assets/icons/brb.svg",
                      color: Colors.red,
                      width: 35,
                    ),
                  ),
                  top: 30.0,
                  right: 0,
                  left: 0,
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
