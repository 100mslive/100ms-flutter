///Dart imports
library;

import 'dart:io';

///Package imports
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/inset_tile.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/custom_one_to_one_grid.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/inset_collapsed_view.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/empty_room_screen.dart';

///[OneToOneMode] is used to render the meeting screen in inset Tile mode
class OneToOneMode extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final BuildContext context;
  final int screenShareCount;
  final double bottomMargin;
  const OneToOneMode(
      {Key? key,
      required this.peerTracks,
      required this.context,
      required this.screenShareCount,
      this.bottomMargin = 272})
      : super(key: key);

  @override
  State<OneToOneMode> createState() => _OneToOneModeState();
}

class _OneToOneModeState extends State<OneToOneMode> {
  PeerTrackNode? oneToOnePeer;
  PeerTrackNode? screenPeer;
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    if (widget.peerTracks.isNotEmpty) {
      int index =
          widget.peerTracks.indexWhere((element) => element.peer.isLocal);
      if (index != -1) {
        oneToOnePeer = widget.peerTracks[index];
        oneToOnePeer?.setOffScreenStatus(false);
      }
    }
  }

  void toggleMinimizedView() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  @override
  void didUpdateWidget(covariant OneToOneMode oldWidget) {
    ///This is used to find the local peer for inset tile
    if (widget.peerTracks.isNotEmpty) {
      int index =
          widget.peerTracks.indexWhere((element) => element.peer.isLocal);
      if (index != -1) {
        oneToOnePeer = widget.peerTracks[index];
        oneToOnePeer?.setOffScreenStatus(false);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:

            ///This case is added to handle the case when there is only one peer(local peer) in the room
            ///Since we cannot create a draggable widget for single peer.
            ///
            ///This is the case when the local peer is null or it doesn't have audio or videotrack
            (oneToOnePeer == null)
                ? CustomOneToOneGrid(
                    isLocalInsetPresent: false,
                    peerTracks: widget.peerTracks,
                  )

                ///This handles the case where local peer is the only peer in the room with audio or video track
                // : (oneToOnePeer != null && widget.peerTracks.length == 1)
                //     ? ListenablePeerWidget(
                //         peerTracks: [oneToOnePeer!],
                //         index: 0,
                //       )

                ///This handles when the local peer is also present as well as the other peers are also there.
                ///i.e. this handles the normal flow
                : Stack(
                    children: [
                      ///If there is only one peer in the room and the peer is local peer
                      ///we show the empty room screen
                      ///This is the case when the local peer is the only peer in the room
                      ///else we show the normal grid view
                      (widget.peerTracks.length == 1 &&
                              oneToOnePeer != null &&
                              HMSRoomLayout.peerType ==
                                  PeerRoleType.conferencing)
                          ? Center(child: EmptyRoomScreen())
                          : CustomOneToOneGrid(
                              peerTracks: widget.peerTracks,
                            ),
                      DraggableWidget(
                          dragAnimationScale: 1,
                          topMargin: 10,
                          bottomMargin: Platform.isIOS
                              ? widget.bottomMargin + 20
                              : widget.bottomMargin,
                          horizontalSpace: 8,
                          child: isMinimized
                              ? InsetCollapsedView(
                                  callbackFunction: toggleMinimizedView,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: ChangeNotifierProvider.value(
                                    key: ValueKey(
                                        oneToOnePeer?.uid ?? "" "video_view"),
                                    value: oneToOnePeer,
                                    child: InsetTile(
                                      callbackFunction: toggleMinimizedView,
                                    ),
                                  ),
                                ))
                    ],
                  ),
      ),
    );
  }
}
