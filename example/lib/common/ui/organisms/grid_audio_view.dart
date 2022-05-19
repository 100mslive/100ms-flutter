import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

Widget gridAudioView(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required Size size}) {
  return GridView.builder(
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return ChangeNotifierProvider.value(
          key: ValueKey(peerTracks[index].uid),
          value: peerTracks[index],
          child: AudioTile(
            key: ValueKey(peerTracks[index].uid),
            itemHeight: size.height,
            itemWidth: size.width,
          ));
    },
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
