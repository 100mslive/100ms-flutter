import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
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
              style: HMSTextStyle.setTextStyle(
                  fontWeight: FontWeight.w400,
                  color: HMSThemeColors.onSurfaceLowEmphasis,
                  fontSize: 14,
                  letterSpacing: 0.25,
                  height: 20 / 14),
            ),
          );
        });
  }
}
