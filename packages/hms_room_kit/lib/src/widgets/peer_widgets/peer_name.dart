//Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports

class PeerName extends StatefulWidget {
  final double width;
  const PeerName({super.key, required this.width});

  @override
  State<PeerName> createState() => _PeerNameState();
}

class _PeerNameState extends State<PeerName> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple2<String, bool>>(
        selector: (_, peerTrackNode) =>
            Tuple2(peerTrackNode.peer.name, peerTrackNode.peer.isLocal),
        builder: (_, data, __) {
          return Container(
              constraints: BoxConstraints(maxWidth: widget.width - 80),
              child: HMSSubheadingText(
                text:
                    "${data.item2 ? "You (" : ""}${data.item1.trim()}${data.item2 ? ")" : ""}",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
              ));
        });
  }
}
