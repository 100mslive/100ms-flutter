import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/model/peer_track_node.dart';
import 'package:hms_room_kit/widgets/common_widgets/peer_tile.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_modes/basic_grid_view.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_modes/inset_grid_view.dart';
import 'package:provider/provider.dart';

class OneToOneMode extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final BuildContext context;
  final Size size;
  final int screenShareCount;
  final double bottomMargin;
  const OneToOneMode(
      {Key? key,
      required this.peerTracks,
      required this.context,
      required this.size,
      required this.screenShareCount,
      this.bottomMargin = 272})
      : super(key: key);

  @override
  State<OneToOneMode> createState() => _OneToOneModeState();
}

class _OneToOneModeState extends State<OneToOneMode> {
  PeerTrackNode? oneToOnePeer;
  PeerTrackNode? screenPeer;

  @override
  void initState() {
    super.initState();
    if (widget.peerTracks.isNotEmpty) {
      oneToOnePeer =
          widget.peerTracks.firstWhere((element) => element.peer.isLocal);
      oneToOnePeer?.setOffScreenStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:

            ///This case is added to handle the case when there is only one peer(local peer) in the room
            ///Since we cannot create a draggable widget for single peer.
            (widget.peerTracks.length == 1)
                ? basicGridView(
                    peerTracks: widget.peerTracks,
                    itemCount: widget.peerTracks.length,
                    screenShareCount: widget.screenShareCount,
                    context: context,
                    isPortrait: true,
                    size: widget.size)
                : Stack(
                    children: [
                      insetGridView(
                          peerTracks: widget.peerTracks
                              .where((element) =>
                                  !element.peer.isLocal ||
                                  element.track?.source == "SCREEN")
                              .toList(),
                          itemCount: widget.peerTracks.length - 1,
                          screenShareCount: widget.screenShareCount,
                          context: context,
                          isPortrait: true,
                          size: widget.size),
                      DraggableWidget(
                        topMargin: 10,
                        bottomMargin: Platform.isIOS
                            ? widget.bottomMargin + 10
                            : widget.bottomMargin,
                        horizontalSpace: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: SizedBox(
                            width: 123,
                            height: 219,
                            child: ChangeNotifierProvider.value(
                              key: ValueKey(
                                  oneToOnePeer?.uid ?? "" "video_view"),
                              value: oneToOnePeer,
                              child: const PeerTile(
                                isOneToOne: true,
                                itemHeight: 219,
                                itemWidth: 123,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
