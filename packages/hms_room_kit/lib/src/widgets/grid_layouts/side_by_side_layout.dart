import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

class SideBySideLayout extends StatelessWidget {
  final int numberOfTiles;
  final int index;
  final List<PeerTrackNode> peerTracks;
  const SideBySideLayout(
      {super.key,
      required this.numberOfTiles,
      required this.index,
      required this.peerTracks});

  @override
  Widget build(BuildContext context) {
    int tilesToBeRendered = 0;
    int tileStartingIndex = 0;

    if (2 * (index + 1) > numberOfTiles) {
      tilesToBeRendered = numberOfTiles - 2 * (index);
    } else {
      tilesToBeRendered = 2;
    }

    tileStartingIndex = 2 * index;

    return tilesToBeRendered == 2
        ? Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: tileStartingIndex, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: tileStartingIndex + 1, peerTracks: peerTracks),
            )
          ])
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4),
            child: ListenablePeerWidget(
                index: tileStartingIndex, peerTracks: peerTracks),
          );
  }
}
