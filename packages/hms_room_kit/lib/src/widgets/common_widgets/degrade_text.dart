import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:provider/provider.dart';

///This returns the text (Degraded) if the video track is degraded
class DegradeText extends StatelessWidget {
  const DegradeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false,
        builder: (_, isDegraded, __) {
          return Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.3),
            child: Text(
              isDegraded ? " (Degraded)" : "",
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  color: onSurfaceLowEmphasis,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 20 / 14),
            ),
          );
        });
  }
}
