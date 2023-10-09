//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';

///[HandRaise] is a widget that is used to render the hand raise icon on peer tile
class HandRaise extends StatelessWidget {
  const HandRaise({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, isHandRaised, __) {
          return isHandRaised
              ? Positioned(
                  top: 5,
                  left: 5,
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_hand_raise",
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HMSThemeColors.secondaryDim),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                          height: 25,
                          width: 25,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSecondaryHighEmphasis,
                              BlendMode.srcIn),
                          semanticsLabel: "hand_raise_label",
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.isHandRaised);
  }
}
