import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/local_peer_bottom_sheet.dart';
import 'package:provider/provider.dart';

class InsetTileMoreOption extends StatelessWidget {
  final Function()? callbackFunction;
  const InsetTileMoreOption({super.key, this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 5,
      child: GestureDetector(
        onTap: () {
          var peerTrackNode = context.read<PeerTrackNode>();
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: HMSThemeColors.surfaceDim,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            context: context,
            builder: (ctx) => ChangeNotifierProvider.value(
                value: context.read<MeetingStore>(),
                child: LocalPeerBottomSheet(
                  meetingStore: context.read<MeetingStore>(),
                  peerTrackNode: peerTrackNode,
                  callbackFunction: callbackFunction,
                )),
          );
        },
        child: Semantics(
          label: "fl_${context.read<PeerTrackNode>().peer.name}more_option",
          child: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: HMSThemeColors.backgroundDim.withOpacity(0.64),
            ),
            child: Center(
              child: Icon(
                Icons.more_vert,
                color: HMSThemeColors.onSurfaceHighEmphasis,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
