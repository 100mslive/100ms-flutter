import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

Widget gridActiveSpeakerView(
    {required List<PeerTrackNode> peerTracks,
    required bool audioViewOn,
    required int itemCount,
    required int screenShareOn,
    required Size size}) {
  double ratio = (size.height - 4 * kToolbarHeight) / (size.width - 20);
  return ReorderableBuilder(
      enableDraggable: false,
      enableLongPress: false,
      children: List.generate(
          itemCount,
          (index) => ChangeNotifierProvider.value(
              key: ValueKey(peerTracks[index].uid),
              value: peerTracks[index],
              child: VideoTile(
                key: ValueKey(peerTracks[index].uid),
                audioView: audioViewOn,
                itemHeight: size.height,
                itemWidth: size.width,
              ))),
      builder: (children, scrollController) {
        return GridView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: NeverScrollableScrollPhysics(),
          children: children,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (itemCount == 1) ? 1 : 2,
              childAspectRatio: (itemCount == 2) ? ratio / 2 : ratio),
        );
      });
}
// return StaggeredGridView.count(
//             crossAxisCount: 4,
//             scrollDirection: Axis.horizontal,
//             children: children,
//             controller: scrollController,
//             staggeredTiles: pattern(itemCount, screenShareOn));
// return GridView(
//           scrollDirection: itemCount == 2 ? Axis.vertical : Axis.horizontal,
//           controller: scrollController,
//           physics: PageScrollPhysics(),
//           children: children,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: itemCount > 2 ? 2 : 1,
//               childAspectRatio: (itemCount == 1)
//                   ? 4 / 2.3
//                   : (itemCount == 2)
//                       ? 2.35 / 2
//                       : 2 / 1.15),
//         );

List<StaggeredTile> pattern(int itemCount, int screenShareCount) {
  List<StaggeredTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StaggeredTile.count(4, 2.3));
  }
  int normalTile = (itemCount - screenShareCount);
  int gridView = normalTile ~/ 4;
  int tileLeft = normalTile - (gridView * 4);
  for (int i = 0; i < (normalTile - tileLeft); i++) {
    tiles.add(StaggeredTile.count(2, 1.15));
  }
  if (tileLeft == 1) {
    tiles.add(StaggeredTile.count(4, 2.3));
  } else if (tileLeft == 2) {
    tiles.add(StaggeredTile.count(2, 2.3));
    tiles.add(StaggeredTile.count(2, 2.3));
  } else {
    tiles.add(StaggeredTile.count(2, 1.15));
    tiles.add(StaggeredTile.count(2, 1.15));
    tiles.add(StaggeredTile.count(2, 1.15));
  }
  return tiles;
}
