library;

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_stats_view.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_overlay_options.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_waiting_ui.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HLSPlayer] is a component that is used to show the HLS Player
class HLSPlayer extends StatelessWidget {
  const HLSPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///We use the hlsAspectRatio from the [MeetingStore] to set the aspect ratio of the player
    ///By default the aspect ratio is 9:16
    return Selector<MeetingStore, bool>(
        selector: (_, meetingStore) => meetingStore.hasHlsStarted,
        builder: (_, hasHLSStarted, __) {
          return Stack(
            children: [
              ///Renders the HLS Player if the HLS has started
              ///Otherwise renders the waiting UI
              hasHLSStarted
                  ? Selector<HLSPlayerStore, bool>(
                      selector: (_, hlsPlayerStore) =>
                          hlsPlayerStore.isFullScreen,
                      builder: (_, isFullScreen, __) {
                        return InteractiveViewer(
                          minScale: 1,
                          maxScale: 8,
                          child: Align(
                            alignment: Alignment.center,
                            child: Selector<HLSPlayerStore, Size>(
                                selector: (_, hlsPlayerStore) =>
                                    hlsPlayerStore.hlsPlayerSize,
                                builder: (_, hlsPlayerSize, __) {
                                  return InkWell(
                                    onTap: () => context
                                        .read<HLSPlayerStore>()
                                        .toggleButtonsVisibility(),
                                    splashFactory: NoSplash.splashFactory,
                                    splashColor: HMSThemeColors.backgroundDim,
                                    child: AspectRatio(
                                      aspectRatio: hlsPlayerSize.width /
                                          hlsPlayerSize.height,
                                      child: Selector<HLSPlayerStore, bool>(
                                          selector: (_, hlsPlayerStore) =>
                                              hlsPlayerStore.isFullScreen,
                                          builder: (_, isFullScreen, __) {
                                            return IgnorePointer(
                                              child: const HMSHLSPlayer(
                                                showPlayerControls: false,
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                                }),
                          ),
                        );
                      })
                  : Center(child: const HLSWaitingUI()),

              const HLSStatsView(),

              ///This renders the overlay controls for HLS Player
              Align(
                  alignment: Alignment.center,
                  child: HLSPlayerOverlayOptions(
                    hasHLSStarted: hasHLSStarted,
                  )),

              ///This renders the circular progress indicator when the player is buffering or failed
              Selector<HLSPlayerStore, HMSHLSPlaybackState>(
                selector: (_, hlsPlayerStore) =>
                    hlsPlayerStore.playerPlaybackState,
                builder: (_, state, __) {
                  return state == HMSHLSPlaybackState.BUFFERING ||
                          state == HMSHLSPlaybackState.FAILED
                      ? Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: HMSThemeColors.primaryDefault,
                            strokeWidth: 2,
                          ),
                        )
                      : const SizedBox();
                },
              )
            ],
          );
        });
  }
}
