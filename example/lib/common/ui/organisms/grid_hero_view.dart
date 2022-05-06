import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

Widget gridHeroView(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required Size size}) {
  List<Widget> children =
      UtilityComponents.videoTileWidget(itemCount, peerTracks, size);
  return GridView(
      shrinkWrap: true,
      physics: PageScrollPhysics(),
      children: children,
      controller: Provider.of<MeetingStore>(context).controller,
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: false,
          pattern: pattern(itemCount, screenShareCount, size)));
}

List<StairedGridTile> pattern(int itemCount, int screenShareCount, Size size) {
  double ratio = (size.width) / (size.height * 0.81);

  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int normalTile = (itemCount - screenShareCount);
  if (normalTile == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else {
    tiles.add(StairedGridTile(1, ratio / 0.8));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
  }
  int gridView = normalTile ~/ 4;
  int tileLeft = normalTile - (gridView * 4);
  for (int i = 0; i < (normalTile - tileLeft - 4); i++) {
    tiles.add(StairedGridTile(0.5, ratio));
  }
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else if (tileLeft == 2) {
    tiles.add(StairedGridTile(1, ratio / 0.5));
    tiles.add(StairedGridTile(1, ratio / 0.5));
  } else {
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
  }
  return tiles;
}
