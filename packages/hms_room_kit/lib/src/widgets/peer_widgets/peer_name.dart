library;

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[PeerName] is a widget that is used to render the name of the peer
class PeerName extends StatelessWidget {
  final double maxWidth;
  const PeerName({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: maxWidth - 80),
        child: Selector<PeerTrackNode, Tuple2<String, bool>>(
            selector: (_, peerTrackNode) =>
                Tuple2(peerTrackNode.peer.name, peerTrackNode.peer.isLocal),
            builder: (_, data, __) {
              return HMSSubheadingText(
                text: "${data.item1.trim()}${data.item2 ? " (You)" : ""}",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
              );
            }));
  }
}
