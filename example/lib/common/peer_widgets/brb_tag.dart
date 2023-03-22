//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

class BRBTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_, metadata, __) {
          return metadata?.contains("\"isBRBOn\":true") ?? false
              ? Positioned(
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_brb_tag",
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SvgPicture.asset(
                        "assets/icons/brb.svg",
                        color: Colors.white,
                        width: 26,
                        semanticsLabel: "brb_label",
                      ),
                    ),
                  ),
                  top: 5.0,
                  left: 5,
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
