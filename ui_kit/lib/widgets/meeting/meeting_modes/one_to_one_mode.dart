import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/peer_tile.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_modes/inset_grid_view.dart';
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
        child: Stack(
          children: [
            insetGridView(
                peerTracks: widget.peerTracks
                    .where((element) => !element.peer.isLocal)
                    .toList(),
                itemCount: widget.peerTracks.length - 1,
                screenShareCount: widget.screenShareCount,
                context: context,
                isPortrait: true,
                size: widget.size),
            DraggableWidget(
              topMargin: 10,
              bottomMargin: widget.bottomMargin,
              horizontalSpace: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  width: 123,
                  height: 219,
                  child: ChangeNotifierProvider.value(
                    key: ValueKey(oneToOnePeer?.uid ?? "" "video_view"),
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
