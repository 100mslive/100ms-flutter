import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/grid_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/screen_share_grid_layout.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CustomOneToOneGrid extends StatefulWidget {
  const CustomOneToOneGrid({super.key});

  @override
  State<CustomOneToOneGrid> createState() => _CustomOneToOneGridState();
}

class _CustomOneToOneGridState extends State<CustomOneToOneGrid> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore,
            Tuple5<List<PeerTrackNode>, int, int, PeerTrackNode, int>>(
        selector: (_, meetingStore) => Tuple5(
            meetingStore.peerTracks,
            meetingStore.peerTracks.length,
            meetingStore.currentPage,
            meetingStore.peerTracks[0],
            meetingStore.screenShareCount),
        builder: (_, data, __) {
          int numberOfPeers = data.item2 - 1;
          int pageCount =
              (numberOfPeers ~/ 6) + (numberOfPeers % 6 == 0 ? 0 : 1);
          return data.item5 > 0
              ? ScreenshareGridLayout(
                  peerTracks: data.item1
                      .where((element) =>
                          !element.peer.isLocal ||
                          element.track?.source == "SCREEN")
                      .toList(),
                  screenshareCount: data.item5,
                )
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                          physics: const PageScrollPhysics(),
                          controller: controller,
                          allowImplicitScrolling: true,
                          itemCount: pageCount,
                          onPageChanged: (num) {
                            context.read<MeetingStore>().setCurrentPage(num);
                          },
                          itemBuilder: (context, index) => GridLayout(
                              numberOfTiles: numberOfPeers,
                              index: index,
                              peerTracks: data.item1
                                  .where((element) =>
                                      !element.peer.isLocal ||
                                      element.track?.source == "SCREEN")
                                  .toList())),
                    ),
                    if (pageCount > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: DotsIndicator(
                          dotsCount: pageCount,
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
}
