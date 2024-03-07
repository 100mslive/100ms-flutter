///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/name_and_network.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';

///[DegradeTile] is used to show the degrade tile
///when the connection is poor
///The tile is shown when the track is degraded
///The tile is hidden when the track is not degraded
class DegradeTile extends StatelessWidget {
  final BoxConstraints constraints;
  const DegradeTile({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return data
              ? Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        alignment: Alignment.center,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HMSSubheadingText(
                                text: "Poor connection",
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              HMSSubtitleText(
                                text:
                                    "The video will resume\n automatically when the\n connection improves",
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                              )
                            ],
                          ),
                        ),
                      ),
                      NameAndNetwork(maxWidth: constraints.maxWidth),
                    ],
                  ),
                )
              : const SizedBox();
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
