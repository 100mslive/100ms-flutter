//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

class HandRaise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_, metadata, __) {
          return metadata?.contains("\"isHandRaised\":true") ?? false
              ? Positioned(
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_hand_raise",
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SvgPicture.asset(
                        "assets/icons/hand.svg",
                        color: Color.fromRGBO(250, 201, 25, 1),
                        height: 30,
                        semanticsLabel: "hand_raise_label",
                      ),
                    ),
                  ),
                  top: 5,
                  left: 5,
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
