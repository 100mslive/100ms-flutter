///Dart imports
import 'dart:ui';

///Package imports
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
class DegradeTile extends StatefulWidget {
  const DegradeTile({Key? key}) : super(key: key);

  @override
  State<DegradeTile> createState() => _DegradeTileState();
}

class _DegradeTileState extends State<DegradeTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: data,
              child:
                  LayoutBuilder(builder: (context, BoxConstraints constraints) {
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      ClipRRect(
                        ///Here we are using a backdrop filter to blur the background
                        ///when the connection is poor
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  HMSSubheadingText(
                                    text: "Poor connection",
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.1,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  HMSSubtitleText(
                                    text:
                                        "The video will resume\n automatically when the\n connection improves",
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      NameAndNetwork(maxWidth: constraints.maxWidth),
                    ],
                  ),
                );
              }));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
