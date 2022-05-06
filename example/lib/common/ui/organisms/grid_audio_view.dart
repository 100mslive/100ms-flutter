import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

Widget gridAudioView(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required Size size}) {
  List<Widget> children =
      UtilityComponents.audioTileWidget(itemCount, peerTracks, size);

  return GridView(
    children: children,
    gridDelegate: SliverStairedGridDelegate(
        startCrossAxisDirectionReversed: true,
        pattern: pattern(itemCount, size)),
    physics: PageScrollPhysics(),
    scrollDirection: Axis.horizontal,
  );
}

List<StairedGridTile> pattern(int itemCount, Size size) {
  double ratio = (size.height * 0.81) / (size.width);
  List<StairedGridTile> tiles = [];
  int gridView = itemCount ~/ 6;
  int tileLeft = itemCount - (gridView * 6);
  for (int i = 0; i < (itemCount - tileLeft); i++) {
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
  }
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else if (tileLeft == 2) {
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(0.5, ratio / 2));
  } else if (tileLeft == 3) {
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
  } else if (tileLeft == 4) {
    tiles.add(StairedGridTile(0.5, ratio));
    tiles.add(StairedGridTile(0.5, ratio));
    tiles.add(StairedGridTile(0.5, ratio));
    tiles.add(StairedGridTile(0.5, ratio));
  } else if (tileLeft == 5) {
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
    tiles.add(StairedGridTile(1 / 3, ratio / 1.5));
  }
  return tiles;
}
