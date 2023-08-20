import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
                    onPageChanged: (num) {
                      context.read<MeetingStore>().setCurrentPage(num);
                    },
                    itemBuilder: (context, index) =>
                        _generateGrid(data.item2, index, data.item1)),
              ),
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

  Widget _generateGrid(
      int numberOfTiles, int index, List<PeerTrackNode> peerTrackNode) {
    int tileToBeRendered = 0;

    if ((6 * (index + 1) > numberOfTiles)) {
      tileToBeRendered = numberOfTiles - 6 * (index);
    } else {
      tileToBeRendered = 6;
    }

    tileNumber = 6 * index;
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
