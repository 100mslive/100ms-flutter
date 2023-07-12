//Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/model/peer_track_node.dart';
import 'package:hms_room_kit/widgets/common_widgets/audio_tile.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//Widget for Audio View
Widget audioMode(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required bool isPortrait,
    required BuildContext context,
    required Size size}) {
  return GridView.builder(
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return ChangeNotifierProvider.value(
          key: ValueKey("${peerTracks[index].uid}audio_view"),
          value: peerTracks[index],
          child: AudioTile(
            key: ValueKey("${peerTracks[index].uid}audio_tile"),
            itemHeight: size.height,
            itemWidth: size.width,
          ));
    },
    gridDelegate: SliverStairedGridDelegate(
        startCrossAxisDirectionReversed: true,
        pattern: isPortrait
            ? portraitPattern(peerTracks, size, context)
            : landscapePattern(itemCount, size, context)),
    physics: const PageScrollPhysics(),
    scrollDirection: Axis.horizontal,
  );
}

List<StairedGridTile> portraitPattern(
    List<PeerTrackNode> peerTrack, Size size, BuildContext context) {
  double ratio = Utilities.getHLSRatio(size, context);

  List<StairedGridTile> tiles = [];
  int pinTileCount = 0;
  while ((pinTileCount < peerTrack.length) && peerTrack[pinTileCount].pinTile) {
    tiles.add(StairedGridTile(1, ratio));
    pinTileCount++;
  }
  int tileLeft = (peerTrack.length - pinTileCount) % 6;
  for (int i = 0; i < (peerTrack.length - pinTileCount - tileLeft); i++) {
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

List<StairedGridTile> landscapePattern(
    int itemCount, Size size, BuildContext context) {
  double ratio = Utilities.getHLSRatio(size, context);
  List<StairedGridTile> tiles = [];
  int gridView = itemCount ~/ 2;
  int tileLeft = itemCount - (gridView * 2);
  for (int i = 0; i < (itemCount - tileLeft); i++) {
    tiles.add(StairedGridTile(1, ratio / 0.5));
  }
  if (tileLeft == 1) tiles.add(StairedGridTile(1, ratio));
  return tiles;
}
