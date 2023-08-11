import 'dart:io';

import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/inset_tile.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/basic_grid_view.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/inset_grid_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/inset_collapsed_view.dart';
import 'package:provider/provider.dart';

class ActiveSpeakerMode extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final List<PeerTrackNode> activeSpeakers;
  final BuildContext context;
  final Size size;
  final int screenShareCount;
  final double bottomMargin;
  const ActiveSpeakerMode(
      {Key? key,
      required this.peerTracks,
      required this.activeSpeakers,
      required this.context,
      required this.size,
      required this.screenShareCount,
      this.bottomMargin = 272})
      : super(key: key);

  @override
  State<ActiveSpeakerMode> createState() => _ActiveSpeakerModeState();
}

class _ActiveSpeakerModeState extends State<ActiveSpeakerMode> {
  PeerTrackNode? oneToOnePeer;
  PeerTrackNode? screenPeer;
  bool isMinimized = false;

  @override
  void initState() {
    super.initState();
    if (widget.peerTracks.isNotEmpty) {
      oneToOnePeer =
          widget.peerTracks.firstWhere((element) => element.peer.isLocal);
      oneToOnePeer?.setOffScreenStatus(false);
    }
  }

  void toggleMinimizedView() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            ///This case is added to handle the case when there is only one peer(local peer) in the room
            ///Since we cannot create a draggable widget for single peer.
            (widget.activeSpeakers.length == 0)
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
                          peerTracks: widget.activeSpeakers,
                          itemCount: widget.activeSpeakers.length,
                          screenShareCount: 0,
                          context: context,
                          isPortrait: true,
                          size: widget.size),
                      DraggableWidget(
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
