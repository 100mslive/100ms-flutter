///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders four tiles on a page
///Works for all scenarios:
///- Mobile Portrait: 2x2 grid
///- Tablet Portrait: 2x2 grid  
///- Tablet Landscape: 2x2 grid (fits in 2 rows)
///
///Layout (All devices and orientations):
/// ┌──────┬──────┐
/// │   0  │   1  │
/// ├──────┼──────┤
/// │   2  │   3  │
/// └──────┴──────┘
class FourTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const FourTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    // 2x2 grid works perfectly for all scenarios (mobile portrait, tablet portrait, tablet landscape)
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            ),
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
            ),
          ]),
        ),
      ],
    );
  }
}
