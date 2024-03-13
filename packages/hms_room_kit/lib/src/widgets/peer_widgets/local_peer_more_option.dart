///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';

///[LocalPeerMoreOption] is a widget that is used to render the more option button on a local peer(inset) tile
///This is used in the [LocalPeerTile]
///It has following parameters:
///[callbackFunction] is a function that is called when the more option button is clicked
class LocalPeerMoreOption extends StatelessWidget {
  final Function()? callbackFunction;
  final bool isInsetTile;
  const LocalPeerMoreOption(
      {super.key, this.callbackFunction, this.isInsetTile = true});

  @override
  Widget build(BuildContext context) {
    return (Constant.prebuiltOptions?.userName != null && !isInsetTile)
        ? const SizedBox()
        : Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                context.read<MeetingStore>().switchCamera();
              },
              child: Semantics(
                label:
                    "fl_${context.read<PeerTrackNode>().peer.name}more_option",
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: HMSThemeColors.backgroundDim.withOpacity(0.64),
                  ),
                  child: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                    fit: BoxFit.scaleDown,
                    semanticsLabel: "fl_switch_camera",
                  ),
                ),
              ),
            ),
          );
  }
}
