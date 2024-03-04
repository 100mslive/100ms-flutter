///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/local_peer_bottom_sheet.dart';

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
                ///[peerTrackNode] is the peerTrackNode of the peer whose more option is clicked
                ///We only show the modal bottom sheet if the peer is the local peer
                var peerTrackNode = context.read<PeerTrackNode>();
                var meetingStore = context.read<MeetingStore>();
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: HMSThemeColors.surfaceDim,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  context: context,
                  builder: (ctx) => ChangeNotifierProvider.value(
                      value: meetingStore,
                      child: LocalPeerBottomSheet(
                        isInsetTile: isInsetTile,
                        meetingStore: meetingStore,
                        peerTrackNode: peerTrackNode,
                        callbackFunction: callbackFunction,
                      )),
                );
              },
              child: Semantics(
                label:
                    "fl_${context.read<PeerTrackNode>().peer.name}more_option",
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
