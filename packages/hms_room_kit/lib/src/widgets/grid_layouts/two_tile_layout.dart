///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders two tiles on a page
///The layout adapts based on device size and orientation:
///- Mobile: Always vertical layout regardless of orientation
///- Tablet/Desktop in landscape: Horizontal layout (Row) to prevent video cropping
///- Tablet/Desktop in portrait: Vertical layout (Column)
///
///Mobile/Portrait Layout:    Tablet/Desktop Landscape Layout:
/// ┌─────────────┐           ┌──────┬──────┐
/// │      0      │           │   0  │   1  │
/// ├─────────────┤           │      │      │
/// │      1      │           │      │      │
/// └─────────────┘           └──────┴──────┘
class TwoTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;

  const TwoTileLayout(
      {super.key, required this.peerTracks, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    // Get the current orientation and screen size
    final orientation = MediaQuery.of(context).orientation;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = orientation == Orientation.landscape;
    
    // Consider devices with width < 600dp as mobile
    // On mobile, always use vertical layout regardless of orientation
    // On larger screens (tablets/desktop), use horizontal layout in landscape
    final isMobile = screenWidth < 600;
    final useHorizontalLayout = !isMobile && isLandscape;

    if (useHorizontalLayout) {
      // Tablet/Desktop in landscape - use horizontal layout to prevent cropping
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
        ],
      );
    } else {
      // Mobile (any orientation) or Tablet/Desktop in portrait - use vertical layout
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ListenablePeerWidget(
                index: startIndex, peerTracks: peerTracks),
          ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListenablePeerWidget(
                index: startIndex + 1, peerTracks: peerTracks),
          ),
        ],
      );
    }
  }
}
