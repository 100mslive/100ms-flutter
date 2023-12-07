///Package imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/grid_layout.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/screen_share_grid_layout.dart';

///This widget renders the grid view of the meeting screen with inset tile
///The grid view is rendered based on the number of peers in the meeting
///The grid view is rendered using the [PageView] widget
///This has following parameters:
///[isLocalInsetPresent] is used to check if the local inset tile is present or not
class CustomOneToOneGrid extends StatefulWidget {
  final bool isLocalInsetPresent;
  final List<PeerTrackNode>? peerTracks;
  const CustomOneToOneGrid(
      {super.key, this.isLocalInsetPresent = true, this.peerTracks});

  @override
  State<CustomOneToOneGrid> createState() => _CustomOneToOneGridState();
}

class _CustomOneToOneGridState extends State<CustomOneToOneGrid> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    ///The grid view is rendered using the [PageView] widget
    ///The number of pages in the [PageView] is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
    ///One thing to note here is that in this view we filter out the local peer since we are rendering the local peer in the inset tile
    ///The inset tile is rendered at the top of the grid view
    return Selector<MeetingStore,
            Tuple4<List<PeerTrackNode>, int, PeerTrackNode, int>>(
        selector: (_, meetingStore) => Tuple4(
            meetingStore.peerTracks,
            meetingStore.peerTracks.length,
            meetingStore.peerTracks[0],
            meetingStore.screenShareCount),
        builder: (_, data, __) {
          int numberOfPeers = data.item2 - (widget.isLocalInsetPresent ? 1 : 0);
          int pageCount =
              (numberOfPeers ~/ 6) + (numberOfPeers % 6 == 0 ? 0 : 1);

          ///If the remote peer is sharing screen then we render the [ScreenshareGridLayout] with inset tile
          ///Else we render the normal layout with inset tile
          return data.item4 > 0
              ? ScreenshareGridLayout(
                  peerTracks: widget.isLocalInsetPresent
                      ? data.item1
                          .where((element) =>
                              !element.peer.isLocal ||
                              element.track?.source == "SCREEN")
                          .toList()
                      : data.item1,
                  screenshareCount: data.item4,
                )
              :

              ///If no screen is being shared we render the normal layout with inset tile
              Column(
                  children: [
                    Expanded(
                      // child: TextureViewGrid(
                      //     peerTracks: widget.isLocalInsetPresent
                      //         ? data.item1
                      //             .where((element) =>
                      //                 !(element.peer.isLocal) ||
                      //                 element.track?.source == "SCREEN")
                      //             .toList()
                      //         : data.item1),
                      child: PageView.builder(
                          physics: const PageScrollPhysics(),
                          controller: controller,
                          itemCount: pageCount,
                          onPageChanged: (newPage) {
                            context
                                .read<MeetingStore>()
                                .setCurrentPage(newPage);
                          },
                          itemBuilder: (context, index) => GridLayout(
                              numberOfTiles: numberOfPeers,
                              index: index,

                              ///Here we filter out the local peer since we are rendering the local peer in the inset tile iff isLocalInsetPresent is true
                              ///We only take the screenshare or remote peers
                              ///
                              ///If isLocalInsetPresent is false we render all the peers in grid layout
                              ///Since the screenshare case is already handled above the code never reaches here
                              peerTracks: widget.isLocalInsetPresent
                                  ? data.item1
                                      .where((element) =>
                                          !(element.peer.isLocal) ||
                                          element.track?.source == "SCREEN")
                                      .toList()
                                  : data.item1)),
                    ),

                    ///This renders the dots at the bottom of the grid view
                    ///This is only rendered if the number of pages is greater than 1
                    ///The number of dots is equal to [numberOfPeers/6 + (if number of peers is not divisible by 6 then we add 1 else we add 0)]
                    ///The active dot is the current page
                    ///The inactive dots are the pages other than the current page
                    if (pageCount > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Selector<MeetingStore, int>(
                            selector: (_, meetingStore) =>
                                meetingStore.currentPage,
                            builder: (_, currentPage, __) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DotsIndicator(
                                  dotsCount: pageCount,
                                  position:
                                      currentPage > pageCount ? 0 : currentPage,
                                  decorator: DotsDecorator(
                                      activeColor:
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                      color:
                                          HMSThemeColors.onSurfaceLowEmphasis),
                                ),
                              );
                            }),
                      )
                  ],
                );
        });
  }
}
