///Package imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';

///This widget renders the grid view of the meeting screen without inset tile
///The grid view is rendered based on the number of peers in the meeting
///The grid view is rendered using the [PageView] widget
class CustomGridView extends StatefulWidget {
  const CustomGridView({super.key});

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  PageController controller = PageController();
  int tileNumber = 0;

  @override
  Widget build(BuildContext context) {
    ///The grid view is rendered using the [PageView] widget
    ///The number of pages in the [PageView] is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
    return Selector<MeetingStore, Tuple3<List<PeerTrackNode>, int, int>>(
        selector: (_, meetingStore) => Tuple3(meetingStore.peerTracks,
            meetingStore.peerTracks.length, meetingStore.currentPage),
        builder: (_, data, __) {
          int pageCount = (data.item2 ~/ 6) + (data.item2 % 6 == 0 ? 0 : 1);
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                    clipBehavior: Clip.none,
                    physics: const PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    allowImplicitScrolling: true,
                    itemCount: pageCount,
                    onPageChanged: (newPage) {
                      context.read<MeetingStore>().setCurrentPage(newPage);
                    },
                    itemBuilder: (context, index) =>
                        _generateGrid(data.item2, index, data.item1)),
              ),

              ///This renders the dots at the bottom of the grid view
              ///This is only rendered if the number of pages is greater than 1
              ///The number of dots is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
              ///The active dot is the current page
              ///The inactive dots are the pages other than the current page
              if (pageCount > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DotsIndicator(
                    dotsCount:
                        (data.item2 ~/ 6) + (data.item2 % 6 == 0 ? 0 : 1),
                    position: data.item3,
                    decorator: DotsDecorator(
                        activeColor: HMSThemeColors.onSurfaceHighEmphasis,
                        color: HMSThemeColors.onSurfaceLowEmphasis),
                  ),
                )
            ],
          );
        });
  }

  ///This function generates the grid view based on the number of peers in the meeting
  Widget _generateGrid(
      int numberOfTiles, int index, List<PeerTrackNode> peerTrackNode) {
    int tileToBeRendered = 0;

    ///Here we check how many tiles we need to render
    ///So if still there are 6 or more tiles to be rendered then we render 6 tiles
    ///else we render the remaining tiles
    ///
    ///This is done to decide which layout we need to render
    if ((6 * (index + 1) > numberOfTiles)) {
      tileToBeRendered = numberOfTiles - 6 * (index);
    } else {
      tileToBeRendered = 6;
    }

    ///This contains the starting index of tile to be rendered
    tileNumber = 6 * index;

    ///Here we render the tile layout based on how many tiles we need to render
    ///If we need to render 1 tile then we render the [ListenablePeerWidget]
    ///If we need to render 2 tiles then we render the [TwoTileLayout]
    ///If we need to render 3 tiles then we render the [ThreeTileLayout]
    ///If we need to render 4 tiles then we render the [FourTileLayout]
    ///If we need to render 5 tiles then we render the [FiveTileLayout]
    ///If we need to render 6 tiles then we render the [SixTileLayout]
    if (tileToBeRendered == 6) {
      return sixTileLayout(peerTrackNode);
    }
    switch (tileToBeRendered % 6) {
      case 1:
        return singleTileLayout(peerTrackNode);

      case 2:
        return twoTileLayout(peerTrackNode);

      case 3:
        return threeTileLayout(peerTrackNode);

      case 4:
        return fourTileLayout(peerTrackNode);

      case 5:
        return fiveTileLayout(peerTrackNode);
    }
    return sixTileLayout(peerTrackNode);
  }

  Widget sixTileLayout(List<PeerTrackNode> peerTracks) {
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 1, peerTracks)),
            )
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber + 2, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 3, peerTracks)),
            )
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber + 4, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 5, peerTracks)),
            )
          ]),
        ),
      ],
    );
  }

  Widget fiveTileLayout(List<PeerTrackNode> peerTracks) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 1, peerTracks)),
            ),
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber + 2, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 3, peerTracks)),
            ),
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4),
            child: Container(
              child: peerWidget(tileNumber + 4, peerTracks),
            ),
          ),
        ),
      ],
    );
  }

  Widget fourTileLayout(List<PeerTrackNode> peerTracks) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 1, peerTracks)),
            ),
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Row(children: [
            Expanded(
              child: Container(child: peerWidget(tileNumber + 2, peerTracks)),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(child: peerWidget(tileNumber + 3, peerTracks)),
            ),
          ]),
        ),
      ],
    );
  }

  Widget threeTileLayout(List<PeerTrackNode> peerTracks) {
    return Column(
      children: [
        Expanded(
          child: Container(child: peerWidget(tileNumber, peerTracks)),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Container(child: peerWidget(tileNumber + 1, peerTracks)),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Container(child: peerWidget(tileNumber + 2, peerTracks)),
        ),
      ],
    );
  }

  Widget twoTileLayout(List<PeerTrackNode> peerTracks) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(child: peerWidget(tileNumber, peerTracks)),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(child: peerWidget(tileNumber + 1, peerTracks)),
          ),
        ],
      ),
    );
  }

  Widget singleTileLayout(List<PeerTrackNode> peerTracks) {
    return Container(child: peerWidget(tileNumber, peerTracks));
  }

  Widget peerWidget(int index, List<PeerTrackNode> peerTracks) {
    return ChangeNotifierProvider.value(
        key: ValueKey("${peerTracks[index].uid}video_view"),
        value: peerTracks[index],
        child: PeerTile(
          key: ValueKey("${peerTracks[index].uid}audio_view"),
        ));
  }
}
