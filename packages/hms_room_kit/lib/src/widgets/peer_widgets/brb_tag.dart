//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';

///[BRBTag] is a widget that is used to render the BRB tag
///BRB stands for Be Right Back
class BRBTag extends StatelessWidget {
  const BRBTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, String?>(
        builder: (_, metadata, __) {
          return metadata?.contains("\"isBRBOn\":true") ?? false
              ? Positioned(
                  top: 5.0,
                  left: 5,
                  child: Semantics(
                    label:
                        "fl_${context.read<PeerTrackNode>().peer.name}_brb_tag",
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HMSThemeColors.secondaryDim),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/brb.svg",
                          width: 19.25,
                          height: 11,
                          semanticsLabel: "brb_label",
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
