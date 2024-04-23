library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_player_seekbar.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';

///[HLSViewerBottomNavigationBar] is the bottom navigation bar for the HLS Viewer
class HLSViewerBottomNavigationBar extends StatelessWidget {
  const HLSViewerBottomNavigationBar({super.key});


  String _setTimeFromLive(Duration time) {
    int minutes = time.inMinutes;
    int seconds = time.inSeconds.remainder(60);

    return
        "-${minutes > 0 ? "${minutes.toString().padLeft(2, '0')}:" : ""}${seconds.toString().padLeft(2, '0')}s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(64)])),
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12),

        ///Here we render the chat component if the chat is opened
        ///We also render the leave button, hand raise button, chat button and the menu button
        child: Column(
          children: [
            ///Chat Component only visible when the chat is opened
            // if (HMSRoomLayout.chatData != null)
            //   Selector<HLSPlayerStore, bool>(
            //       selector: (_, hlsPlayerStore) => hlsPlayerStore.isChatOpened,
            //       builder: (_, isChatOpened, __) {
            //         if (isChatOpened) {
            //           Provider.of<MeetingStore>(context, listen: true)
            //               .isNewMessageReceived = false;
            //         }
            //         return isChatOpened
            //             ? const OverlayChatComponent()
            //             : Container();
            //       }),

            ///Bottom Navigation Bar
            ///We render the leave button, hand raise button, chat button and the menu button
            ///We only render the bottom navigation bar when the stream controls are visible
            Selector<HLSPlayerStore, bool>(
                selector: (_, hlsPlayerStore) =>
                    hlsPlayerStore.areStreamControlsVisible,
                builder: (_, areStreamControlsVisible, __) {
                  return areStreamControlsVisible
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///This renders the go live/live button
                            Selector<HLSPlayerStore, bool>(
                                selector: (_, hlsPlayerStore) =>
                                    hlsPlayerStore.isLive,
                                builder: (_, isLive, __) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => {
                                          if (!isLive)
                                            {
                                              HMSHLSPlayerController
                                                  .seekToLivePosition()
                                            }
                                        },
                                        child: isLive
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: SvgPicture.asset(
                                                      "packages/hms_room_kit/lib/src/assets/icons/red_dot.svg",
                                                      height: 8,
                                                      width: 8,
                                                    ),
                                                  ),
                                                  HMSTitleText(
                                                      text: "LIVE",
                                                      textColor: HMSThemeColors
                                                          .onSurfaceHighEmphasis)
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: SvgPicture.asset(
                                                      "packages/hms_room_kit/lib/src/assets/icons/red_dot.svg",
                                                      height: 8,
                                                      width: 8,
                                                      colorFilter: ColorFilter.mode(
                                                          HMSThemeColors
                                                              .onSurfaceLowEmphasis,
                                                          BlendMode.srcIn),
                                                    ),
                                                  ),
                                                  HMSTitleText(
                                                      text: "GO LIVE",
                                                      textColor: HMSThemeColors
                                                          .onSurfaceMediumEmphasis),
                                                  Selector<HLSPlayerStore,
                                                          Duration>(
                                                      selector:
                                                          (_, hlsPlayerStore) =>
                                                              hlsPlayerStore
                                                                  .timeFromLive,
                                                      builder: (_, timeFromLive,
                                                          __) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0),
                                                          child: HMSTitleText(
                                                            text: _setTimeFromLive(timeFromLive),
                                                            textColor:
                                                                HMSThemeColors
                                                                    .baseWhite,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        );
                                                      })
                                                ],
                                              ),
                                      )
                                    ],
                                  );
                                }),

                            ///This renders the minimize/maximize button
                            ///to toggle the full screen mode
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Selector<HLSPlayerStore, bool>(
                                      selector: (_, hlsPlayerStore) =>
                                          hlsPlayerStore.isFullScreen,
                                      builder: (_, isFullScreen, __) {
                                        return InkWell(
                                          onTap: () => context
                                              .read<HLSPlayerStore>()
                                              .toggleFullScreen(),
                                          child: SvgPicture.asset(
                                              "packages/hms_room_kit/lib/src/assets/icons/${isFullScreen ? "minimize" : "maximize"}.svg"),
                                        );
                                      })
                                ])
                          ],
                        )
                      : const SizedBox();
                }),

            Selector<HLSPlayerStore, bool>(
                selector: (_, hlsPlayerStore) =>
                    hlsPlayerStore.areStreamControlsVisible,
                builder: (_, areStreamControlsVisible, __) {
                  return areStreamControlsVisible?Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4 ),
                    child: HLSPlayerSeekbar(),
                  ):const SizedBox();
                })
          ],
        ),
      ),
    );
  }
}
