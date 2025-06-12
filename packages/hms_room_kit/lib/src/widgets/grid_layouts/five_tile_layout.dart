///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders five tiles on a page
///Layout adapts for tablet landscape (2 rows max):
///- Mobile Portrait: 2x2+1 grid (3 rows)
///- Tablet Portrait: 2x2+1 grid (3 rows)
///- Tablet Landscape: 3+2 layout (2 rows only)
///
///Mobile/Tablet Portrait:     Tablet Landscape:
/// ┌──────┬──────┐           ┌────┬────┬────┐
/// │   0  │   1  │           │ 0  │ 1  │ 2  │
/// ├──────┼──────┤           ├────┼────┴────┤  
/// │   2  │   3  │           │ 3  │    4    │
/// ├──────┴──────┤           └────┴─────────┘
/// │      4      │           
/// └─────────────┘           
class FiveTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const FiveTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    // Check if tablet in landscape (width >= 600 and landscape)
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    final isTabletLandscape = screenWidth >= 600 && orientation == Orientation.landscape;

    if (isTabletLandscape) {
      // Tablet Landscape: 3+2 layout (2 rows only)
      return Column(
        children: [
          Expanded(
            child: Row(children: [
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex, peerTracks: peerTracks),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex + 1, peerTracks: peerTracks),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex + 2, peerTracks: peerTracks),
              ),
            ]),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(children: [
              Expanded(
                child: ListenablePeerWidget(
                    index: startIndex + 3, peerTracks: peerTracks),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: 2,
                child: ListenablePeerWidget(
                    index: startIndex + 4, peerTracks: peerTracks),
              ),
            ]),
          ),
        ],
      );
    } else {
      // Mobile Portrait & Tablet Portrait: 2x2+1 grid (3 rows)
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
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 4),
              child: ListenablePeerWidget(
                  index: startIndex + 4, peerTracks: peerTracks),
            ),
          ),
        ],
      );
    }
  }
}
