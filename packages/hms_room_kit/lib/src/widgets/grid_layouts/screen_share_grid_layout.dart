///Package imports
library;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_tile.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/side_by_side_layout.dart';

///This renders the tile layout when a remote peer is sharing the screen
///
///So we show the screenshare in the top half of the screen
///and the other peers in the bottom half of the screen with two peers or a single peer in a scrollable page
class ScreenshareGridLayout extends StatefulWidget {
  final List<PeerTrackNode> peerTracks;
  final int screenshareCount;
  final HMSWhiteboardModel? whiteboardModel;
  const ScreenshareGridLayout(
      {super.key,
      required this.peerTracks,
      required this.screenshareCount,
      this.whiteboardModel});

  @override
  State<ScreenshareGridLayout> createState() => _ScreenshareGridLayoutState();
}

class _ScreenshareGridLayoutState extends State<ScreenshareGridLayout> {
  int tilesToBeRendered = 0;
  int tileStartingIndex = 0;

  @override
  Widget build(BuildContext context) {
    ///Here we render screenshare and peer tiles in a Column
    return Selector<WhiteboardScreenshareStore, bool>(
        selector: (_, whiteboardScreenshareStore) =>
            whiteboardScreenshareStore.isFullScreen,
        builder: (_, isFullScreen, __) {
          return Column(
            children: [
              ///This renders the screenshare or whiteboard at the top 2/3 of the screen
              Flexible(
                  flex: 2,
                  child: Column(
                    ///There will not be a case where whiteboard and screenshare are enabled at the same time
                    ///So we check if the whiteboard is enabled and render the whiteboard tile
                    ///Else we render the screenshare tile
                    children: [
                      ///If the whiteboard is enabled we
                      ///render the whiteboard tile we check this with the whiteboardeModel
                      if (widget.whiteboardModel != null &&
                          widget.whiteboardModel?.url != null)
                        Expanded(child: const WhiteboardTile()),

                      ///This renders the screenshare tile based on the
                      ///screenshare count
                      ///Note: This doesn't account for local screenshare since
                      ///we don't render a tile for local screenshare
                      if (widget.screenshareCount > 0)
                        Expanded(
                          child: PageView.builder(
                            physics: isFullScreen
                                ? const NeverScrollableScrollPhysics()
                                : const PageScrollPhysics(),
                            allowImplicitScrolling: true,
                            itemCount: widget.screenshareCount,
                            onPageChanged: (newPage) {
                              context
                                  .read<MeetingStore>()
                                  .setCurrentScreenSharePage(newPage);
                            },

                            ///Setting the scale type for screenshare widget as fit
                            itemBuilder: (context, index) {
                              return ListenablePeerWidget(
                                peerTracks: widget.peerTracks,
                                index: index,
                                scaleType: ScaleType.SCALE_ASPECT_FIT,
                              );
                            },
                          ),
                        ),

                      ///This renders the dots at the bottom of the grid view
                      ///This is only rendered if the number of pages is greater than 1
                      ///The number of dots is equal to [number of screens being shared]
                      ///The active dot is the current page
                      ///The inactive dots are the pages other than the current page
                      if (!isFullScreen && widget.screenshareCount > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Selector<MeetingStore, int>(
                              selector: (_, meetingStore) =>
                                  meetingStore.currentScreenSharePage,
                              builder: (_, currentScreenSharePage, __) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DotsIndicator(
                                    dotsCount: widget.screenshareCount,
                                    position: currentScreenSharePage,
                                    decorator: DotsDecorator(
                                        activeColor: HMSThemeColors
                                            .onSurfaceHighEmphasis,
                                        color: HMSThemeColors
                                            .onSurfaceLowEmphasis),
                                  ),
                                );
                              }),
                        )
                    ],
                  )),

              ///This renders the peer tiles at the bottom half of the screen
              if (!isFullScreen)
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              physics: const PageScrollPhysics(),
                              allowImplicitScrolling: true,
                              onPageChanged: (newPage) {
                                context
                                    .read<MeetingStore>()
                                    .setCurrentPage(newPage);
                              },
                              itemCount: (((widget.peerTracks.length -
                                          widget.screenshareCount) ~/
                                      2) +
                                  (widget.peerTracks.length -
                                          widget.screenshareCount) %
                                      2),
                              itemBuilder: (context, index) {
                                return SideBySideLayout(
                                    numberOfTiles: widget.peerTracks.length -
                                        widget.screenshareCount,
                                    index: index,
                                    peerTracks: widget.peerTracks
                                        .sublist(widget.screenshareCount));
                              },
                            ),
                          ),

                          ///This renders the dots at the bottom of the grid view
                          ///This is only rendered if the number of pages is greater than 1
                          ///The number of dots is equal to [number of peers/2 and if number of peers is not divisible by 2 then we add 1 else we add 0]
                          ///The active dot is the current page
                          ///The inactive dots are the pages other than the current page
                          if (((widget.peerTracks.length -
                                          widget.screenshareCount) ~/
                                      2 +
                                  (widget.peerTracks.length -
                                          widget.screenshareCount) %
                                      2) >
                              1)
                            Selector<MeetingStore, int>(
                                selector: (_, meetingStore) =>
                                    meetingStore.currentPage,
                                builder: (_, currentPage, __) {
                                  int dotsCount = (((widget.peerTracks.length -
                                              widget.screenshareCount) ~/
                                          2) +
                                      (widget.peerTracks.length -
                                              widget.screenshareCount) %
                                          2);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DotsIndicator(
                                        mainAxisSize: MainAxisSize.min,
                                        dotsCount: dotsCount,
                                        position: currentPage > dotsCount
                                            ? 0
                                            : currentPage,
                                        decorator: DotsDecorator(
                                            activeColor: HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            color: HMSThemeColors
                                                .onSurfaceLowEmphasis),
                                      ),
                                    ),
                                  );
                                })
                        ],
                      ),
                    ))
            ],
          );
        });
  }
}
