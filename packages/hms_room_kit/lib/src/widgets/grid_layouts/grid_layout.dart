import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/five_tile_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/four_tile_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/six_tile_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/three_tile_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/two_tile_layout.dart';

class GridLayout extends StatefulWidget {
  final int numberOfTiles;
  final int index;
  final List<PeerTrackNode> peerTracks;

  const GridLayout(
      {super.key,
      required this.numberOfTiles,
      required this.index,
      required this.peerTracks});

  @override
  State<GridLayout> createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  int tilesToBeRendered = 0;
  int tileStartingIndex = 0;

  @override
  Widget build(BuildContext context) {
    if ((6 * (widget.index + 1) > widget.numberOfTiles)) {
      tilesToBeRendered = widget.numberOfTiles - 6 * (widget.index);
    } else {
      tilesToBeRendered = 6;
    }

    tileStartingIndex = 6 * widget.index;
    if (tilesToBeRendered == 6) {
      return SixTileLayout(
        peerTracks: widget.peerTracks,
        startIndex: tileStartingIndex,
      );
    }
    switch (tilesToBeRendered % 6) {
      case 1:
        return ListenablePeerWidget(
          peerTracks: widget.peerTracks,
          index: tileStartingIndex,
        );

      case 2:
        return TwoTileLayout(
          peerTracks: widget.peerTracks,
          startIndex: tileStartingIndex,
        );

      case 3:
        return ThreeTileLayout(
          peerTracks: widget.peerTracks,
          startIndex: tileStartingIndex,
        );

      case 4:
        return FourTileLayout(
            peerTracks: widget.peerTracks, startIndex: tileStartingIndex);

      case 5:
        return FiveTileLayout(
            peerTracks: widget.peerTracks, startIndex: tileStartingIndex);
    }
    return SixTileLayout(
        peerTracks: widget.peerTracks, startIndex: tileStartingIndex);
  }
}
