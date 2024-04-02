///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders the side by side layout
///The side by side layout renders two peers in a row
///If there are more than two peers then it renders two peers in a scrollable Pageview
///If there is only one peer then it renders the peer in the center of the screen
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

    ///Here we check how many tiles we need to render
    ///So if still there are 2 or more tiles to be rendered then we render 2 tiles
    ///else we render a single tile
    ///
    ///This is done to decide which layout we need to render
    if (2 * (index + 1) > numberOfTiles) {
      tilesToBeRendered = numberOfTiles - 2 * (index);
    } else {
      tilesToBeRendered = 2;
    }

    ///This contains the starting index of tile to be rendered
    tileStartingIndex = 2 * index;

    ///Here we render the tile layout based on how many tiles we need to render
    ///If we need to render 1 tile then we render the [ListenablePeerWidget]
    ///If we need to render 2 tiles then we render the two tiles in a row
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
