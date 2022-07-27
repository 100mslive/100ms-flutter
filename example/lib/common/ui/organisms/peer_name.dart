//Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class PeerName extends StatefulWidget {
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
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4),
            child: Text(
              "${data.item2 ? "You (" : ""}${data.item1.trim()}${data.item2 ? ")" : ""}",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  color: defaultColor,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 20 / 14),
            ),
          );
        });
  }
}
