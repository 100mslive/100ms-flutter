//package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/name_and_network.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';
import 'package:provider/provider.dart';

//Package imports

class DegradeTile extends StatelessWidget {
  final double maxWidth;

  const DegradeTile({Key? key,required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: data,
              child:
                  LayoutBuilder(builder: (context, BoxConstraints constraints) {
                return Container(
                 
                  decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDefault,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      Align(
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
                      NameAndNetwork(maxWidth: maxWidth)
                      ],
                  ),
                );
              }));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
