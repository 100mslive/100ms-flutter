//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports

class HandRaise extends StatelessWidget {
  const HandRaise({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_, metadata, __) {
          return metadata?.contains("\"isHandRaised\":true") ?? false
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_hand_raise",
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/hand.svg",
                        colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(250, 201, 25, 1), BlendMode.srcIn),
                        height: 30,
                        semanticsLabel: "hand_raise_label",
                      ),
                    ),
                  ),
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
