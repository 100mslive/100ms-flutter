import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/side_by_side_layout.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

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
    return Column(
      children: [
        Flexible(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: const PageScrollPhysics(),
                    allowImplicitScrolling: true,
                    itemCount: widget.screenshareCount,
                    onPageChanged: (num) {
                      context
                          .read<MeetingStore>()
                          .setCurrentScreenSharePage(num);
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
                      onPageChanged: (num) {
                        context.read<MeetingStore>().setCurrentPage(num);
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
