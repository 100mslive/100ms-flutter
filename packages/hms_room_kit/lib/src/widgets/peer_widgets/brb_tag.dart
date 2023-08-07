//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports

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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/brb.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        width: 26,
                        semanticsLabel: "brb_label",
                      ),
                    ),
                  ),
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.peer.metadata);
  }
}
