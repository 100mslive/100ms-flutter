///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders six tiles on a page
///The six tiles are rendered in a 3x2 grid
///The tiles look like this
// ╔═══════╦═══════╗
// ║   0   ║   1   ║
// ╠═══════╬═══════╣
// ║   2   ║   3   ║
// ╠═══════╬═══════╣
// ║   4   ║   5   ║
// ╚═══════╩═══════╝
class SixTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const SixTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    ///Here we render three rows with two tiles in each row
    ///The first row contains the tiles with index [startIndex] and [startIndex+1]
    ///The second row contains the tiles with index [startIndex+2] and [startIndex+3]
    ///The third row contains the tiles with index [startIndex+4] and [startIndex+5]
    ///The [ListenablePeerWidget] is used to render the tile
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 1, peerTracks: peerTracks),
            )
          ]),
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 2, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 3, peerTracks: peerTracks),
            )
          ]),
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 4, peerTracks: peerTracks),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              child: ListenablePeerWidget(
                  index: startIndex + 5, peerTracks: peerTracks),
            )
          ]),
        ),
      ],
    );
  }
}
