///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/remote_peer_bottom_sheet.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[MoreOption] is a widget that is used to render the more option button on peer tile
class MoreOption extends StatefulWidget {
  const MoreOption({
    Key? key,
  }) : super(key: key);

  @override
  State<MoreOption> createState() => _MoreOptionState();
}

class _MoreOptionState extends State<MoreOption> {
  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    bool mutePermission =
        meetingStore.localPeer?.role.permissions.mute ?? false;
    bool removeOthers =
        meetingStore.localPeer?.role.permissions.removeOthers ?? false;

    return (mutePermission || removeOthers)
        ? Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                ///[peerTrackNode] is the peerTrackNode of the peer whose more option is clicked
                ///We only show the modal bottom sheet if the peer is not the local peer
                var peerTrackNode = context.read<PeerTrackNode>();
                var meetingStore = context.read<MeetingStore>();
                if (peerTrackNode.peer.peerId !=
                    meetingStore.localPeer!.peerId) {
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
                        child: RemotePeerBottomSheet(
                          meetingStore: meetingStore,
                          peerTrackNode: peerTrackNode,
                        )),
                  );
                }
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
          )
        : Container();
  }
}
