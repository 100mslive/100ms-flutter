//Package imports
import 'package:demo_with_getx_and_100ms/models/User.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';


Widget gridVideoView(
    {required List<Widget> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required Size size}) {
  return GridView.builder(
      shrinkWrap: true,
      cacheExtent: size.width,
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        return peerTracks[index];
      },
      controller: ScrollController(),
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: false,
          pattern: pattern(itemCount, screenShareCount, size)));
}

List<StairedGridTile> pattern(int itemCount, int screenShareCount, Size size) {
  double ratio = (size.height * 0.81) / (size.width);
  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int normalTile = (itemCount - screenShareCount);
  int gridView = normalTile ~/ 4;
  int tileLeft = normalTile - (gridView * 4);
  // for (int i = 0; i < (normalTile - tileLeft); i++) {
  //   tiles.add(StairedGridTile(0.5, ratio));
  // }
  tiles.add(StairedGridTile(0.5, ratio));
  // if (tileLeft == 1) {
  //   tiles.add(StairedGridTile(1, ratio));
  // } else if (tileLeft == 2) {
  //   tiles.add(StairedGridTile(0.5, ratio / 2));
  //   tiles.add(StairedGridTile(0.5, ratio / 2));
  // } else {
  //   tiles.add(StairedGridTile(1 / 3, ratio / 3));
  //   tiles.add(StairedGridTile(1 / 3, ratio / 3));
  //   tiles.add(StairedGridTile(1 / 3, ratio / 3));
  // }
  return tiles;
}
