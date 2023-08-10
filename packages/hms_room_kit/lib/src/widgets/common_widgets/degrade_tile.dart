//package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';
import 'package:provider/provider.dart';

//Package imports

class DegradeTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final bool isOneToOne;
  final double avatarRadius;
  final double avatarTitleFontSize;

  const DegradeTile(
      {Key? key,
      this.itemHeight = 200,
      this.itemWidth = 200,
      this.isOneToOne = false,
      this.avatarRadius = 36,
      this.avatarTitleFontSize = 36})
      : super(key: key);

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
                  height: widget.itemHeight + 110,
                  width: widget.itemWidth,
                  decoration: BoxDecoration(
                      color: HMSThemeColors.surfaceDim.withOpacity(0.9),
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
                      Positioned(
                        //Bottom left
                        bottom: 5,
                        left: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: HMSThemeColors.backgroundDim
                                  .withOpacity(0.64),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 4, top: 4, bottom: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PeerName(
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  SvgPicture.asset(
                                    'packages/hms_room_kit/lib/src/assets/icons/degraded_network.svg',
                                    height: 20,
                                    semanticsLabel: "fl_network_icon_label",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
