///Package imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
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
  const ScreenshareGridLayout(
      {super.key, required this.peerTracks, required this.screenshareCount});

  @override
  State<ScreenshareGridLayout> createState() => _ScreenshareGridLayoutState();
}

class _ScreenshareGridLayoutState extends State<ScreenshareGridLayout> {
  int tilesToBeRendered = 0;
  int tileStartingIndex = 0;

  @override
  Widget build(BuildContext context) {
    ///Here we render screenshare and peer tiles in a Column
    return Column(
      children: [
        ///This renders the screenshare at the top half of the screen
        Flexible(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const PageScrollPhysics(),
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
                if (widget.screenshareCount > 1)
                  Selector<MeetingStore, int>(
                      selector: (_, meetingStore) =>
                          meetingStore.currentScreenSharePage,
                      builder: (_, currentScreenSharePage, __) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DotsIndicator(
                            dotsCount: widget.screenshareCount,
                            position: currentScreenSharePage,
                            decorator: DotsDecorator(
                                activeColor:
                                    HMSThemeColors.onSurfaceHighEmphasis,
                                color: HMSThemeColors.onSurfaceLowEmphasis),
                          ),
                        );
                      })
              ],
            )),

        ///This renders the peer tiles at the bottom half of the screen
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
                        context.read<MeetingStore>().setCurrentPage(newPage);
                      },
                      itemCount: (((widget.peerTracks.length -
                                  widget.screenshareCount) ~/
                              2) +
                          (widget.peerTracks.length - widget.screenshareCount) %
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
                  if (((widget.peerTracks.length - widget.screenshareCount) ~/
                              2 +
                          (widget.peerTracks.length - widget.screenshareCount) %
                              2) >
                      1)
                    Selector<MeetingStore, int>(
                        selector: (_, meetingStore) => meetingStore.currentPage,
                        builder: (_, currentPage, __) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: DotsIndicator(
                              dotsCount: (((widget.peerTracks.length -
                                          widget.screenshareCount) ~/
                                      2) +
                                  (widget.peerTracks.length -
                                          widget.screenshareCount) %
                                      2),
                              position: currentPage,
                              decorator: DotsDecorator(
                                  activeColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  color: HMSThemeColors.onSurfaceLowEmphasis),
                            ),
                          );
                        })
                ],
              ),
            ))
      ],
    );
  }
}
